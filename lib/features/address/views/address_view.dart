import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/cards_widgets.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/mock_data.dart';
import '../../../models/models.dart';
import '../../../routes/app_routes.dart';

class AddressView extends StatefulWidget {
  const AddressView({super.key});

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {
  late List<AddressModel> _addresses;

  @override
  void initState() {
    super.initState();
    _addresses = List<AddressModel>.from(MockData.addresses);
  }

  Future<void> _addAddress() async {
    final result = await Get.toNamed(AppRoutes.addAddress);
    if (result is AddressModel) {
      setState(() => _addresses.add(result));
    }
  }

  void _editAddress(AddressModel address) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        title: Text('Edit ${address.label}'),
        content: Text(
          'Edit address flow would open here.\n\n${address.fullAddress}',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              AppUtils.showToast('Address updated');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteAddress(AddressModel address) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        title: const Text('Delete Address'),
        content: Text(
          'Remove ${address.label} address?\n\n${address.fullAddress}',
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => _addresses.removeWhere((a) => a.id == address.id));
              Get.back();
              AppUtils.showToast('Address deleted');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Addresses'),
      ),
      body: Column(
        children: [
          const _MapPlaceholder(height: 160),
          Expanded(
            child: _addresses.isEmpty
                ? EmptyState(
                    icon: Icons.location_off_outlined,
                    title: 'No addresses saved',
                    subtitle: 'Add a delivery address to get started.',
                    actionLabel: 'Add Address',
                    onAction: _addAddress,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemCount: _addresses.length,
                    itemBuilder: (_, i) {
                      final address = _addresses[i];
                      return AddressCard(
                        address: address,
                        selected: address.isDefault,
                        onEdit: () => _editAddress(address),
                        onDelete: () => _deleteAddress(address),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addAddress,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.accent,
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text(
          'Add Address',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  final double height;

  const _MapPlaceholder({this.height = 180});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.map_outlined,
            size: 48,
            color: AppColors.primaryDark.withValues(alpha: 0.4),
          ),
          Positioned(
            bottom: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.my_location_rounded,
                      size: 14, color: AppColors.primaryDark),
                  SizedBox(width: 4),
                  Text(
                    'Map preview',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
