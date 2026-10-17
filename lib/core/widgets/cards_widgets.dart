import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../models/category_model.dart';
import '../../models/models.dart';
import '../../routes/app_routes.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';
import '../utils/app_utils.dart';
import 'common_widgets.dart';

class BannerCarousel extends StatefulWidget {
  final List<BannerModel> banners;

  const BannerCarousel({super.key, required this.banners});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.banners.length,
          options: CarouselOptions(
            height: 160,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (i, _) => setState(() => _index = i),
          ),
          itemBuilder: (_, i, __) {
            final b = widget.banners[i];
            return ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusL),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: b.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const LoadingShimmer(height: 160),
                    errorWidget: (_, __, ___) => Container(
                      color: AppColors.primaryLight,
                      child: const Icon(Icons.image),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.65),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          b.subtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        AnimatedSmoothIndicator(
          activeIndex: _index,
          count: widget.banners.length,
          effect: const WormEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: AppColors.primaryDark,
            dotColor: AppColors.border,
          ),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback? onTap;

  const CategoryCard({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    final bg = AppColors.categoryGradients[
        category.colorIndex % AppColors.categoryGradients.length];
    return GestureDetector(
      onTap: onTap ??
          () => Get.toNamed(AppRoutes.categoryDetail, arguments: category.id),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [bg, Colors.white],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(8),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(category.icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 4),
              Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${category.itemCount}+',
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(
          begin: const Offset(0.95, 0.95),
          curve: Curves.easeOut,
        );
  }
}

class VendorCard extends StatelessWidget {
  final VendorModel vendor;
  final bool horizontal;

  const VendorCard({
    super.key,
    required this.vendor,
    this.horizontal = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.storeDetail, arguments: vendor.id),
      child: Container(
        width: horizontal ? 220 : double.infinity,
        margin: EdgeInsets.only(right: horizontal ? 12 : 0, bottom: horizontal ? 0 : 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppConstants.radiusL),
              ),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: vendor.banner,
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const LoadingShimmer(height: 110),
                  ),
                  if (vendor.offer.isNotEmpty)
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          vendor.offer,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendor.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      RatingWidget(rating: vendor.rating),
                      const SizedBox(width: 8),
                      Icon(Icons.access_time,
                          size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 2),
                      Text(
                        AppUtils.deliveryLabel(vendor.deliveryTimeMins),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${vendor.distanceKm} km • ${vendor.category}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final int quantity;
  final ValueChanged<int>? onQuantityChanged;
  final VoidCallback? onWishlist;
  final double width;
  /// Unique tag for Hero transition. Must be unique in the current route
  /// subtree — omit when the same product may appear more than once.
  final String? heroTag;

  const ProductCard({
    super.key,
    required this.product,
    this.quantity = 0,
    this.onQuantityChanged,
    this.onWishlist,
    this.width = 160,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.productDetail,
        arguments: {
          'id': product.id,
          if (heroTag != null) 'heroTag': heroTag,
        },
      ),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withValues(alpha: 0.8),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _ProductImage(
                  url: product.images.first,
                  heroTag: heroTag,
                ),
                if (product.discountPercent > 0)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: DiscountBadge(
                      percent: product.discountPercent,
                      compact: true,
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: WishlistButton(
                    isWishlisted: product.isWishlisted,
                    onTap: onWishlist ?? () {},
                    size: 30,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        height: 1.2,
                        color: AppColors.heading,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.vendorName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        RatingWidget(rating: product.rating, size: 10),
                        const Spacer(),
                        Text(
                          AppUtils.deliveryLabel(product.deliveryTimeMins),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          AppUtils.formatPrice(product.price),
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                            color: AppColors.price,
                          ),
                        ),
                        if (product.originalPrice > product.price) ...[
                          const SizedBox(width: 4),
                          Text(
                            AppUtils.formatPrice(product.originalPrice),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.oldPrice,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    QuantityStepper(
                      quantity: quantity,
                      onChanged: onQuantityChanged ?? (_) {},
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String url;
  final String? heroTag;

  const _ProductImage({required this.url, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final image = ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppConstants.radiusL),
      ),
      child: CachedNetworkImage(
        imageUrl: url,
        height: 120,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (_, __) => const LoadingShimmer(height: 120),
      ),
    );
    if (heroTag == null) return image;
    return Hero(tag: heroTag!, child: image);
  }
}

class OfferCard extends StatelessWidget {
  final CouponModel coupon;
  final VoidCallback? onApply;

  const OfferCard({super.key, required this.coupon, this.onApply});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppConstants.radiusL),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.local_offer_rounded,
                    color: AppColors.primaryDark),
                const SizedBox(height: 4),
                Text(
                  coupon.code,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coupon.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    coupon.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (onApply != null)
            TextButton(
              onPressed: onApply,
              child: const Text(
                'APPLY',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AddressCard({
    super.key,
    required this.address,
    this.selected = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        address.label == 'Home'
                            ? Icons.home_rounded
                            : Icons.work_rounded,
                        size: 14,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        address.label,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (address.isDefault) ...[
                  const SizedBox(width: 8),
                  const Text(
                    'Default',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const Spacer(),
                if (onEdit != null)
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    visualDensity: VisualDensity.compact,
                  ),
                if (onDelete != null)
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline,
                        size: 18, color: AppColors.error),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              address.name,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            Text(
              address.fullAddress,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            Text(
              address.phone,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  IconData get _icon {
    switch (notification.type) {
      case 'orders':
        return Icons.local_shipping_outlined;
      case 'offers':
        return Icons.local_offer_outlined;
      case 'payments':
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: notification.isRead
              ? AppColors.border
              : AppColors.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(_icon, color: AppColors.accent, size: 22),
      ),
      title: Text(
        notification.title,
        style: TextStyle(
          fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w800,
          fontSize: 14,
        ),
      ),
      subtitle: Text(
        notification.body,
        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
      ),
      trailing: Text(
        _timeAgo(notification.time),
        style: const TextStyle(fontSize: 10, color: AppColors.textHint),
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final d = DateTime.now().difference(time);
    if (d.inMinutes < 60) return '${d.inMinutes}m';
    if (d.inHours < 24) return '${d.inHours}h';
    return '${d.inDays}d';
  }
}

class WalletCard extends StatelessWidget {
  final double balance;
  final int points;
  final VoidCallback? onRecharge;

  const WalletCard({
    super.key,
    required this.balance,
    required this.points,
    this.onRecharge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.darkHeroGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet_rounded,
                  color: AppColors.primary),
              const SizedBox(width: 8),
              const Text(
                'Qwiko Wallet',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              if (onRecharge != null)
                TextButton(
                  onPressed: onRecharge,
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.buttonPrimary,
                    foregroundColor: AppColors.buttonPrimaryText,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Recharge',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Available Balance',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            AppUtils.formatPrice(balance),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '🎁 $points Reward Points',
              style: const TextStyle(color: AppColors.primary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class CouponCard extends StatelessWidget {
  final CouponModel coupon;
  final VoidCallback? onTap;

  const CouponCard({super.key, required this.coupon, this.onTap});

  @override
  Widget build(BuildContext context) => OfferCard(coupon: coupon, onApply: onTap);
}

class AppSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final VoidCallback? onTap;
  final VoidCallback? onVoice;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final bool autofocus;

  const AppSearchBar({
    super.key,
    this.controller,
    this.hint = 'Search for products, stores...',
    this.onTap,
    this.onVoice,
    this.onChanged,
    this.readOnly = false,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.searchBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        child: TextField(
          controller: controller,
          readOnly: readOnly,
          autofocus: autofocus,
          onChanged: onChanged,
          onTap: onTap,
          style: const TextStyle(
            color: AppColors.searchText,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.searchHint),
            prefixIcon: const Icon(Icons.search_rounded,
                color: AppColors.searchIcon),
            suffixIcon: onVoice != null
                ? IconButton(
                    onPressed: onVoice,
                    icon: const Icon(Icons.mic_rounded,
                        color: AppColors.primaryDark),
                  )
                : null,
            filled: true,
            fillColor: Colors.transparent,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}
