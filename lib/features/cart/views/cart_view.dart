import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/cart_controller.dart';
import '../../../controllers/main_controller.dart';
import '../../../core/auth/auth_action.dart';
import '../../../core/auth/auth_guard.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/cards_widgets.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/mock_data.dart';
import '../../../models/models.dart';
import '../../../routes/app_routes.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: canPop,
        leading: canPop
            ? IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_rounded),
              )
            : null,
        title: const Text(
          'My Cart',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          Obx(
            () => cart.items.isNotEmpty
                ? TextButton(
                    onPressed: cart.clear,
                    child: const Text(
                      'Clear',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (cart.items.isEmpty) {
          return EmptyState(
            icon: Icons.shopping_bag_outlined,
            title: AppStrings.emptyCart,
            subtitle: AppStrings.emptyCartSubtitle,
            actionLabel: AppStrings.continueShopping,
            onAction: () => Get.find<MainController>().changeTab(0),
          );
        }

        final grouped = cart.groupedByVendor;

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                children: [
                  ...grouped.entries.map(
                    (entry) => _VendorSection(
                      vendorName: entry.key,
                      items: entry.value,
                    ),
                  ),
                  _CouponSection(cart: cart),
                  _PriceSummary(cart: cart),
                ],
              ),
            ),
            _CheckoutBar(cart: cart),
          ],
        );
      }),
    );
  }
}

class _VendorSection extends StatelessWidget {
  final String vendorName;
  final List<CartItemModel> items;

  const _VendorSection({
    required this.vendorName,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 8),
          child: Row(
            children: [
              const Icon(Icons.storefront_outlined,
                  size: 18, color: AppColors.primaryDark),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  vendorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
              Text(
                '${items.length} item${items.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        ...items.map(
          (item) => _CartItemTile(item: item, cart: cart),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final CartController cart;

  const _CartItemTile({
    required this.item,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.productId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => cart.removeItem(item.productId),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: item.image,
                width: 72,
                height: 72,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.unit,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        AppUtils.formatPrice(item.price),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      if (item.originalPrice > item.price) ...[
                        const SizedBox(width: 6),
                        Text(
                          AppUtils.formatPrice(item.originalPrice),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () => cart.removeItem(item.productId),
                  icon: const Icon(Icons.close_rounded, size: 18),
                  visualDensity: VisualDensity.compact,
                  color: AppColors.textHint,
                ),
                QuantityStepper(
                  quantity: item.quantity,
                  onChanged: (q) {
                    if (q == 0) {
                      cart.removeItem(item.productId);
                    } else {
                      cart.setQuantity(item.productId, q);
                    }
                  },
                  size: 28,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CouponSection extends StatelessWidget {
  final CartController cart;

  const _CouponSection({required this.cart});

  void _showCoupons() {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.65,
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Apply Coupon',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: MockData.coupons
                      .map(
                        (c) => OfferCard(
                          coupon: c,
                          onApply: () {
                            AuthGuard.require(
                              action: AuthAction.coupons,
                              onAuthenticated: () {
                                cart.applyCoupon(c);
                                Get.back();
                              },
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final coupon = cart.appliedCoupon.value;
      return GestureDetector(
        onTap: _showCoupons,
        child: Container(
          margin: const EdgeInsets.only(top: 8, bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            border: Border.all(
              color: coupon != null
                  ? AppColors.primary
                  : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.local_offer_outlined,
                color: coupon != null
                    ? AppColors.primaryDark
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coupon != null
                          ? '${coupon.code} applied'
                          : 'Apply Coupon',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      coupon != null
                          ? coupon.title
                          : 'Save more on your order',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (coupon != null)
                TextButton(
                  onPressed: cart.removeCoupon,
                  child: const Text(
                    'Remove',
                    style: TextStyle(color: AppColors.error),
                  ),
                )
              else
                const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      );
    });
  }
}

class _PriceSummary extends StatelessWidget {
  final CartController cart;

  const _PriceSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            _priceRow('Subtotal', cart.subtotal),
            _priceRow(
              'Delivery Fee',
              cart.deliveryFee,
              subtitle: cart.deliveryFee == 0 ? 'FREE' : null,
            ),
            _priceRow('Tax (5%)', cart.tax),
            if (cart.discount > 0)
              _priceRow(
                'Discount',
                -cart.discount,
                valueColor: AppColors.success,
              ),
            const Divider(height: 24),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Use Qwiko Wallet',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
              subtitle: Text(
                'Balance: ${AppUtils.formatPrice(MockData.user.walletBalance)}',
                style: const TextStyle(fontSize: 12),
              ),
              value: cart.useWallet.value,
              activeThumbColor: AppColors.primary,
              onChanged: (v) => cart.useWallet.value = v,
            ),
            if (cart.walletDeduction > 0)
              _priceRow(
                'Wallet',
                -cart.walletDeduction,
                valueColor: AppColors.success,
              ),
            const Divider(height: 24),
            _priceRow(
              'Total',
              cart.total,
              isBold: true,
              fontSize: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(
    String label,
    double amount, {
    String? subtitle,
    Color? valueColor,
    bool isBold = false,
    double fontSize = 14,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
                    fontSize: fontSize,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            AppUtils.formatPrice(amount.abs()),
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              fontSize: fontSize,
              color: valueColor ??
                  (amount < 0 ? AppColors.success : AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  final CartController cart;

  const _CheckoutBar({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.fromLTRB(
          16,
          12,
          16,
          12 + MediaQuery.paddingOf(context).bottom,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${cart.itemCount} item${cart.itemCount == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  AppUtils.formatPrice(cart.total),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: PrimaryButton(
                label: AppStrings.checkout,
                icon: Icons.arrow_forward_rounded,
                onPressed: () => AuthGuard.requireRoute(
                      AppRoutes.checkout,
                      action: AuthAction.checkout,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
