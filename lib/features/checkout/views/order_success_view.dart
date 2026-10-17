import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../routes/app_routes.dart';

class OrderSuccessView extends StatelessWidget {
  const OrderSuccessView({super.key});

  String get _orderId {
    final args = Get.arguments;
    if (args is String && args.isNotEmpty) return args;
    final n = DateTime.now().millisecondsSinceEpoch % 100000;
    return 'QW${n.toString().padLeft(5, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingXXL),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 72,
                  color: AppColors.success,
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1, 1),
                    curve: Curves.easeOutBack,
                    duration: 600.ms,
                  ),
              const SizedBox(height: 32),
              Text(
                'Order Placed!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.accent,
                    ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              Text(
                'Your order has been confirmed and is being prepared.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              )
                  .animate()
                  .fadeIn(delay: 300.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Order ID',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _orderId,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 18,
                          color: AppColors.primaryDark,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Estimated delivery in ${AppUtils.deliveryLabel(15)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(delay: 400.ms)
                  .slideY(begin: 0.15, end: 0),
              const Spacer(),
              PrimaryButton(
                label: 'Track Order',
                icon: Icons.local_shipping_outlined,
                onPressed: () => Get.toNamed(
                  AppRoutes.tracking,
                  arguments: _orderId,
                ),
              )
                  .animate()
                  .fadeIn(delay: 500.ms),
              const SizedBox(height: 12),
              SecondaryButton(
                label: 'Continue Shopping',
                icon: Icons.storefront_outlined,
                onPressed: () => Get.offAllNamed(AppRoutes.main),
              )
                  .animate()
                  .fadeIn(delay: 600.ms),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
