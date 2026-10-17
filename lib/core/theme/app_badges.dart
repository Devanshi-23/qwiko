/// Design system helpers & reusable badge widgets
library;

import 'package:flutter/material.dart';
import 'app_colors.dart';

enum AppBadgeType { isNew, hot, sale, outOfStock }

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const StatusBadge({super.key, required this.label, required this.color});

  factory StatusBadge.order(String status) {
    switch (status.toLowerCase()) {
      case 'available':
        return StatusBadge(label: 'Available', color: AppColors.statusAvailable);
      case 'preparing':
        return StatusBadge(label: 'Preparing', color: AppColors.statusPreparing);
      case 'on the way':
      case 'upcoming':
        return StatusBadge(label: 'On the Way', color: AppColors.statusOnTheWay);
      case 'delivered':
        return StatusBadge(label: 'Delivered', color: AppColors.statusDelivered);
      case 'cancelled':
        return StatusBadge(label: 'Cancelled', color: AppColors.statusCancelled);
      default:
        return StatusBadge(label: status, color: AppColors.textSecondary);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class ProductBadge extends StatelessWidget {
  final AppBadgeType type;

  const ProductBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (type) {
      AppBadgeType.isNew => ('NEW', AppColors.badgeNew),
      AppBadgeType.hot => ('HOT', AppColors.badgeHot),
      AppBadgeType.sale => ('SALE', AppColors.badgeSale),
      AppBadgeType.outOfStock => ('OUT OF STOCK', AppColors.badgeOutOfStock),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
