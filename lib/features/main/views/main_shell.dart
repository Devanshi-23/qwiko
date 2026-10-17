import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/cart_controller.dart';
import '../../../controllers/main_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../cart/views/cart_view.dart';
import '../../categories/views/categories_view.dart';
import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';
import '../../search/views/search_view.dart';

class MainShell extends GetView<MainController> {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const [
      HomeView(),
      CategoriesView(),
      SearchView(),
      CartView(),
      ProfileView(),
    ];

    return Obx(() {
      final cart = Get.find<CartController>();
      return Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.navBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavItem(
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: 'Home',
                    index: 0,
                    current: controller.currentIndex.value,
                    onTap: controller.changeTab,
                  ),
                  _NavItem(
                    icon: Icons.grid_view_outlined,
                    activeIcon: Icons.grid_view_rounded,
                    label: 'Categories',
                    index: 1,
                    current: controller.currentIndex.value,
                    onTap: controller.changeTab,
                  ),
                  _NavItem(
                    icon: Icons.search_outlined,
                    activeIcon: Icons.search_rounded,
                    label: 'Search',
                    index: 2,
                    current: controller.currentIndex.value,
                    onTap: controller.changeTab,
                  ),
                  Obx(
                    () => _NavItem(
                      icon: Icons.shopping_bag_outlined,
                      activeIcon: Icons.shopping_bag_rounded,
                      label: 'Cart',
                      index: 3,
                      current: controller.currentIndex.value,
                      onTap: controller.changeTab,
                      badge: cart.itemCount,
                    ),
                  ),
                  _NavItem(
                    icon: Icons.person_outline_rounded,
                    activeIcon: Icons.person_rounded,
                    label: 'Profile',
                    index: 4,
                    current: controller.currentIndex.value,
                    onTap: controller.changeTab,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;
  final int badge;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
    this.badge = 0,
  });

  @override
  Widget build(BuildContext context) {
    final active = current == index;
    Widget iconWidget = AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Icon(
        active ? activeIcon : icon,
        key: ValueKey(active),
        color: active ? AppColors.navSelectedIcon : AppColors.navUnselected,
        size: 24,
      ),
    );

    if (badge > 0) {
      iconWidget = badges.Badge(
        badgeContent: Text(
          '$badge',
          style: const TextStyle(color: Colors.white, fontSize: 9),
        ),
        badgeStyle: const badges.BadgeStyle(
          badgeColor: AppColors.error,
          padding: EdgeInsets.all(4),
        ),
        child: iconWidget,
      );
    }

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            iconWidget,
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                color: active
                    ? AppColors.navSelectedLabel
                    : AppColors.navUnselected,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(top: 3),
              height: 3,
              width: active ? 16 : 0,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
