import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/cart_controller.dart';
import '../../../controllers/wishlist_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/cards_widgets.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/mock_data.dart';
import '../../../models/category_model.dart';
import '../../../models/models.dart';

class StoreDetailView extends StatefulWidget {
  const StoreDetailView({super.key});

  @override
  State<StoreDetailView> createState() => _StoreDetailViewState();
}

class _StoreDetailViewState extends State<StoreDetailView> {
  int _sectionIndex = 0;

  static const _sections = [
    'Popular',
    'Featured',
    'Offers',
    'Reviews',
    'Store Info',
  ];

  @override
  Widget build(BuildContext context) {
    final vendorId = Get.arguments as String? ?? 'v1';
    final vendor = MockData.vendorById(vendorId) ?? MockData.vendors.first;
    final products = MockData.productsByVendor(vendor.id);
    final cart = Get.find<CartController>();
    final wishlist = Get.find<WishlistController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_rounded, size: 20),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: vendor.banner,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const LoadingShimmer(height: 200),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.55),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -36),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusL),
                            border: Border.all(color: AppColors.border, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusL - 2),
                            child: CachedNetworkImage(
                              imageUrl: vendor.logo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vendor.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  RatingWidget(
                                    rating: vendor.rating,
                                    count: vendor.reviewCount,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    vendor.category,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _infoChip(
                          Icons.access_time_rounded,
                          AppUtils.deliveryLabel(vendor.deliveryTimeMins),
                        ),
                        _infoChip(
                          Icons.location_on_outlined,
                          '${vendor.distanceKm} km',
                        ),
                        _infoChip(
                          Icons.shopping_bag_outlined,
                          'Min ${AppUtils.formatPrice(vendor.minOrder)}',
                        ),
                        if (vendor.offer.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              vendor.offer,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (vendor.tags.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 6,
                        children: vendor.tags
                            .map(
                              (t) => Chip(
                                label: Text(
                                  t,
                                  style: const TextStyle(fontSize: 11),
                                ),
                                visualDensity: VisualDensity.compact,
                                backgroundColor:
                                    AppColors.primary.withValues(alpha: 0.15),
                                side: BorderSide.none,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: List.generate(
                  _sections.length,
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_sections[i]),
                      selected: _sectionIndex == i,
                      onSelected: (_) => setState(() => _sectionIndex = i),
                      selectedColor: AppColors.primary.withValues(alpha: 0.35),
                      labelStyle: TextStyle(
                        fontWeight:
                            _sectionIndex == i ? FontWeight.w800 : FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          ..._buildSectionContent(vendor, products, cart, wishlist),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  List<Widget> _buildSectionContent(
    VendorModel vendor,
    List<ProductModel> products,
    CartController cart,
    WishlistController wishlist,
  ) {
    switch (_sectionIndex) {
      case 0:
      case 1:
        final list = products.isEmpty
            ? MockData.products.take(6).toList()
            : products;
        return [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.58,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final p = list[i % list.length];
                  return Obx(() {
                    final _ = cart.items.length;
                    wishlist.wishlistIds.length;
                    return ProductCard(
                      product: p.copyWith(
                        isWishlisted: wishlist.isWishlisted(p.id),
                      ),
                      width: double.infinity,
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
                childCount: list.length,
              ),
            ),
          ),
        ];
      case 2:
        return [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => OfferCard(
                  coupon: MockData.coupons[i],
                  onApply: () => Get.find<CartController>().applyCoupon(
                    MockData.coupons[i],
                  ),
                ),
                childCount: MockData.coupons.length,
              ),
            ),
          ),
        ];
      case 3:
        return [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => _ReviewTile(review: MockData.reviews[i]),
                childCount: MockData.reviews.length,
              ),
            ),
          ),
        ];
      case 4:
        return [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About Store',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${vendor.name} delivers ${vendor.category.toLowerCase()} '
                      'to your doorstep in ${AppUtils.deliveryLabel(vendor.deliveryTimeMins)}. '
                      'Minimum order ${AppUtils.formatPrice(vendor.minOrder)}.',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _storeInfoRow('Category', vendor.category),
                    _storeInfoRow('Delivery Time',
                        AppUtils.deliveryLabel(vendor.deliveryTimeMins)),
                    _storeInfoRow('Distance', '${vendor.distanceKm} km'),
                    _storeInfoRow(
                      'Minimum Order',
                      AppUtils.formatPrice(vendor.minOrder),
                    ),
                    _storeInfoRow('Rating',
                        '${vendor.rating} (${vendor.reviewCount} reviews)'),
                  ],
                ),
              ),
            ),
          ),
        ];
      default:
        return [];
    }
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _storeInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ReviewModel review;

  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: CachedNetworkImageProvider(review.avatar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    RatingWidget(rating: review.rating, size: 10),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  review.comment,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
