import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../../data/mock_data.dart';
import '../../../models/models.dart';

class AddAddressView extends StatefulWidget {
  const AddAddressView({super.key});

  @override
  State<AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<AddAddressView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: MockData.user.name);
  final _phoneController = TextEditingController(text: MockData.user.phone);
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController(text: 'Bengaluru');
  final _pincodeController = TextEditingController();

  static const _labels = ['Home', 'Work', 'Other'];
  String _selectedLabel = 'Home';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final address = AddressModel(
      id: 'a${DateTime.now().millisecondsSinceEpoch}',
      label: _selectedLabel,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      addressLine: _addressController.text.trim(),
      landmark: _landmarkController.text.trim(),
      city: _cityController.text.trim(),
      pincode: _pincodeController.text.trim(),
    );

    AppUtils.showToast('Address saved successfully');
    Get.back(result: address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Address'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
          children: [
            const _MapPlaceholder(height: 140),
            const SizedBox(height: 20),
            const Text(
              'Address Label',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _labels.map((label) {
                final selected = _selectedLabel == label;
                return ChoiceChip(
                  label: Text(label),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedLabel = label),
                  selectedColor: AppColors.primary.withValues(alpha: 0.25),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? AppColors.accent
                        : AppColors.textSecondary,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            _Field(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person_outline_rounded,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter your name' : null,
            ),
            const SizedBox(height: 14),
            _Field(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) =>
                  v == null || v.trim().length < 10 ? 'Enter valid phone' : null,
            ),
            const SizedBox(height: 14),
            _Field(
              controller: _addressController,
              label: 'Address',
              icon: Icons.home_outlined,
              maxLines: 2,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter address' : null,
            ),
            const SizedBox(height: 14),
            _Field(
              controller: _landmarkController,
              label: 'Landmark (optional)',
              icon: Icons.place_outlined,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _Field(
                    controller: _cityController,
                    label: 'City',
                    icon: Icons.location_city_outlined,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? 'Enter city' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _Field(
                    controller: _pincodeController,
                    label: 'Pincode',
                    icon: Icons.pin_outlined,
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        v == null || v.trim().length != 6 ? 'Enter pincode' : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: PrimaryButton(
            label: 'Save Address',
            icon: Icons.check_rounded,
            onPressed: _save,
          ),
        ),
      ),
    );
  }
}

class _MapPlaceholder extends StatelessWidget {
  final double height;

  const _MapPlaceholder({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
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
            size: 40,
            color: AppColors.primaryDark.withValues(alpha: 0.4),
          ),
          Positioned(
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_location_alt_outlined,
                      size: 14, color: AppColors.primaryDark),
                  SizedBox(width: 4),
                  Text(
                    'Pin location on map',
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

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
      ),
    );
  }
}
