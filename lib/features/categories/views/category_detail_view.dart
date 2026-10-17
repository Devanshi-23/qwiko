import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/cart_controller.dart';
import '../../../controllers/wishlist_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/cards_widgets.dart';
import '../../../data/mock_data.dart';

class CategoryDetailView extends StatefulWidget {
  const CategoryDetailView({super.key});

  @override
  State<CategoryDetailView> createState() => _CategoryDetailViewState();
}

class _CategoryDetailViewState extends State<CategoryDetailView> {
  String? selectedSub;
  String sortBy = 'Popular';
  double minRating = 0;

  @override
  Widget build(BuildContext context) {
    final categoryId = Get.arguments as String? ?? 'c1';
    final category =
        MockData.categoryById(categoryId) ?? MockData.categories.first;
    var products = MockData.productsByCategory(categoryId);
    if (products.isEmpty) {
      products = MockData.products.take(8).toList();
    }
    if (minRating > 0) {
      products = products.where((p) => p.rating >= minRating).toList();
    }
    if (sortBy == 'Price: Low') {
      products = [...products]..sort((a, b) => a.price.compareTo(b.price));
    } else if (sortBy == 'Price: High') {
      products = [...products]..sort((a, b) => b.price.compareTo(a.price));
    } else if (sortBy == 'Rating') {
      products = [...products]..sort((a, b) => b.rating.compareTo(a.rating));
    }

    final vendors = MockData.vendors
        .where((v) =>
            v.category.toLowerCase().contains(
                category.name.split(' ').first.toLowerCase()) ||
            category.name
                .toLowerCase()
                .contains(v.category.toLowerCase()))
        .toList();
    final vendorList =
        vendors.isEmpty ? MockData.vendors.take(3).toList() : vendors;

    final cart = Get.find<CartController>();
    final wishlist = Get.find<WishlistController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                category.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.accent,
                  fontSize: 16,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: category.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(color: Colors.white.withValues(alpha: 0.55)),
                ],
              ),
            ),
          ),
          if (category.subCategories.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  children: [
                    _chip('All', selectedSub == null, () {
                      setState(() => selectedSub = null);
                    }),
                    ...category.subCategories.map(
                      (s) => _chip(s, selectedSub == s, () {
                        setState(() => selectedSub = s);
                      }),
                    ),
                  ],
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _filterChip(Icons.sort, sortBy, _showSort),
                  _filterChip(
                    Icons.star_outline,
                    minRating > 0 ? '$minRating+' : 'Rating',
                    () => setState(() => minRating = minRating == 0 ? 4 : 0),
                  ),
                  _filterChip(Icons.local_offer_outlined, 'Offers', () {}),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                'Stores',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: vendorList.length,
                itemBuilder: (_, i) => VendorCard(vendor: vendorList[i]),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Products',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
          ),
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
                  final p = products[i % products.length];
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
                childCount: products.isEmpty ? 0 : products.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary.withValues(alpha: 0.3),
        checkmarkColor: AppColors.accent,
      ),
    );
  }

  Widget _filterChip(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Icon(icon, size: 16),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        onPressed: onTap,
      ),
    );
  }

  void _showSort() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sort by',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            ...['Popular', 'Price: Low', 'Price: High', 'Rating'].map(
              (s) => ListTile(
                title: Text(s),
                trailing: sortBy == s
                    ? const Icon(Icons.check, color: AppColors.primaryDark)
                    : null,
                onTap: () {
                  setState(() => sortBy = s);
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
