import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/cards_widgets.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/mock_data.dart';

class OffersView extends StatelessWidget {
  const OffersView({super.key});

  static const _tabs = [
    'Coupons',
    'Cashback',
    'Promo',
    'Rewards',
    'Referral',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Offers & Rewards'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.accent,
            unselectedLabelColor: AppColors.textHint,
            indicatorColor: AppColors.primaryDark,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
            tabs: _tabs.map((t) => Tab(text: t)).toList(),
          ),
        ),
        body: TabBarView(
          children: [
            _CouponsTab(),
            _MarketingTab(
              title: 'Cashback Offers',
              cards: const [
                _MarketingCardData(
                  icon: Icons.savings_outlined,
                  title: '5% Wallet Cashback',
                  subtitle: 'On all orders above ₹299 paid via wallet',
                  badge: 'ACTIVE',
                ),
                _MarketingCardData(
                  icon: Icons.receipt_long_outlined,
                  title: 'Weekend Cashback',
                  subtitle: 'Extra ₹30 back on grocery orders this weekend',
                  badge: 'LIMITED',
                ),
              ],
            ),
            _MarketingTab(
              title: 'Promo Deals',
              cards: const [
                _MarketingCardData(
                  icon: Icons.local_fire_department_outlined,
                  title: 'Flash Sale Live',
                  subtitle: 'Up to 60% off on fresh groceries — ends tonight',
                  badge: 'HOT',
                ),
                _MarketingCardData(
                  icon: Icons.delivery_dining_outlined,
                  title: 'Free Delivery Week',
                  subtitle: 'Zero delivery fee on orders above ₹149',
                  badge: 'NEW',
                ),
              ],
            ),
            _MarketingTab(
              title: 'Rewards Program',
              cards: [
                _MarketingCardData(
                  icon: Icons.stars_rounded,
                  title: '${MockData.user.rewardPoints} Points',
                  subtitle: 'Earn 10 points for every ₹100 spent on Qwiko',
                  badge: 'GOLD',
                ),
                const _MarketingCardData(
                  icon: Icons.emoji_events_outlined,
                  title: 'Monthly Milestone',
                  subtitle: 'Order 5 times this month to unlock ₹150 bonus',
                  badge: '2/5',
                ),
              ],
            ),
            _ReferralTab(),
          ],
        ),
      ),
    );
  }
}

class _CouponsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        const Text(
          'Available Coupons',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 12),
        ...MockData.coupons.map(
          (coupon) => OfferCard(
            coupon: coupon,
            onApply: () => AppUtils.showToast('Coupon ${coupon.code} copied!'),
          ),
        ),
      ],
    );
  }
}

class _ReferralTab extends StatelessWidget {
  static const _referralCode = 'QWIKO-FRIEND';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.35),
                AppColors.primaryLight.withValues(alpha: 0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusXL),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.card_giftcard_rounded,
                      color: AppColors.accent, size: 28),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Refer Friends, Earn ₹100',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Share your code. When a friend places their first order, you both get ₹100 in your wallet.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      _referralCode,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(
                          const ClipboardData(text: _referralCode),
                        );
                        AppUtils.showToast('Referral code copied!');
                      },
                      icon: const Icon(Icons.copy_rounded, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Share Code',
                icon: Icons.share_rounded,
                onPressed: () =>
                    AppUtils.showToast('Share sheet opened (mock)'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const SectionHeader(title: 'How It Works'),
        _StepTile(
          step: '1',
          title: 'Share your code',
          subtitle: 'Send QWIKO-FRIEND to friends via WhatsApp or SMS',
        ),
        _StepTile(
          step: '2',
          title: 'Friend signs up',
          subtitle: 'They create an account and place their first order',
        ),
        _StepTile(
          step: '3',
          title: 'Both earn ₹100',
          subtitle: 'Credits are added to both wallets instantly',
        ),
      ],
    );
  }
}

class _MarketingTab extends StatelessWidget {
  final String title;
  final List<_MarketingCardData> cards;

  const _MarketingTab({
    required this.title,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 12),
        ...cards.map((c) => _MarketingCard(data: c)),
      ],
    );
  }
}

class _MarketingCardData {
  final IconData icon;
  final String title;
  final String subtitle;
  final String badge;

  const _MarketingCardData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.badge,
  });
}

class _MarketingCard extends StatelessWidget {
  final _MarketingCardData data;

  const _MarketingCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(data.icon, color: AppColors.accent, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        data.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        data.badge,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  data.subtitle,
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

class _StepTile extends StatelessWidget {
  final String step;
  final String title;
  final String subtitle;

  const _StepTile({
    required this.step,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: Text(
              step,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
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
