import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<ProductModel> get _suggestions {
    if (_query.trim().length < 2) return [];
    final q = _query.toLowerCase();
    return MockData.products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.vendorName.toLowerCase().contains(q) ||
            p.tags.any((t) => t.toLowerCase().contains(q)))
        .take(6)
        .toList();
  }

  List<ProductModel> get _searchResults {
    if (_query.trim().isEmpty) return [];
    final q = _query.toLowerCase();
    return MockData.products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.vendorName.toLowerCase().contains(q) ||
            p.tags.any((t) => t.toLowerCase().contains(q)))
        .toList();
  }

  void _setQuery(String value) {
    setState(() {
      _query = value;
      _controller.text = value;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: value.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final wishlist = Get.find<WishlistController>();
    final hasQuery = _query.trim().isNotEmpty;
    final results = _searchResults;
    final suggestions = _suggestions;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Search',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: AppSearchBar(
                  controller: _controller,
                  autofocus: true,
                  onChanged: (v) => setState(() => _query = v),
                  onVoice: () => AppUtils.showToast('Voice search coming soon'),
                ),
              ),
            ),
            if (hasQuery && suggestions.isNotEmpty)
              SliverToBoxAdapter(
                child: _SuggestionsList(
                  suggestions: suggestions,
                  onTap: (name) => _setQuery(name),
                ),
              ),
            if (!hasQuery) ...[
              SliverToBoxAdapter(
                child: _ChipSection(
                  title: 'Recent Searches',
                  items: MockData.recentSearches,
                  onTap: _setQuery,
                ),
              ),
              SliverToBoxAdapter(
                child: _ChipSection(
                  title: 'Popular Searches',
                  items: MockData.popularSearches,
                  onTap: _setQuery,
                ),
              ),
              SliverToBoxAdapter(
                child: SectionHeader(title: 'Trending Products'),
              ),
              _productSliver(MockData.deals.take(6).toList(), cart, wishlist),
              SliverToBoxAdapter(
                child: SectionHeader(title: 'Trending Stores'),
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
                ).animate().fadeIn(delay: 150.ms),
              ),
            ] else if (results.isEmpty) ...[
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(
                  icon: Icons.search_off_rounded,
                  title: AppStrings.noSearchResults,
                  subtitle: 'Try a different keyword or browse trending items',
                  actionLabel: 'Clear Search',
                  onAction: () => _setQuery(''),
                ),
              ),
            ] else ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    '${results.length} result${results.length == 1 ? '' : 's'} for "$_query"',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
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
                      final p = results[i];
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
                    childCount: results.length,
                  ),
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _productSliver(
    List<ProductModel> products,
    CartController cart,
    WishlistController wishlist,
  ) {
    return Obx(
      () {
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

class _ChipSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final ValueChanged<String> onTap;

  const _ChipSection({
    required this.title,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .map(
                  (s) => ActionChip(
                    avatar: Icon(
                      title.contains('Recent')
                          ? Icons.history_rounded
                          : Icons.trending_up_rounded,
                      size: 16,
                      color: AppColors.primaryDark,
                    ),
                    label: Text(s),
                    onPressed: () => onTap(s),
                    backgroundColor: AppColors.card,
                    side: const BorderSide(color: AppColors.border),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _SuggestionsList extends StatelessWidget {
  final List<ProductModel> suggestions;
  final ValueChanged<String> onTap;

  const _SuggestionsList({
    required this.suggestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(14, 12, 14, 4),
            child: Text(
              'Suggestions',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ...suggestions.map(
            (p) => ListTile(
              dense: true,
              leading: const Icon(Icons.search_rounded,
                  size: 20, color: AppColors.textHint),
              title: Text(
                p.name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              subtitle: Text(
                p.vendorName,
                style: const TextStyle(fontSize: 11),
              ),
              onTap: () => onTap(p.name),
            ),
          ),
        ],
      ),
    );
  }
}
