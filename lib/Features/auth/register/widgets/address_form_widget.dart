import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/widgets/inputs/CustomTextFormField.dart';
import 'package:Tosell/core/widgets/inputs/custom_search_drop_down.dart';
import 'package:Tosell/Features/profile/services/governorate_service.dart';
import 'package:Tosell/Features/profile/services/zone_service.dart';
import 'package:Tosell/Features/profile/models/zone.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// ويدجت نموذج العنوان مع حقول العنوان والمحافظة والمنطقة
class AddressFormWidget extends StatefulWidget {
  const AddressFormWidget({super.key});

  @override
  State<AddressFormWidget> createState() => _AddressFormWidgetState();
}

class _AddressFormWidgetState extends State<AddressFormWidget> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nearestLandmarkController =
      TextEditingController();

  final GovernorateService _governorateService = GovernorateService();
  final ZoneService _zoneService = ZoneService();

  Zone? _selectedProvince;
  Zone? _selectedRegion;

  @override
  void dispose() {
    _addressController.dispose();
    _nearestLandmarkController.dispose();
    super.dispose();
  }

  /// البحث في المحافظات من API
  Future<List<Zone>> _searchProvinces(String query) async {
    try {
      final governorates = await _governorateService.searchGovernorates(query);
      // تحويل Governorate إلى Zone
      return governorates.map((gov) => Zone(
        id: gov.id,
        name: gov.name,
        governorate: gov, // استخدام الـ governorate نفسه
      )).toList();
    } catch (e) {
      print('خطأ في جلب المحافظات: $e');
      return [];
    }
  }

  /// البحث في المناطق بناءً على المحافظة المختارة من API
  Future<List<Zone>> _searchRegions(String query) async {
    if (_selectedProvince == null) {
      return [];
    }

    try {
      final zones = await _zoneService.getZonesByGovernorateId(
        governorateId: _selectedProvince!.id!,
        query: query.isNotEmpty ? query : null,
      );
      return zones;
    } catch (e) {
      print('خطأ في جلب المناطق: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان القسم

        // حقل العنوان الرئيسي
        CustomTextFormField(
          label: 'العنوان',
          hint: 'مثال: العنوان الرئيسي',
          controller: _addressController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال العنوان';
            }
            return null;
          },
        ),

        const Gap(AppSpaces.large),

        // المحافظة
        RegistrationSearchDropDown<Zone>(
          label: 'المحافظة',
          hint: 'اختر المحافظة',
          selectedValue: _selectedProvince,
          itemAsString: (zone) => zone.name ?? '',
          asyncItems: _searchProvinces,
          onChanged: (zone) {
            setState(() {
              _selectedProvince = zone;
              _selectedRegion = null; // إعادة تعيين المنطقة عند تغيير المحافظة
            });
          },
          validator: (value) {
            if (_selectedProvince == null) {
              return 'يرجى اختيار المحافظة';
            }
            return null;
          },
        ),

        const Gap(AppSpaces.large),

        // المنطقة
        RegistrationSearchDropDown<Zone>(
          label: 'المنطقة',
          hint: 'اختر المنطقة',
          selectedValue: _selectedRegion,
          itemAsString: (zone) => zone.name ?? '',
          asyncItems: _searchRegions,
          onChanged: (zone) {
            setState(() {
              _selectedRegion = zone;
            });
          },
          validator: (value) {
            if (_selectedRegion == null) {
              return 'يرجى اختيار المنطقة';
            }
            return null;
          },
        ),

        const Gap(AppSpaces.large),

        // أقرب نقطة دالة
        CustomTextFormField(
          label: 'أقرب نقطة دالة',
          hint: 'مثال: بجانب مسجد النور',
          controller: _nearestLandmarkController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال أقرب نقطة دالة';
            }
            return null;
          },
        ),
      ],
    );
  }
}
