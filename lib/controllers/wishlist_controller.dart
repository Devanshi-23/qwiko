import 'package:get/get.dart';
import '../core/utils/app_utils.dart';
import '../data/mock_data.dart';
import '../models/category_model.dart' show ProductModel;

class WishlistController extends GetxController {
  final wishlistIds = <String>{}.obs;

  bool isWishlisted(String id) => wishlistIds.contains(id);

  void toggle(String productId) {
    if (wishlistIds.contains(productId)) {
      wishlistIds.remove(productId);
      AppUtils.showToast('Removed from wishlist');
    } else {
      wishlistIds.add(productId);
      AppUtils.showToast('Added to wishlist');
    }
  }

  List<ProductModel> get products => MockData.products
      .where((p) => wishlistIds.contains(p.id))
      .map((p) => p.copyWith(isWishlisted: true))
      .toList();
}
