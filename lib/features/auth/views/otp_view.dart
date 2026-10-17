import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_widgets.dart';

class OtpView extends GetView<AuthController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Verify OTP'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'qwiko_logo',
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Text(
                        'Q',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Enter verification code',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.heading,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Text(
                  'We sent a 6-digit code to ${controller.fullPhone}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.caption,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Demo OTP: ${AuthController.mockOtp}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 28),
              Obx(
                () => OtpField(
                  digits: controller.otpDigits.toList(),
                  onChanged: (list) {
                    for (var i = 0; i < list.length; i++) {
                      controller.setOtpDigit(i, list[i]);
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                final s = controller.otpSeconds.value;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      s > 0 ? 'Resend OTP in ' : "Didn't receive OTP? ",
                      style: const TextStyle(color: AppColors.caption),
                    ),
                    if (s > 0)
                      Text(
                        '${s}s',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ).animate(key: ValueKey(s)).fadeIn(duration: 200.ms)
                    else
                      TextButton(
                        onPressed: controller.resendOtp,
                        child: const Text(
                          'Resend',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                  ],
                );
              }),
              const Spacer(),
              Obx(
                () => LoginPrimaryButton(
                  label: 'Verify & Continue',
                  isLoading: controller.isVerifying.value,
                  onPressed: controller.verifyOtp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
