import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/cart_controller.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/cards_widgets.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/mock_data.dart';
import '../../../routes/app_routes.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  late String _selectedAddressId;
  String _deliverySlot = 'Now';
  String _paymentMethod = 'UPI';
  final _instructionsController = TextEditingController();

  final _deliverySlots = const ['Now', '10-20 min', 'Schedule'];
  final _paymentMethods = const [
    ('UPI', Icons.account_balance_rounded),
    ('Card', Icons.credit_card_rounded),
    ('Wallet', Icons.account_balance_wallet_rounded),
    ('COD', Icons.payments_rounded),
  ];

  CartController get _cart => Get.find<CartController>();

  @override
  void initState() {
    super.initState();
    _selectedAddressId = MockData.addresses
        .firstWhere((a) => a.isDefault, orElse: () => MockData.addresses.first)
        .id;
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  String _generateOrderId() {
    final n = DateTime.now().millisecondsSinceEpoch % 100000;
    return 'QW${n.toString().padLeft(5, '0')}';
  }

  void _placeOrder() {
    if (_cart.items.isEmpty) {
      AppUtils.showToast('Your cart is empty', isError: true);
      return;
    }
    final orderId = _generateOrderId();
    _cart.clear();
    Get.offNamed(AppRoutes.orderSuccess, arguments: orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColors.card,
      ),
      body: Obx(() {
        if (_cart.items.isEmpty) {
          return EmptyState(
            icon: Icons.shopping_cart_outlined,
            title: 'Cart is empty',
            subtitle: 'Add items to your cart before checkout.',
            actionLabel: 'Continue Shopping',
            onAction: () => Get.offNamed(AppRoutes.main),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  const SectionHeader(title: 'Delivery Address'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: MockData.addresses.map((address) {
                        return AddressCard(
                          address: address,
                          selected: _selectedAddressId == address.id,
                          onTap: () =>
                              setState(() => _selectedAddressId = address.id),
                        );
                      }).toList(),
                    ),
                  ),
                  const SectionHeader(title: 'Delivery Time'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _deliverySlots.map((slot) {
                        final selected = _deliverySlot == slot;
                        return ChoiceChip(
                          label: Text(slot),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _deliverySlot = slot),
                          selectedColor:
                              AppColors.primary.withValues(alpha: 0.35),
                          labelStyle: TextStyle(
                            fontWeight:
                                selected ? FontWeight.w800 : FontWeight.w500,
                            color: AppColors.accent,
                          ),
                          side: BorderSide(
                            color: selected
                                ? AppColors.primaryDark
                                : AppColors.border,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusM),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SectionHeader(title: 'Payment Method'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: _paymentMethods.map((method) {
                        final (label, icon) = method;
                        final selected = _paymentMethod == label;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _paymentMethod = label),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusL,
                              ),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.border,
                                width: selected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(icon, color: AppColors.accent),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    label,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                Icon(
                                  selected
                                      ? Icons.radio_button_checked_rounded
                                      : Icons.radio_button_off_rounded,
                                  color: selected
                                      ? AppColors.primaryDark
                                      : AppColors.textHint,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius:
                            BorderRadius.circular(AppConstants.radiusL),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Use Qwiko Wallet',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          'Balance: ${AppUtils.formatPrice(MockData.user.walletBalance)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        value: _cart.useWallet.value,
                        activeTrackColor: AppColors.primary,
                        onChanged: (v) => _cart.useWallet.value = v,
                      ),
                    ),
                  ),
                  if (_cart.appliedCoupon.value != null) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusL),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_offer_rounded,
                              color: AppColors.primaryDark,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _cart.appliedCoupon.value!.code,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    _cart.appliedCoupon.value!.title,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '-${AppUtils.formatPrice(_cart.discount)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SectionHeader(title: 'Delivery Instructions'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _instructionsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Add delivery notes (optional)',
                        filled: true,
                        fillColor: AppColors.card,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusL),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusL),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppConstants.radiusL),
                          borderSide: const BorderSide(
                            color: AppColors.primaryDark,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SectionHeader(title: 'Order Summary'),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _OrderSummary(cart: _cart),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.card,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          AppUtils.formatPrice(_cart.total),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Place Order',
                        icon: Icons.check_circle_outline_rounded,
                        onPressed: _placeOrder,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final CartController cart;

  const _OrderSummary({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          ...cart.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.quantity}x ${item.name}',
                      style: const TextStyle(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    AppUtils.formatPrice(item.total),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 20),
          _SummaryRow('Subtotal', cart.subtotal),
          _SummaryRow('Delivery Fee', cart.deliveryFee),
          _SummaryRow('Tax (5%)', cart.tax),
          if (cart.discount > 0)
            _SummaryRow(
              'Discount',
              -cart.discount,
              valueColor: AppColors.success,
            ),
          if (cart.walletDeduction > 0)
            _SummaryRow(
              'Wallet',
              -cart.walletDeduction,
              valueColor: AppColors.info,
            ),
          const Divider(height: 20),
          _SummaryRow(
            'Total',
            cart.total,
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow(
    this.label,
    this.value, {
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isBold ? 15 : 13,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
                color: isBold ? AppColors.accent : AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            AppUtils.formatPrice(value),
            style: TextStyle(
              fontSize: isBold ? 16 : 13,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
              color: valueColor ?? AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
