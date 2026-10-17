import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/auth/auth_action.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_widgets.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  bool get _showApple {
    if (kIsWeb) return false;
    try {
      return Platform.isIOS || Platform.isMacOS;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    AuthAction? action;
    if (args is Map && args['action'] is AuthAction) {
      action = args['action'] as AuthAction;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Hero(
                  tag: 'qwiko_logo',
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'Q',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9)),
              const SizedBox(height: 16),
              const Text(
                'Qwiko',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.heading,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                action?.title ?? 'Welcome Back',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.body,
                ),
              ),
              if (action != null) ...[
                const SizedBox(height: 6),
                Text(
                  action.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.caption,
                  ),
                ),
              ],
              const SizedBox(height: 28),
              const Text(
                'Mobile Number',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  children: [
                    CountryPicker(
                      code: controller.countryCode.value,
                      onChanged: controller.updateCountryCode,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: controller.setPhone,
                        decoration: const InputDecoration(
                          hintText: '10-digit mobile number',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              LoginPrimaryButton(
                label: 'Continue',
                onPressed: controller.sendOtp,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: AppColors.caption,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),
              SocialLoginButton(
                label: 'Continue with Google',
                icon: Icons.g_mobiledata_rounded,
                iconColor: const Color(0xFFEA4335),
                onPressed: controller.loginWithGoogle,
              ),
              if (_showApple) ...[
                const SizedBox(height: 12),
                SocialLoginButton(
                  label: 'Continue with Apple',
                  icon: Icons.apple,
                  onPressed: controller.loginWithApple,
                ),
              ],
              const SizedBox(height: 16),
              TextButton(
                onPressed: controller.continueAsGuest,
                child: const Text(
                  'Continue as Guest',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text(
                    'By continuing, you agree to our ',
                    style: TextStyle(fontSize: 12, color: AppColors.caption),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.terms),
                    child: const Text(
                      'Terms',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                  const Text(
                    ' & ',
                    style: TextStyle(fontSize: 12, color: AppColors.caption),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.privacy),
                    child: const Text(
                      'Privacy Policy',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
