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

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  static const _tabs = [
    ('upcoming', 'Upcoming'),
    ('delivered', 'Delivered'),
    ('cancelled', 'Cancelled'),
    ('returned', 'Returned'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('My Orders'),
          backgroundColor: AppColors.card,
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.secondary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
            tabs: _tabs.map((t) => Tab(text: t.$2)).toList(),
          ),
        ),
        body: TabBarView(
          children: _tabs.map((tab) {
            final orders = MockData.orders
                .where((o) => o.status == tab.$1)
                .toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

            if (orders.isEmpty) {
              return EmptyState(
                icon: _emptyIcon(tab.$1),
                title: 'No ${tab.$2.toLowerCase()} orders',
                subtitle: _emptySubtitle(tab.$1),
                actionLabel: tab.$1 == 'upcoming' ? null : 'Start Shopping',
                onAction: tab.$1 == 'upcoming'
                    ? null
                    : () => Get.offNamed(AppRoutes.main),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _OrderCard(order: orders[i]),
            );
          }).toList(),
        ),
      ),
    );
  }

  static IconData _emptyIcon(String status) {
    switch (status) {
      case 'upcoming':
        return Icons.schedule_rounded;
      case 'delivered':
        return Icons.check_circle_outline_rounded;
      case 'cancelled':
        return Icons.cancel_outlined;
      case 'returned':
        return Icons.assignment_return_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  static String _emptySubtitle(String status) {
    switch (status) {
      case 'upcoming':
        return 'You have no active orders right now.';
      case 'delivered':
        return 'Your delivered orders will appear here.';
      case 'cancelled':
        return 'Cancelled orders will show up in this tab.';
      case 'returned':
        return 'Returned orders will be listed here.';
      default:
        return AppStrings.noOrders;
    }
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  Color get _statusColor {
    switch (order.status) {
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

  String get _statusLabel => order.status[0].toUpperCase() +
      order.status.substring(1);

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]}, $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final preview = order.items.take(3).toList();

    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.orderDetail, arguments: order.id),
      child: Container(
        padding: const EdgeInsets.all(16),
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
            Row(
              children: [
                Text(
                  order.id,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              order.vendorName,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ...preview.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: item.image,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          width: 44,
                          height: 44,
                          color: AppColors.shimmerBase,
                        ),
                      ),
                    ),
                  ),
                ),
                if (order.items.length > 3)
                  Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '+${order.items.length - 3}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppUtils.formatPrice(order.total),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${order.items.length} item${order.items.length == 1 ? '' : 's'}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: AppColors.textHint,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatDate(order.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textHint,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
