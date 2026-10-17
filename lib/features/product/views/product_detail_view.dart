import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../controllers/cart_controller.dart';
import '../../../controllers/wishlist_controller.dart';
import '../../../core/auth/auth_action.dart';
import '../../../core/auth/auth_guard.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/cards_widgets.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/mock_data.dart';
import '../../../models/category_model.dart';
import '../../../routes/app_routes.dart';

class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  int _imageIndex = 0;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final String productId;
    final String heroTag;
    if (args is Map) {
      productId = args['id'] as String? ?? 'p1';
      heroTag = args['heroTag'] as String? ?? 'product_detail_$productId';
    } else {
      productId = args as String? ?? 'p1';
      heroTag = 'product_detail_$productId';
    }
    final product = MockData.productById(productId) ?? MockData.products.first;
    final cart = Get.find<CartController>();
    final wishlist = Get.find<WishlistController>();

    final related = MockData.products
        .where((p) => p.categoryId == product.categoryId && p.id != product.id)
        .take(6)
        .toList();
    final boughtTogether = MockData.products
        .where((p) => p.vendorId == product.vendorId && p.id != product.id)
        .take(4)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          Obx(
            () => IconButton(
              onPressed: () => wishlist.toggle(product.id),
              icon: Icon(
                wishlist.isWishlisted(product.id)
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: wishlist.isWishlisted(product.id)
                    ? AppColors.error
                    : AppColors.accent,
              ),
            ),
          ),
          IconButton(
            onPressed: () =>
                AppUtils.showToast('Sharing ${product.name}...'),
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ImageCarousel(
                    product: product,
                    heroTag: heroTag,
                    index: _imageIndex,
                    onPageChanged: (i) => setState(() => _imageIndex = i),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (product.discountPercent > 0)
                              DiscountBadge(percent: product.discountPercent),
                            const Spacer(),
                            RatingWidget(
                              rating: product.rating,
                              count: product.reviewCount,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () => Get.toNamed(
                            AppRoutes.storeDetail,
                            arguments: product.vendorId,
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.storefront_outlined,
                                  size: 16, color: AppColors.primaryDark),
                              const SizedBox(width: 4),
                              Text(
                                product.vendorName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryDark,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded, size: 18),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              AppUtils.formatPrice(product.price),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 26,
                              ),
                            ),
                            if (product.originalPrice > product.price) ...[
                              const SizedBox(width: 8),
                              Text(
                                AppUtils.formatPrice(product.originalPrice),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textHint,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                            const Spacer(),
                            Text(
                              product.unit,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              'Delivery in ${AppUtils.deliveryLabel(product.deliveryTimeMins)}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        if (product.tags.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            children: product.tags
                                .map(
                                  (t) => Chip(
                                    label: Text(t,
                                        style: const TextStyle(fontSize: 11)),
                                    visualDensity: VisualDensity.compact,
                                    backgroundColor: AppColors.primary
                                        .withValues(alpha: 0.15),
                                    side: BorderSide.none,
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                        const SizedBox(height: 20),
                        const Text(
                          'Quantity',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        QuantityStepper(
                          quantity: _quantity,
                          min: 1,
                          onChanged: (q) => setState(() => _quantity = q),
                          size: 40,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.description,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        if (product.nutrition.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const Text(
                            'Nutrition',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(AppConstants.radiusM),
                            ),
                            child: Text(
                              product.nutrition,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                        if (product.specifications.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          const Text(
                            'Specifications',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...product.specifications.entries.map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      e.key,
                                      style: const TextStyle(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    e.value,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        if (boughtTogether.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const Text(
                            'Frequently Bought Together',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 100,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: boughtTogether.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (_, i) {
                                final p = boughtTogether[i];
                                return _CompactProductTile(product: p);
                              },
                            ),
                          ),
                        ],
                        if (related.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const Text(
                            'Related Products',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 280,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: related.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 12),
                              itemBuilder: (_, i) {
                                final p = related[i];
                                return Obx(() {
                                  final _ = cart.items.length;
                                  wishlist.wishlistIds.length;
                                  return ProductCard(
                                    product: p.copyWith(
                                      isWishlisted: wishlist.isWishlisted(p.id),
                                    ),
                                    quantity: cart.quantityOf(p.id),
                                    onQuantityChanged: (q) {
                                      if (q == 0) {
                                        cart.removeItem(p.id);
                                      } else if (cart.quantityOf(p.id) == 0) {
                                        cart.addProduct(p, qty: q);
                                      } else {
                                        cart.setQuantity(p.id, q);
                                      }
                                    },
                                    onWishlist: () => wishlist.toggle(p.id),
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _BottomBar(
            product: product,
            quantity: _quantity,
            onAddToCart: () {
              cart.addProduct(product, qty: _quantity);
            },
            onBuyNow: () {
              cart.addProduct(product, qty: _quantity);
              AuthGuard.requireRoute(
                AppRoutes.checkout,
                action: AuthAction.checkout,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ImageCarousel extends StatelessWidget {
  final ProductModel product;
  final String heroTag;
  final int index;
  final ValueChanged<int> onPageChanged;

  const _ImageCarousel({
    required this.product,
    required this.heroTag,
    required this.index,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: product.images.length,
          options: CarouselOptions(
            height: 280,
            viewportFraction: 1,
            enableInfiniteScroll: product.images.length > 1,
            onPageChanged: (i, _) => onPageChanged(i),
          ),
          itemBuilder: (_, i, __) {
            final image = CachedNetworkImage(
              imageUrl: product.images[i],
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) => const LoadingShimmer(height: 280),
            );
            // Only the first slide participates in Hero to avoid duplicate tags.
            if (i == 0) {
              return Hero(tag: heroTag, child: image);
            }
            return image;
          },
        ),
        if (product.images.length > 1) ...[
          const SizedBox(height: 12),
          AnimatedSmoothIndicator(
            activeIndex: index,
            count: product.images.length,
            effect: const WormEffect(
              dotHeight: 6,
              dotWidth: 6,
              activeDotColor: AppColors.primaryDark,
              dotColor: AppColors.border,
            ),
          ),
        ],
      ],
    ).animate().fadeIn(duration: 300.ms);
  }
}

class _CompactProductTile extends StatelessWidget {
  final ProductModel product;

  const _CompactProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Get.toNamed(AppRoutes.productDetail, arguments: product.id),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: product.images.first,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    AppUtils.formatPrice(product.price),
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
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

class _BottomBar extends StatelessWidget {
  final ProductModel product;
  final int quantity;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const _BottomBar({
    required this.product,
    required this.quantity,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Expanded(
            child: SecondaryButton(
              label: AppStrings.addToCart,
              onPressed: onAddToCart,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PrimaryButton(
              label: AppStrings.buyNow,
              onPressed: onBuyNow,
            ),
          ),
        ],
      ),
    );
  }
}
