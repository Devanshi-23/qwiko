import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppUtils {
  AppUtils._();

  static void showToast(String message, {bool isError = false}) {
    Get.snackbar(
      '',
      message,
      titleText: const SizedBox.shrink(),
      messageText: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF1E1E1E),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  static String formatPrice(num price) {
    if (price % 1 == 0) return '₹${price.toInt()}';
    return '₹${price.toStringAsFixed(2)}';
  }

  static String deliveryLabel(int minutes) {
    if (minutes < 60) return '$minutes mins';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }
}
