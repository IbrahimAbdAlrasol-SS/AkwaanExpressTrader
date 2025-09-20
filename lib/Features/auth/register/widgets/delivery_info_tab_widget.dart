import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/widgets/buttons/FillButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';

import 'package:Tosell/Features/auth/register/widgets/address_form_widget.dart';
import 'package:Tosell/Features/auth/register/widgets/location_display_widget.dart';
import 'package:Tosell/Features/profile/models/zone.dart';

/// ✅ ويدجت محتوى تاب معلومات الاستلام
class DeliveryInfoTabWidget extends ConsumerStatefulWidget {
  final VoidCallback onPrevious;
  final VoidCallback onSubmit;

  const DeliveryInfoTabWidget({
    super.key,
    required this.onPrevious,
    required this.onSubmit,
  });

  @override
  ConsumerState<DeliveryInfoTabWidget> createState() =>
      _DeliveryInfoTabWidgetState();
}

class _DeliveryInfoTabWidgetState extends ConsumerState<DeliveryInfoTabWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // متغيرات الموقع
  LatLng? _selectedLocation;
  Governorate? _selectedGovernorate;
  Zone? _selectedZone;

  /// معالج زر السابق
  void _handlePrevious() {
    widget.onPrevious();
  }

  /// معالج زر إرسال الطلب
  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      // التحقق من اختيار الموقع
      if (_selectedGovernorate == null || _selectedZone == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى اختيار المحافظة والمنطقة'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // TODO: تنفيذ منطق إرسال الطلب مع بيانات الموقع
      print('المحافظة المختارة: ${_selectedGovernorate!.name}');
      print('المنطقة المختارة: ${_selectedZone!.name}');
      if (_selectedLocation != null) {
        print(
            'الإحداثيات: ${_selectedLocation!.latitude}, ${_selectedLocation!.longitude}');
      }

      widget.onSubmit();

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  /// معالج تغيير الموقع على الخريطة
  void _onLocationSelected(LatLng? location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  /// معالج تغيير معلومات الموقع (المحافظة والمنطقة)
  void _onLocationInfoChanged(Governorate? governorate, Zone? zone) {
    setState(() {
      _selectedGovernorate = governorate;
      _selectedZone = zone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ويدجت عرض الموقع مع نظام البحث
          LocationDisplayWidget(
            onLocationSelected: _onLocationSelected,
            onLocationInfoChanged: _onLocationInfoChanged,
          ),

          const Gap(AppSpaces.large),

          // نموذج العنوان
          const AddressFormWidget(),

          const Gap(AppSpaces.large),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _handlePrevious,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "السابق",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const Gap(AppSpaces.medium),

              // زر إرسال الطلب
              Expanded(
                child: FillButton(
                  label: 'إرسال الطلب',
                  onPressed: _handleSubmit,
                  isLoading: _isLoading,
                  height: 50,
                  borderRadius: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
