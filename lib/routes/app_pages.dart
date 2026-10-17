import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/main_controller.dart';
import '../controllers/wishlist_controller.dart';
import '../core/auth/auth_action.dart';
import '../core/auth/auth_middleware.dart';
import '../features/address/views/address_view.dart';
import '../features/address/views/add_address_view.dart';
import '../features/auth/views/login_view.dart';
import '../features/auth/views/otp_view.dart';
import '../features/cart/views/cart_view.dart';
import '../features/categories/views/categories_view.dart';
import '../features/categories/views/category_detail_view.dart';
import '../features/checkout/views/checkout_view.dart';
import '../features/checkout/views/order_success_view.dart';
import '../features/help/views/help_view.dart';
import '../features/notifications/views/notifications_view.dart';
import '../features/offers/views/offers_view.dart';
import '../features/orders/views/order_detail_view.dart';
import '../features/orders/views/orders_view.dart';
import '../features/product/views/product_detail_view.dart';
import '../features/profile/views/profile_view.dart';
import '../features/profile/views/wishlist_view.dart';
import '../features/search/views/search_view.dart';
import '../features/settings/views/settings_view.dart';
import '../features/settings/views/legal_view.dart';
import '../features/splash/views/splash_view.dart';
import '../features/store/views/store_detail_view.dart';
import '../features/temp_webview/views/temporary_webview_screen.dart';
import '../features/tracking/views/tracking_view.dart';
import '../features/wallet/views/wallet_view.dart';
import '../features/main/views/main_shell.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      transition: Transition.fade,
    ),
    // TEMPORARY TESTING — remove this GetPage when reverting.
    GetPage(
      name: AppRoutes.temporaryWebView,
      page: () => const TemporaryWebViewScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainShell(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<MainController>()) {
          Get.put(MainController(), permanent: true);
        }
        if (!Get.isRegistered<CartController>()) {
          Get.put(CartController(), permanent: true);
        }
        if (!Get.isRegistered<WishlistController>()) {
          Get.put(WishlistController(), permanent: true);
        }
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 320),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.categoryDetail,
      page: () => const CategoryDetailView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.storeDetail,
      page: () => const StoreDetailView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.productDetail,
      page: () => const ProductDetailView(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: AppRoutes.cart,
      page: () => const CartView(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppRoutes.checkout,
      page: () => const CheckoutView(),
      middlewares: [AuthMiddleware(action: AuthAction.checkout)],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.orderSuccess,
      page: () => const OrderSuccessView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.orders,
      page: () => const OrdersView(),
      middlewares: [AuthMiddleware(action: AuthAction.orders)],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.orderDetail,
      page: () => const OrderDetailView(),
      middlewares: [AuthMiddleware(action: AuthAction.orders)],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.tracking,
      page: () => const TrackingView(),
      middlewares: [AuthMiddleware(action: AuthAction.orders)],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.wallet,
      page: () => const WalletView(),
      middlewares: [AuthMiddleware(action: AuthAction.wallet)],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.offers,
      page: () => const OffersView(),
      middlewares: [AuthMiddleware(action: AuthAction.offers)],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsView(),
      middlewares: [AuthMiddleware(action: AuthAction.notifications)],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.help,
      page: () => const HelpView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.address,
      page: () => const AddressView(),
      middlewares: [AuthMiddleware(action: AuthAction.addresses)],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.addAddress,
      page: () => const AddAddressView(),
      middlewares: [AuthMiddleware(action: AuthAction.addresses)],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.wishlist,
      page: () => const WishlistView(),
      middlewares: [AuthMiddleware(action: AuthAction.wishlist)],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.privacy,
      page: () => const LegalView(
            title: 'Privacy Policy',
            content:
                'Qwiko respects your privacy. We collect only what is needed to deliver your orders — address, contact details, and order history. We never sell your personal data. Location is used solely for delivery logistics. For questions, contact privacy@qwiko.app.',
          ),
    ),
    GetPage(
      name: AppRoutes.terms,
      page: () => const LegalView(
            title: 'Terms of Service',
            content:
                'By using Qwiko you agree to our terms of service. Orders are fulfilled by independent vendors. Delivery times are estimates. Refunds follow our refund policy. Prices may vary by location and availability. Misuse of the platform may result in account suspension.',
          ),
    ),
    GetPage(name: AppRoutes.categories, page: () => const CategoriesView()),
    GetPage(name: AppRoutes.search, page: () => const SearchView()),
    GetPage(name: AppRoutes.profile, page: () => const ProfileView()),
  ];
}
