import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import '../theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isExpanded;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isExpanded = true,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: isOutlined
                  ? AppColors.buttonSecondaryText
                  : AppColors.buttonPrimaryText,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    final button = isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              minimumSize: Size(isExpanded ? double.infinity : 0, height),
              foregroundColor:
                  foregroundColor ?? AppColors.buttonSecondaryText,
              backgroundColor: AppColors.buttonSecondaryBg,
              side: const BorderSide(color: AppColors.buttonSecondaryBorder),
            ),
            child: child,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(isExpanded ? double.infinity : 0, height),
              backgroundColor: backgroundColor ?? AppColors.buttonPrimary,
              foregroundColor:
                  foregroundColor ?? AppColors.buttonPrimaryText,
              disabledBackgroundColor: AppColors.buttonDisabled,
            ),
            child: child,
          );

    return button;
  }
}

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) => AppButton(
        label: label,
        onPressed: onPressed,
        isLoading: isLoading,
        icon: icon,
      );
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) => AppButton(
        label: label,
        onPressed: onPressed,
        isOutlined: true,
        icon: icon,
      );
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingL,
        vertical: AppConstants.paddingS,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.heading,
              ),
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionLabel!,
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class DiscountBadge extends StatelessWidget {
  final int percent;
  final bool compact;

  const DiscountBadge({super.key, required this.percent, this.compact = false});

  @override
  Widget build(BuildContext context) {
    if (percent <= 0) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.discountBadge,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$percent% OFF',
        style: TextStyle(
          color: Colors.white,
          fontSize: compact ? 9 : 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class RatingWidget extends StatelessWidget {
  final double rating;
  final int? count;
  final double size;

  const RatingWidget({
    super.key,
    required this.rating,
    this.count,
    this.size = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, color: AppColors.rating, size: size),
              const SizedBox(width: 2),
              Text(
                rating.toStringAsFixed(1),
                style: TextStyle(
                  color: AppColors.heading,
                  fontSize: size,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (count != null) ...[
          const SizedBox(width: 4),
          Text(
            '($count)',
            style: TextStyle(
              fontSize: size,
              color: AppColors.caption,
            ),
          ),
        ],
      ],
    );
  }
}

class QuantityStepper extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final double size;

  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 0,
    this.max = 99,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    if (quantity == 0) {
      return GestureDetector(
        onTap: () => onChanged(1),
        child: Container(
          height: size,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.buttonPrimary,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: const Text(
            'ADD',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              color: AppColors.buttonPrimaryText,
            ),
          ),
        ),
      );
    }

    return Container(
      height: size,
      decoration: BoxDecoration(
        color: AppColors.buttonPrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove, () {
            if (quantity > min) onChanged(quantity - 1);
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$quantity',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: AppColors.buttonPrimaryText,
              ),
            ),
          ),
          _btn(Icons.add, () {
            if (quantity < max) onChanged(quantity + 1);
          }),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(icon, size: 16, color: AppColors.buttonPrimaryText),
      ),
    );
  }
}

class WishlistButton extends StatelessWidget {
  final bool isWishlisted;
  final VoidCallback onTap;
  final double size;

  const WishlistButton({
    super.key,
    required this.isWishlisted,
    required this.onTap,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
            ),
          ],
        ),
        child: Icon(
          isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isWishlisted ? AppColors.error : AppColors.textSecondary,
          size: size * 0.5,
        ),
      ),
    ).animate(target: isWishlisted ? 1 : 0).scale(
          begin: const Offset(1, 1),
          end: const Offset(1.15, 1.15),
          duration: 150.ms,
        );
  }
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.primaryDark),
            ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.heading,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 28),
              SizedBox(
                width: 200,
                child: PrimaryButton(label: actionLabel!, onPressed: onAction),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const LoadingShimmer({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.shimmerBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
