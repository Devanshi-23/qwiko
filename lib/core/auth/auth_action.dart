enum AuthAction {
  checkout,
  placeOrder,
  orders,
  wallet,
  addresses,
  wishlist,
  notifications,
  coupons,
  referral,
  profileEdit,
  paymentMethods,
  offers,
}

extension AuthActionX on AuthAction {
  String get title {
    switch (this) {
      case AuthAction.checkout:
        return 'Sign in to checkout';
      case AuthAction.placeOrder:
        return 'Sign in to place order';
      case AuthAction.orders:
        return 'Sign in to view orders';
      case AuthAction.wallet:
        return 'Sign in to access wallet';
      case AuthAction.addresses:
        return 'Sign in to manage addresses';
      case AuthAction.wishlist:
        return 'Sign in to sync wishlist';
      case AuthAction.notifications:
        return 'Sign in for notifications';
      case AuthAction.coupons:
        return 'Sign in to apply coupons';
      case AuthAction.referral:
        return 'Sign in to refer & earn';
      case AuthAction.profileEdit:
        return 'Sign in to edit profile';
      case AuthAction.paymentMethods:
        return 'Sign in to manage payments';
      case AuthAction.offers:
        return 'Sign in to view offers';
    }
  }

  String get subtitle =>
      'Login to continue with Qwiko — your cart stays saved.';
}
