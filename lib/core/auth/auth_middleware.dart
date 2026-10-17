import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/auth_action.dart';
import '../../features/auth/controllers/auth_controller.dart';
import '../../routes/app_routes.dart';

/// Blocks protected named routes when the user is a guest.
class AuthMiddleware extends GetMiddleware {
  final AuthAction action;

  AuthMiddleware({required this.action, super.priority});

  @override
  RouteSettings? redirect(String? route) {
    if (!Get.isRegistered<AuthController>()) return null;
    if (Get.find<AuthController>().isLoggedIn.value) return null;

    Get.find<AuthController>().setPending(
      action: action,
      redirectRoute: route,
      onAuthenticated: () {
        if (route != null) Get.toNamed(route);
      },
    );

    return RouteSettings(
      name: AppRoutes.login,
      arguments: {'action': action},
    );
  }
}
