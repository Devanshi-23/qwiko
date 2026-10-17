import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../routes/app_routes.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _orderUpdates = true;
  bool _promotions = true;
  bool _payments = true;
  String _language = 'English';

  bool get _isDark => Get.isDarkMode;

  void _toggleDarkMode(bool value) {
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    setState(() {});
  }

  void _showLanguageSheet() {
    Get.bottomSheet(
      Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          16,
          20,
          MediaQuery.of(context).padding.bottom + 24,
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
            const SizedBox(height: 20),
            const Text(
              'Select Language',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 16),
            _LanguageTile(
              label: 'English',
              selected: _language == 'English',
              onTap: () {
                setState(() => _language = 'English');
                Get.back();
                AppUtils.showToast('Language set to English');
              },
            ),
            _LanguageTile(
              label: 'Hindi',
              selected: _language == 'Hindi',
              onTap: () {
                setState(() => _language = 'Hindi');
                Get.back();
                AppUtils.showToast('Language set to Hindi');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteAccount() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all associated data. This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              AppUtils.showToast('Account deletion requested');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          _SectionHeader(title: 'Appearance'),
          _SettingsCard(
            children: [
              SwitchListTile(
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Switch between light and dark theme',
                  style: TextStyle(fontSize: 12),
                ),
                secondary: Icon(
                  _isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: AppColors.accent,
                ),
                value: _isDark,
                activeThumbColor: AppColors.primary,
                onChanged: _toggleDarkMode,
              ),
              const Divider(height: 1, indent: 16),
              ListTile(
                leading: const Icon(Icons.language_rounded,
                    color: AppColors.accent),
                title: const Text(
                  'Language',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(_language),
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textHint),
                onTap: _showLanguageSheet,
              ),
            ],
          ),
          _SectionHeader(title: 'Notifications'),
          _SettingsCard(
            children: [
              SwitchListTile(
                title: const Text(
                  'Order Updates',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Delivery status and order confirmations',
                  style: TextStyle(fontSize: 12),
                ),
                value: _orderUpdates,
                activeThumbColor: AppColors.primary,
                onChanged: (v) => setState(() => _orderUpdates = v),
              ),
              const Divider(height: 1, indent: 16),
              SwitchListTile(
                title: const Text(
                  'Offers & Promotions',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Deals, coupons, and flash sales',
                  style: TextStyle(fontSize: 12),
                ),
                value: _promotions,
                activeThumbColor: AppColors.primary,
                onChanged: (v) => setState(() => _promotions = v),
              ),
              const Divider(height: 1, indent: 16),
              SwitchListTile(
                title: const Text(
                  'Payment Alerts',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text(
                  'Wallet credits and transaction updates',
                  style: TextStyle(fontSize: 12),
                ),
                value: _payments,
                activeThumbColor: AppColors.primary,
                onChanged: (v) => setState(() => _payments = v),
              ),
            ],
          ),
          _SectionHeader(title: 'Privacy & Security'),
          _SettingsCard(
            children: [
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined,
                    color: AppColors.accent),
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textHint),
                onTap: () => Get.toNamed(AppRoutes.privacy),
              ),
              const Divider(height: 1, indent: 16),
              ListTile(
                leading: const Icon(Icons.security_outlined,
                    color: AppColors.accent),
                title: const Text(
                  'Security',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textHint),
                onTap: () => AppUtils.showToast('Security settings coming soon'),
              ),
            ],
          ),
          _SectionHeader(title: 'Account'),
          _SettingsCard(
            children: [
              ListTile(
                leading: const Icon(Icons.delete_forever_outlined,
                    color: AppColors.error),
                title: const Text(
                  'Delete Account',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.error,
                  ),
                ),
                onTap: _confirmDeleteAccount,
              ),
            ],
          ),
          _SectionHeader(title: 'About'),
          _SettingsCard(
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline_rounded,
                    color: AppColors.accent),
                title: const Text(
                  'About Qwiko',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Version 1.0.0'),
                onTap: () => AppUtils.showToast('Qwiko v1.0.0 — Everything Delivered Instantly'),
              ),
              const Divider(height: 1, indent: 16),
              ListTile(
                leading: const Icon(Icons.star_outline_rounded,
                    color: AppColors.accent),
                title: const Text(
                  'Rate App',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: const Icon(Icons.chevron_right_rounded,
                    color: AppColors.textHint),
                onTap: () => AppUtils.showToast('Thanks for rating Qwiko!'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
        ),
      ),
      trailing: selected
          ? const Icon(Icons.check_circle_rounded, color: AppColors.primaryDark)
          : null,
    );
  }
}
