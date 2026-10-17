import 'package:get/get.dart';
import '../core/utils/app_utils.dart';
import '../data/mock_data.dart';
import '../models/category_model.dart';
import '../models/models.dart';

class CartController extends GetxController {
  final items = <CartItemModel>[].obs;
  final appliedCoupon = Rxn<CouponModel>();
  final useWallet = false.obs;

  int get itemCount => items.fold(0, (s, i) => s + i.quantity);

  double get subtotal => items.fold(0.0, (s, i) => s + i.total);

  double get deliveryFee {
    if (items.isEmpty) return 0;
    if (appliedCoupon.value?.type == 'delivery') return 0;
    return subtotal >= 199 ? 0 : 29;
  }

  double get tax => subtotal * 0.05;

  double get discount {
    final coupon = appliedCoupon.value;
    if (coupon == null) return 0;
    if (subtotal < coupon.minOrder) return 0;
    if (coupon.type == 'flat') return coupon.maxDiscount;
    if (coupon.type == 'delivery') return 0;
    final pct = subtotal * (coupon.discountPercent / 100);
    return pct > coupon.maxDiscount ? coupon.maxDiscount : pct;
  }

  double get walletDeduction {
    if (!useWallet.value) return 0;
    final remaining = subtotal + deliveryFee + tax - discount;
    return remaining > MockData.user.walletBalance
        ? MockData.user.walletBalance
        : remaining;
  }

  double get total {
    final t = subtotal + deliveryFee + tax - discount - walletDeduction;
    return t < 0 ? 0 : t;
  }

  Map<String, List<CartItemModel>> get groupedByVendor {
    final map = <String, List<CartItemModel>>{};
    for (final item in items) {
      map.putIfAbsent(item.vendorName, () => []).add(item);
    }
    return map;
  }

  int quantityOf(String productId) {
    final item = items.firstWhereOrNull((i) => i.productId == productId);
    return item?.quantity ?? 0;
  }

  void addProduct(ProductModel product, {int qty = 1}) {
    final existing = items.firstWhereOrNull((i) => i.productId == product.id);
    if (existing != null) {
      existing.quantity += qty;
      items.refresh();
    } else {
      items.add(CartItemModel(
        productId: product.id,
        name: product.name,
        image: product.images.first,
        vendorId: product.vendorId,
        vendorName: product.vendorName,
        price: product.price,
        originalPrice: product.originalPrice,
        unit: product.unit,
        quantity: qty,
      ));
    }
    AppUtils.showToast('${product.name} added to cart');
  }

  void setQuantity(String productId, int qty) {
    if (qty <= 0) {
      items.removeWhere((i) => i.productId == productId);
      return;
    }
    final existing = items.firstWhereOrNull((i) => i.productId == productId);
    if (existing != null) {
      existing.quantity = qty;
      items.refresh();
    } else {
      final product = MockData.productById(productId);
      if (product != null) addProduct(product, qty: qty);
    }
  }

  void removeItem(String productId) {
    items.removeWhere((i) => i.productId == productId);
  }

  void applyCoupon(CouponModel coupon) {
    if (subtotal < coupon.minOrder) {
      AppUtils.showToast(
        'Min order ${AppUtils.formatPrice(coupon.minOrder)} required',
        isError: true,
      );
      return;
    }
    appliedCoupon.value = coupon;
    AppUtils.showToast('Coupon ${coupon.code} applied!');
  }

  void removeCoupon() {
    appliedCoupon.value = null;
  }

  void clear() {
    items.clear();
    appliedCoupon.value = null;
    useWallet.value = false;
  }
}
