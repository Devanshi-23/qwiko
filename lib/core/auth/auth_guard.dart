import 'package:get/get.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../routes/app_routes.dart';
import 'auth_action.dart';

/// Central gate for protected actions. Use everywhere — do not duplicate checks.
class AuthGuard {
  AuthGuard._();

  static AuthController get _auth => Get.find<AuthController>();

  /// Runs [onAuthenticated] immediately if logged in; otherwise opens Login
  /// and resumes the action (or [redirectRoute]) after success.
  static void require({
    required AuthAction action,
    required void Function() onAuthenticated,
    String? redirectRoute,
    dynamic redirectArgs,
  }) {
    if (_auth.isLoggedIn.value) {
      onAuthenticated();
      return;
    }

    _auth.setPending(
      action: action,
      onAuthenticated: onAuthenticated,
      redirectRoute: redirectRoute,
      redirectArgs: redirectArgs,
    );

    Get.toNamed(
      AppRoutes.login,
      arguments: {'action': action},
    );
  }

  /// Convenience: require auth then navigate to [route].
  static void requireRoute(
    String route, {
    required AuthAction action,
    dynamic arguments,
  }) {
    require(
      action: action,
      redirectRoute: route,
      redirectArgs: arguments,
      onAuthenticated: () => Get.toNamed(route, arguments: arguments),
    );
  }

  static bool get isAuthenticated => _auth.isLoggedIn.value;
}
