import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../controllers/cart_controller.dart';
import '../../../controllers/main_controller.dart';
import '../../../controllers/wishlist_controller.dart';
import '../../../core/auth/auth_action.dart';
import '../../../core/auth/auth_guard.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/cards_widgets.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/mock_data.dart';
import '../../../routes/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final wishlist = Get.find<WishlistController>();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primaryDark,
          onRefresh: () async =>
              await Future.delayed(const Duration(milliseconds: 800)),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _HomeAppBar()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: AppSearchBar(
                    readOnly: true,
                    onTap: () => Get.find<MainController>().changeTab(2),
                    onVoice: () => Get.find<MainController>().changeTab(2),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: BannerCarousel(banners: MockData.banners)
                    .animate()
                    .fadeIn()
                    .slideY(begin: 0.1, end: 0),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(child: _QuickDeliveryCard()),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Categories',
                  actionLabel: 'See All',
                  onAction: () => Get.find<MainController>().changeTab(1),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 110,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: MockData.categories.take(8).length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) => SizedBox(
                      width: 90,
                      child: CategoryCard(category: MockData.categories[i]),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Trending Stores',
                  actionLabel: 'See All',
                  onAction: () => Get.find<MainController>().changeTab(1),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: MockData.trendingVendors.length,
                    itemBuilder: (_, i) =>
                        VendorCard(vendor: MockData.trendingVendors[i]),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SectionHeader(
                  title: 'Featured Vendors',
                  actionLabel: 'See All',
                ),
              ),
              ...MockData.featuredVendors.take(3).map(
                    (v) =>
                        SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: VendorCard(vendor: v, horizontal: false),
                      ),
                    ),
                  ),
              SliverToBoxAdapter(
                child: SectionHeader(title: "Today's Deals"),
              ),
              _productSliver(
                MockData.deals,
                cart,
                wishlist,
              ),
              SliverToBoxAdapter(
                child: SectionHeader(title: 'Flash Sale ⚡'),
              ),
              _productSliver(MockData.flashSale, cart, wishlist),
              SliverToBoxAdapter(
                child: SectionHeader(title: 'Popular Products'),
              ),
              _productSliver(
                MockData.products.take(8).toList(),
                cart,
                wishlist,
              ),
              SliverToBoxAdapter(
                child: SectionHeader(title: 'Recommended For You'),
              ),
              _productSliver(
                MockData.products.reversed.take(6).toList(),
                cart,
                wishlist,
              ),
              SliverToBoxAdapter(
                child: SectionHeader(title: 'Popular Near You'),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: MockData.vendors.length,
                    itemBuilder: (_, i) =>
                        VendorCard(vendor: MockData.vendors[i]),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SectionHeader(title: 'Continue Shopping'),
              ),
              _productSliver(
                MockData.products.skip(2).take(4).toList(),
                cart,
                wishlist,
              ),
              SliverToBoxAdapter(
                child: SectionHeader(title: 'Recently Viewed'),
              ),
              _productSliver(
                MockData.products.take(4).toList(),
                cart,
                wishlist,
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productSliver(
    List products,
    CartController cart,
    WishlistController wishlist,
  ) {
    return Obx(
      () {
        // ignore: unused_local_variable
        final _ = cart.items.length;
        wishlist.wishlistIds.length;
        return SliverToBoxAdapter(
          child: SizedBox(
            height: 280,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final p = products[i];
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
              },
            ),
          ),
        );
      },
    );
  }
}

class _HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final address = MockData.addresses.first;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => AuthGuard.requireRoute(
                AppRoutes.address,
                action: AuthAction.addresses,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          color: AppColors.primaryDark, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'Deliver to ${address.label}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: Text(
                      address.addressLine,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _IconBtn(
            icon: Icons.notifications_outlined,
            onTap: () => AuthGuard.requireRoute(
              AppRoutes.notifications,
              action: AuthAction.notifications,
            ),
          ),
          _IconBtn(
            icon: Icons.account_balance_wallet_outlined,
            onTap: () => AuthGuard.requireRoute(
              AppRoutes.wallet,
              action: AuthAction.wallet,
            ),
          ),
          _IconBtn(
            icon: Icons.person_outline_rounded,
            onTap: () => Get.find<MainController>().changeTab(4),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 20, color: AppColors.accent),
      ),
    );
  }
}

class _QuickDeliveryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: AppColors.heroGradient),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.bolt_rounded,
                color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery in 10 minutes',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: AppColors.heading,
                  ),
                ),
                Text(
                  'Lightning-fast from stores near you',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.body,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 16, color: AppColors.body),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.05, end: 0);
  }
}
