import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/auth/auth_action.dart';
import '../../../core/auth/auth_guard.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../features/auth/widgets/auth_widgets.dart';
import '../../../routes/app_routes.dart';

class ProfileView extends GetView<AuthController> {
  const ProfileView({super.key});

  void _openLogin() {
    Get.toNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Obx(() {
        final loggedIn = controller.isLoggedIn.value;
        final user = controller.sessionUser;

        return ListView(
          padding: const EdgeInsets.only(bottom: 32),
          children: [
            if (!loggedIn)
              GuestBanner(onLogin: _openLogin)
            else
              const SizedBox.shrink(),
            if (!loggedIn) const SizedBox(height: 12),
            ProfileHeader(
              name: loggedIn ? user.name : 'Guest User',
              subtitle: loggedIn
                  ? user.phone
                  : 'Sign in for a personalized experience',
              avatarUrl: loggedIn ? user.avatar : null,
              badge: loggedIn ? user.membership : 'Guest',
              isGuest: !loggedIn,
              onLogin: loggedIn ? null : _openLogin,
            ),
            if (loggedIn) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _StatChip(
                        label: 'Wallet',
                        value: AppUtils.formatPrice(user.walletBalance),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _StatChip(
                        label: 'Rewards',
                        value: '${user.rewardPoints} pts',
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            if (loggedIn) _QuickActions() else const SizedBox.shrink(),
            if (loggedIn) const SizedBox(height: 8),
            _MenuSection(
              title: 'Account',
              items: [
                _MenuItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'My Orders',
                  onTap: () => AuthGuard.requireRoute(
                    AppRoutes.orders,
                    action: AuthAction.orders,
                  ),
                ),
                _MenuItem(
                  icon: Icons.favorite_outline_rounded,
                  title: 'Wishlist',
                  onTap: () => AuthGuard.requireRoute(
                    AppRoutes.wishlist,
                    action: AuthAction.wishlist,
                  ),
                ),
                _MenuItem(
                  icon: Icons.location_on_outlined,
                  title: 'Addresses',
                  onTap: () => AuthGuard.requireRoute(
                    AppRoutes.address,
                    action: AuthAction.addresses,
                  ),
                ),
                _MenuItem(
                  icon: Icons.credit_card_outlined,
                  title: 'Saved Cards',
                  onTap: () => AuthGuard.require(
                    action: AuthAction.paymentMethods,
                    onAuthenticated: () =>
                        AppUtils.showToast('Saved cards coming soon'),
                  ),
                ),
              ],
            ),
            if (loggedIn)
              _MenuSection(
                title: 'Wallet & Offers',
                items: [
                  _MenuItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Wallet',
                    subtitle: AppUtils.formatPrice(user.walletBalance),
                    onTap: () => AuthGuard.requireRoute(
                      AppRoutes.wallet,
                      action: AuthAction.wallet,
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.local_offer_outlined,
                    title: 'Offers',
                    onTap: () => AuthGuard.requireRoute(
                      AppRoutes.offers,
                      action: AuthAction.offers,
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.card_giftcard_outlined,
                    title: 'Refer & Earn',
                    onTap: () => AuthGuard.requireRoute(
                      AppRoutes.offers,
                      action: AuthAction.referral,
                    ),
                  ),
                ],
              )
            else
              _MenuSection(
                title: 'Get more with login',
                items: [
                  _MenuItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Wallet',
                    onTap: () => AuthGuard.requireRoute(
                      AppRoutes.wallet,
                      action: AuthAction.wallet,
                    ),
                  ),
                  _MenuItem(
                    icon: Icons.local_offer_outlined,
                    title: 'Offers & Coupons',
                    onTap: () => AuthGuard.requireRoute(
                      AppRoutes.offers,
                      action: AuthAction.coupons,
                    ),
                  ),
                ],
              ),
            _MenuSection(
              title: 'Support & Legal',
              items: [
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () => AuthGuard.requireRoute(
                    AppRoutes.notifications,
                    action: AuthAction.notifications,
                  ),
                ),
                _MenuItem(
                  icon: Icons.help_outline_rounded,
                  title: 'Help Center',
                  onTap: () => Get.toNamed(AppRoutes.help),
                ),
                _MenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => Get.toNamed(AppRoutes.privacy),
                ),
                _MenuItem(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () => Get.toNamed(AppRoutes.terms),
                ),
                _MenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () => Get.toNamed(AppRoutes.settings),
                ),
              ],
            ),
            if (loggedIn)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon:
                      const Icon(Icons.logout_rounded, color: AppColors.error),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    side: const BorderSide(color: AppColors.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        title: const Text('Log Out'),
        content: const Text(
          'Are you sure you want to log out? Your cart will be kept.',
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.caption),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: AppColors.heading,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.receipt_long_outlined,
        label: 'Orders',
        onTap: () => AuthGuard.requireRoute(
          AppRoutes.orders,
          action: AuthAction.orders,
        ),
      ),
      _QuickAction(
        icon: Icons.favorite_outline_rounded,
        label: 'Wishlist',
        onTap: () => AuthGuard.requireRoute(
          AppRoutes.wishlist,
          action: AuthAction.wishlist,
        ),
      ),
      _QuickAction(
        icon: Icons.account_balance_wallet_outlined,
        label: 'Wallet',
        onTap: () => AuthGuard.requireRoute(
          AppRoutes.wallet,
          action: AuthAction.wallet,
        ),
      ),
      _QuickAction(
        icon: Icons.local_offer_outlined,
        label: 'Offers',
        onTap: () => AuthGuard.requireRoute(
          AppRoutes.offers,
          action: AuthAction.offers,
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: actions
            .map(
              (a) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: a,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.secondary, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final isLast = entry.key == items.length - 1;
              return Column(
                children: [
                  entry.value,
                  if (!isLast) const Divider(height: 1, indent: 56),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: AppColors.secondary),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textHint,
      ),
    );
  }
}
