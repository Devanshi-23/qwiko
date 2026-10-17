import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/cart_controller.dart';
import '../../../controllers/wishlist_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/cards_widgets.dart';
import '../../../core/widgets/common_widgets.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Get.find<WishlistController>();
    final cart = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist'),
      ),
      body: Obx(() {
        final products = wishlist.products;
        if (products.isEmpty) {
          return EmptyState(
            icon: Icons.favorite_border_rounded,
            title: AppStrings.noWishlist,
            subtitle:
                'Save items you love and find them here anytime.',
            actionLabel: 'Browse Products',
            onAction: () => Get.back(),
          );
        }

        final cardWidth =
            (MediaQuery.of(context).size.width - 16 * 2 - 12) / 2;

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.58,
          ),
          itemCount: products.length,
          itemBuilder: (_, i) {
            final product = products[i];
            return ProductCard(
              product: product,
              width: cardWidth,
              quantity: cart.quantityOf(product.id),
              onQuantityChanged: (q) {
                if (q == 0) {
                  cart.removeItem(product.id);
                } else if (cart.quantityOf(product.id) == 0) {
                  cart.addProduct(product, qty: q);
                } else {
                  cart.setQuantity(product.id, q);
                }
              },
              onWishlist: () => wishlist.toggle(product.id),
            );
          },
        );
      }),
    );
  }
}
