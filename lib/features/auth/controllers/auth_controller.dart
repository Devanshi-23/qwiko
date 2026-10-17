import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/auth/auth_action.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/mock_data.dart';
import '../../../models/models.dart';
import '../../../routes/app_routes.dart';

class PendingAuthIntent {
  final AuthAction action;
  final void Function()? onAuthenticated;
  final String? redirectRoute;
  final dynamic redirectArgs;

  const PendingAuthIntent({
    required this.action,
    this.onAuthenticated,
    this.redirectRoute,
    this.redirectArgs,
  });
}

class AuthController extends GetxController {
  static const _keyLoggedIn = 'qwiko_auth_logged_in';
  static const _keyPhone = 'qwiko_auth_phone';
  static const _keyName = 'qwiko_auth_name';
  static const _keyMethod = 'qwiko_auth_method';
  static const keepCartOnLogout = true;

  /// Mock OTP accepted for demo.
  static const mockOtp = '123456';

  final _box = GetStorage();
  Timer? _otpTimer;

  final isLoggedIn = false.obs;
  final phone = ''.obs;
  final displayName = 'Guest User'.obs;
  final authMethod = ''.obs;
  final countryCode = '+91'.obs;
  final otpDigits = List.generate(6, (_) => '').obs;
  final otpSeconds = 30.obs;
  final isVerifying = false.obs;

  PendingAuthIntent? _pending;

  UserModel get sessionUser {
    if (!isLoggedIn.value) {
      return const UserModel(
        id: 'guest',
        name: 'Guest User',
        email: '',
        phone: '',
        avatar: '',
        membership: 'Guest',
        walletBalance: 0,
        rewardPoints: 0,
      );
    }
    final base = MockData.user;
    return UserModel(
      id: base.id,
      name: displayName.value.isNotEmpty ? displayName.value : base.name,
      email: base.email,
      phone: phone.value.isNotEmpty ? phone.value : base.phone,
      avatar: base.avatar,
      membership: base.membership,
      walletBalance: base.walletBalance,
      rewardPoints: base.rewardPoints,
    );
  }

  @override
  void onInit() {
    super.onInit();
    _restoreSession();
  }

  @override
  void onClose() {
    _otpTimer?.cancel();
    super.onClose();
  }

  void _restoreSession() {
    final logged = _box.read<bool>(_keyLoggedIn) ?? false;
    if (!logged) return;
    isLoggedIn.value = true;
    phone.value = _box.read<String>(_keyPhone) ?? MockData.user.phone;
    displayName.value = _box.read<String>(_keyName) ?? MockData.user.name;
    authMethod.value = _box.read<String>(_keyMethod) ?? 'mobile';
  }

  void setPending({
    required AuthAction action,
    void Function()? onAuthenticated,
    String? redirectRoute,
    dynamic redirectArgs,
  }) {
    _pending = PendingAuthIntent(
      action: action,
      onAuthenticated: onAuthenticated,
      redirectRoute: redirectRoute,
      redirectArgs: redirectArgs,
    );
  }

  PendingAuthIntent? consumePending() {
    final p = _pending;
    _pending = null;
    return p;
  }

  void updateCountryCode(String code) => countryCode.value = code;

  String get fullPhone {
    final p = phone.value;
    if (p.startsWith('+')) return p;
    return '${countryCode.value} $p'.trim();
  }

  void setPhone(String value) {
    phone.value = value.replaceAll(RegExp(r'\D'), '');
  }

  bool get isPhoneValid => phone.value.length >= 10;

  Future<void> sendOtp() async {
    if (!isPhoneValid) {
      AppUtils.showToast('Enter a valid mobile number', isError: true);
      return;
    }
    otpDigits.assignAll(List.generate(6, (_) => ''));
    otpSeconds.value = 30;
    AppUtils.showToast('OTP sent to $fullPhone (use $mockOtp)');
    Get.toNamed(AppRoutes.otp);
    _startOtpTimer();
  }

  void _startOtpTimer() {
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (otpSeconds.value <= 1) {
        otpSeconds.value = 0;
        t.cancel();
      } else {
        otpSeconds.value--;
      }
    });
  }

  void resendOtp() {
    if (otpSeconds.value > 0) return;
    otpSeconds.value = 30;
    AppUtils.showToast('OTP resent (use $mockOtp)');
    _startOtpTimer();
  }

  void setOtpDigit(int index, String value) {
    if (index < 0 || index >= 6) return;
    otpDigits[index] = value;
    otpDigits.refresh();
  }

  String get otpCode => otpDigits.join();

  Future<void> verifyOtp() async {
    if (otpCode.length != 6) {
      AppUtils.showToast('Enter the 6-digit OTP', isError: true);
      return;
    }
    isVerifying.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
    isVerifying.value = false;

    if (otpCode != mockOtp) {
      AppUtils.showToast('Invalid OTP. Try $mockOtp', isError: true);
      return;
    }

    await _completeLogin(
      method: 'mobile',
      name: 'Alex Rivera',
      phoneNumber: fullPhone,
    );
  }

  Future<void> loginWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _completeLogin(
      method: 'google',
      name: 'Alex Rivera',
      phoneNumber: '+91 98765 43210',
    );
  }

  Future<void> loginWithApple() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _completeLogin(
      method: 'apple',
      name: 'Alex Rivera',
      phoneNumber: '+91 98765 43210',
    );
  }

  Future<void> _completeLogin({
    required String method,
    required String name,
    required String phoneNumber,
  }) async {
    isLoggedIn.value = true;
    authMethod.value = method;
    displayName.value = name;
    phone.value = phoneNumber;

    await _box.write(_keyLoggedIn, true);
    await _box.write(_keyPhone, phoneNumber);
    await _box.write(_keyName, name);
    await _box.write(_keyMethod, method);

    AppUtils.showToast('Welcome to Qwiko, $name!');
    _resumePendingIntent();
  }

  void _resumePendingIntent() {
    final pending = consumePending();

    Get.until(
      (route) =>
          route.settings.name == AppRoutes.main ||
          route.settings.name == AppRoutes.splash ||
          route.isFirst,
    );

    if (pending == null) return;

    if (pending.redirectRoute != null) {
      Get.toNamed(
        pending.redirectRoute!,
        arguments: pending.redirectArgs,
      );
    } else {
      pending.onAuthenticated?.call();
    }
  }

  Future<void> logout() async {
    _otpTimer?.cancel();
    isLoggedIn.value = false;
    authMethod.value = '';
    displayName.value = 'Guest User';
    phone.value = '';
    otpDigits.assignAll(List.generate(6, (_) => ''));
    _pending = null;

    await _box.remove(_keyLoggedIn);
    await _box.remove(_keyPhone);
    await _box.remove(_keyName);
    await _box.remove(_keyMethod);

    AppUtils.showToast('Logged out. Continuing as Guest');
  }

  void continueAsGuest() {
    consumePending();
    if (Get.key.currentState?.canPop() ?? false) {
      Get.back();
    } else {
      Get.offAllNamed(AppRoutes.main);
    }
  }
}
