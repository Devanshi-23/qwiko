import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/cards_widgets.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/mock_data.dart';
import '../../../models/models.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  static const _filters = ['All', 'Orders', 'Offers', 'Payments', 'General'];

  final _filterMap = {
    'Orders': 'orders',
    'Offers': 'offers',
    'Payments': 'payments',
    'General': 'general',
  };

  late List<NotificationModel> _notifications;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _notifications = MockData.notifications
        .map((n) => NotificationModel(
              id: n.id,
              title: n.title,
              body: n.body,
              type: n.type,
              time: n.time,
              isRead: n.isRead,
            ))
        .toList();
  }

  List<NotificationModel> get _filtered {
    if (_selectedFilter == 'All') return _notifications;
    final type = _filterMap[_selectedFilter];
    return _notifications.where((n) => n.type == type).toList();
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] =
            _notifications[index].copyWith(isRead: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _notifications = _notifications
                    .map((n) => n.copyWith(isRead: true))
                    .toList();
              });
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final filter = _filters[i];
                final selected = _selectedFilter == filter;
                return FilterChip(
                  label: Text(filter),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _selectedFilter = filter),
                  selectedColor: AppColors.primary.withValues(alpha: 0.25),
                  checkmarkColor: AppColors.accent,
                  labelStyle: TextStyle(
                    fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                    color: selected ? AppColors.accent : AppColors.textSecondary,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filtered.isEmpty
                ? EmptyState(
                    icon: Icons.notifications_none_rounded,
                    title: AppStrings.noNotifications,
                    subtitle:
                        'No $_selectedFilter notifications right now. Check back later!',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      indent: 76,
                    ),
                    itemBuilder: (_, i) {
                      final notification = filtered[i];
                      return NotificationTile(
                        notification: notification,
                        onTap: () => _markAsRead(notification.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
