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

class TrackingView extends StatelessWidget {
  const TrackingView({super.key});

  OrderModel? _findOrder() {
    final id = Get.arguments as String?;
    if (id == null) return null;
    try {
      return MockData.orders.firstWhere((o) => o.id == id);
    } catch (_) {
      return null;
    }
  }

  OrderTimelineItem? _currentStep(List<OrderTimelineItem> timeline) {
    if (timeline.isEmpty) return null;
    final active = timeline.where((t) => t.isCompleted).toList();
    if (active.isEmpty) return timeline.first;
    return active.last;
  }

  @override
  Widget build(BuildContext context) {
    final orderId = Get.arguments as String? ?? 'QW00000';
    final order = _findOrder();
    final timeline = order?.timeline ?? [];
    final currentStep = _currentStep(timeline);
    final partner = MockData.deliveryPartner;
    final etaMins = order?.etaMins ?? 15;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Track Order'),
        backgroundColor: AppColors.card,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: _MapPlaceholder(orderId: orderId),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppConstants.radiusXL),
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
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
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentStep?.title ?? 'Processing',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentStep?.subtitle ??
                                  'Your order is being prepared',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'ETA',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              AppUtils.deliveryLabel(etaMins),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Order $orderId',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (timeline.isNotEmpty) ...[
                    SizedBox(
                      height: 72,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: timeline.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final step = timeline[i];
                          return _TimelineChip(step: step);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusL),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: partner.avatar,
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              width: 52,
                              height: 52,
                              color: AppColors.shimmerBase,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                partner.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                partner.vehicle,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              RatingWidget(rating: partner.rating),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => AppUtils.showToast(
                            'Calling ${partner.phone}...',
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.2),
                          ),
                          icon: const Icon(Icons.phone_rounded),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () => AppUtils.showToast(
                            'Opening chat with ${partner.name}',
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.2),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline_rounded),
                        ),
                      ],
                    ),
                  ),
                  if (order == null) ...[
                    const SizedBox(height: 16),
                    SecondaryButton(
                      label: 'View All Orders',
                      onPressed: () => Get.toNamed(AppRoutes.orders),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  final String orderId;

  const _MapPlaceholder({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: _MapPatternPainter(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFE8F4EA),
                  AppColors.primaryLight.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delivery_dining_rounded,
                  size: 36,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.primaryDark.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: 16,
                  color: AppColors.error,
                ),
                const SizedBox(width: 6),
                Text(
                  orderId,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Live tracking',
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final blockPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.08);

    const blockSize = 40.0;
    for (var x = 0.0; x < size.width; x += blockSize) {
      for (var y = 0.0; y < size.height; y += blockSize) {
        if ((x / blockSize + y / blockSize).toInt().isEven) {
          canvas.drawRect(
            Rect.fromLTWH(x, y, blockSize, blockSize),
            blockPaint,
          );
        }
      }
    }

    for (var y = blockSize; y < size.height; y += blockSize * 2) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), roadPaint);
    }
    for (var x = blockSize; x < size.width; x += blockSize * 2) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), roadPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TimelineChip extends StatelessWidget {
  final OrderTimelineItem step;

  const _TimelineChip({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: step.isCompleted
            ? AppColors.primary.withValues(alpha: 0.15)
            : AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(
          color: step.isCompleted ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            step.isCompleted
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 18,
            color: step.isCompleted
                ? AppColors.success
                : AppColors.textHint,
          ),
          const SizedBox(height: 6),
          Text(
            step.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 11,
              color: step.isCompleted
                  ? AppColors.accent
                  : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
