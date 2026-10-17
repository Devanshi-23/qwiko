import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/cards_widgets.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/mock_data.dart';
import '../../../models/models.dart';

class WalletView extends StatefulWidget {
  const WalletView({super.key});

  @override
  State<WalletView> createState() => _WalletViewState();
}

class _WalletViewState extends State<WalletView> {
  double _balance = MockData.user.walletBalance;

  void _showRechargeSheet() {
    final amounts = [100, 200, 500, 1000];
    var selected = amounts[1];

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
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
                  'Recharge Wallet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Select an amount to add to your Qwiko Wallet',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: amounts.map((amount) {
                    final isSelected = selected == amount;
                    return ChoiceChip(
                      label: Text(AppUtils.formatPrice(amount)),
                      selected: isSelected,
                      onSelected: (_) =>
                          setSheetState(() => selected = amount),
                      selectedColor: AppColors.primary.withValues(alpha: 0.25),
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? AppColors.accent
                            : AppColors.textSecondary,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                PrimaryButton(
                  label: 'Confirm Recharge',
                  icon: Icons.account_balance_wallet_outlined,
                  onPressed: () {
                    setState(() => _balance += selected);
                    Get.back();
                    AppUtils.showToast(
                      '${AppUtils.formatPrice(selected)} added to wallet',
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.user;
    final transactions = MockData.walletTransactions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Qwiko Wallet'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          WalletCard(
            balance: _balance,
            points: user.rewardPoints,
            onRecharge: _showRechargeSheet,
          ),
          const SectionHeader(title: 'Cashback & Rewards'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _InfoCard(
                  icon: Icons.savings_outlined,
                  title: 'Earn 5% Cashback',
                  subtitle:
                      'Get 5% back on every order paid via Qwiko Wallet',
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
                const SizedBox(height: 10),
                _InfoCard(
                  icon: Icons.stars_rounded,
                  title: '${user.rewardPoints} Reward Points',
                  subtitle:
                      'Redeem points for discounts on your next order',
                  color: AppColors.warning.withValues(alpha: 0.12),
                ),
                const SizedBox(height: 10),
                _InfoCard(
                  icon: Icons.card_giftcard_outlined,
                  title: 'Refer & Earn ₹100',
                  subtitle:
                      'Invite friends and earn wallet credits instantly',
                  color: AppColors.info.withValues(alpha: 0.12),
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'Recent Transactions'),
          ...transactions.map(_TransactionTile.new),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.accent, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.3,
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

class _TransactionTile extends StatelessWidget {
  final WalletTransaction transaction;

  const _TransactionTile(this.transaction);

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == 'credit';
    final color = isCredit ? AppColors.success : AppColors.error;
    final prefix = isCredit ? '+' : '-';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(transaction.date),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$prefix${AppUtils.formatPrice(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}/${date.year}';
  }
}
