import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/mock_data.dart';
import '../../../models/models.dart';
import '../../../routes/app_routes.dart';

class OrderDetailView extends StatelessWidget {
  const OrderDetailView({super.key});

  OrderModel? _findOrder() {
    final id = Get.arguments as String?;
    if (id == null) return null;
    try {
      return MockData.orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'upcoming':
        return AppColors.statusOnTheWay;
      case 'delivered':
        return AppColors.statusDelivered;
      case 'cancelled':
        return AppColors.statusCancelled;
      case 'returned':
        return AppColors.badgeOutOfStock;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = _findOrder();

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Order Details')),
        body: EmptyState(
          icon: Icons.receipt_long_outlined,
          title: 'Order not found',
          subtitle: 'This order could not be located.',
          actionLabel: 'View All Orders',
          onAction: () => Get.offNamed(AppRoutes.orders),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(order.id),
        backgroundColor: AppColors.card,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(order.status).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status[0].toUpperCase() + order.status.substring(1),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _statusColor(order.status),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Items',
            child: Column(
              children: order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: item.image,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            width: 56,
                            height: 56,
                            color: AppColors.shimmerBase,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Qty: ${item.quantity}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        AppUtils.formatPrice(item.price * item.quantity),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          _SectionCard(
            title: 'Price Breakdown',
            child: Column(
              children: [
                _PriceRow('Subtotal', order.subtotal),
                _PriceRow('Delivery Fee', order.deliveryFee),
                _PriceRow('Tax', order.tax),
                if (order.discount > 0)
                  _PriceRow(
                    'Discount',
                    -order.discount,
                    valueColor: AppColors.success,
                  ),
                const Divider(height: 20),
                _PriceRow('Total', order.total, isBold: true),
              ],
            ),
          ),
          _SectionCard(
            title: 'Delivery Address',
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primaryDark,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    order.address,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _SectionCard(
            title: 'Payment',
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.payment_rounded,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  order.paymentMethod,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (order.timeline.isNotEmpty)
            _SectionCard(
              title: 'Order Timeline',
              child: _OrderTimeline(timeline: order.timeline),
            ),
          if (order.status == 'upcoming') ...[
            const SizedBox(height: 8),
            PrimaryButton(
              label: 'Track Order',
              icon: Icons.local_shipping_outlined,
              onPressed: () => Get.toNamed(
                AppRoutes.tracking,
                arguments: order.id,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  label: 'Invoice',
                  icon: Icons.receipt_outlined,
                  onPressed: () =>
                      AppUtils.showToast('Invoice download coming soon'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SecondaryButton(
                  label: 'Support',
                  icon: Icons.headset_mic_outlined,
                  onPressed: () =>
                      AppUtils.showToast('Connecting to support...'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: AppColors.border),
      ),
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
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;
  final Color? valueColor;

  const _PriceRow(
    this.label,
    this.value, {
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isBold ? 15 : 13,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
                color: isBold ? AppColors.accent : AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            AppUtils.formatPrice(value),
            style: TextStyle(
              fontSize: isBold ? 16 : 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: valueColor ?? AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderTimeline extends StatelessWidget {
  final List<OrderTimelineItem> timeline;

  const _OrderTimeline({required this.timeline});

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: timeline.asMap().entries.map((entry) {
        final i = entry.key;
        final item = entry.value;
        final isLast = i == timeline.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: item.isCompleted
                          ? AppColors.success
                          : AppColors.border,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.isCompleted
                          ? Icons.check_rounded
                          : Icons.circle,
                      size: item.isCompleted ? 16 : 8,
                      color: item.isCompleted
                          ? Colors.white
                          : AppColors.textHint,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: item.isCompleted
                            ? AppColors.success.withValues(alpha: 0.4)
                            : AppColors.border,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: item.isCompleted
                                    ? AppColors.accent
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Text(
                            _formatTime(item.time),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
