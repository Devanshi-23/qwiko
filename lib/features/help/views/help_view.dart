import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/mock_data.dart';
import '../../../models/models.dart';

class HelpView extends StatefulWidget {
  const HelpView({super.key});

  @override
  State<HelpView> createState() => _HelpViewState();
}

class _HelpViewState extends State<HelpView> {
  static const _categories = [
    'All',
    'Order Issues',
    'Refund',
    'Payments',
  ];

  static const _categoryMap = {
    'Order Issues': 'Orders',
    'Refund': 'Refund',
    'Payments': 'Payments',
  };

  String _selectedCategory = 'All';

  List<FaqModel> get _filtered {
    if (_selectedCategory == 'All') return MockData.faqs;
    final mapped = _categoryMap[_selectedCategory];
    return MockData.faqs.where((f) => f.category == mapped).toList();
  }

  @override
  Widget build(BuildContext context) {
    final faqs = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                _SupportCard(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Live Chat',
                  color: AppColors.primary.withValues(alpha: 0.15),
                  onTap: () => AppUtils.showToast('Connecting to live chat...'),
                ),
                const SizedBox(width: 10),
                _SupportCard(
                  icon: Icons.phone_outlined,
                  label: 'Call Support',
                  color: AppColors.info.withValues(alpha: 0.12),
                  onTap: () => AppUtils.showToast('Calling +91 1800-QWIKO...'),
                ),
                const SizedBox(width: 10),
                _SupportCard(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  color: AppColors.warning.withValues(alpha: 0.12),
                  onTap: () =>
                      AppUtils.showToast('Opening support@qwiko.app'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final selected = _selectedCategory == cat;
                return FilterChip(
                  label: Text(cat),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _selectedCategory = cat),
                  selectedColor: AppColors.primary.withValues(alpha: 0.25),
                  checkmarkColor: AppColors.accent,
                  labelStyle: TextStyle(
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 12,
                    color:
                        selected ? AppColors.accent : AppColors.textSecondary,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Frequently Asked Questions',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.accent,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (faqs.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'No FAQs in this category yet.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            )
          else
            ...faqs.map(
              (faq) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius:
                        BorderRadius.circular(AppConstants.radiusL),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      iconColor: AppColors.primaryDark,
                      collapsedIconColor: AppColors.textHint,
                      title: Text(
                        faq.question,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            faq.answer,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SupportCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.accent, size: 26),
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
      ),
    );
  }
}
