import 'package:Tosell/core/config/constants/spaces.dart';
import 'package:Tosell/core/widgets/inputs/CustomTextFormField.dart';
import 'package:Tosell/core/widgets/inputs/custom_search_drop_down.dart';
import 'package:Tosell/Features/profile/services/governorate_service.dart';
import 'package:Tosell/Features/profile/services/zone_service.dart';
import 'package:Tosell/Features/profile/models/zone.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DeliveryInfoWidget extends StatefulWidget {
  final VoidCallback? onPrevious;
  final VoidCallback? onSubmit;

  const DeliveryInfoWidget({
    super.key,
    this.onPrevious,
    this.onSubmit,
  });

  @override
  State<DeliveryInfoWidget> createState() => _DeliveryInfoWidgetState();
}

class _DeliveryInfoWidgetState extends State<DeliveryInfoWidget> {
  final TextEditingController _mainAddressController = TextEditingController();
  final TextEditingController _nearestPointController = TextEditingController();
  
  final GovernorateService _governorateService = GovernorateService();
  final ZoneService _zoneService = ZoneService();
  
  Zone? _selectedGovernorate;
  Zone? _selectedRegion;

  @override
  void dispose() {
    _mainAddressController.dispose();
    _nearestPointController.dispose();
    super.dispose();
  }

  // جلب المحافظات من API
  Future<List<Zone>> _getGovernorates(String query) async {
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

  // جلب المناطق من API بناءً على المحافظة المختارة
  Future<List<Zone>> _getRegions(String query) async {
    if (_selectedGovernorate == null) {
      return [];
    }

    try {
      final zones = await _zoneService.getZonesByGovernorateId(
        governorateId: _selectedGovernorate!.id!,
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
    return Container(
      color: const Color(0xFF141B34),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Header Section
            _buildLocationHeader(),
            const Gap(AppSpaces.medium),
            
            // Map Container
            _buildMapContainer(),
            const Gap(AppSpaces.large),
            
            // Address Form Section
            _buildAddressForm(),
            const Gap(AppSpaces.large),
            
            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'الموقع',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w300,
            height: 24 / 16, // line-height: 24px
            letterSpacing: 0,
          ),
        ),
        Text(
          'تعديل موقع',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontWeight: FontWeight.w300,
            height: 24 / 16, // line-height: 24px
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildMapContainer() {
    return Container(
      width: 398,
      height: 150,
      padding: const EdgeInsets.fromLTRB(19, 12, 19, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/map.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.map,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAddressForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address Title
        Text(
          'اسم العنوان',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(AppSpaces.medium),
        
        // Main Address Field
        CustomTextFormField(
          label: 'العنوان',
          hint: 'مثال: العنوان الرئيسي',
          controller: _mainAddressController,
          fillColor: Colors.white,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال العنوان الرئيسي';
            }
            return null;
          },
        ),
        const Gap(AppSpaces.medium),
        
        // Governorate Search Dropdown
        RegistrationSearchDropDown<Zone>(
          label: 'المحافظة',
          hint: 'اختر المحافظة',
          selectedValue: _selectedGovernorate,
          itemAsString: (item) => item.name??'',
          onChanged: (value) {
            setState(() {
              _selectedGovernorate = value;
              _selectedRegion = null; // Reset region when governorate changes
            });
          },
          asyncItems: _getGovernorates,
          validator: (value) {
            if (_selectedGovernorate == null) {
              return 'يرجى اختيار المحافظة';
            }
            return null;
          },
        ),
        const Gap(AppSpaces.medium),
        
        // Region Search Dropdown
        RegistrationSearchDropDown<Zone>(
          label: 'المنطقة',
          hint: 'اختر المنطقة',
          selectedValue: _selectedRegion,
          itemAsString: (item) => item.name?? " ",
          onChanged: (value) {
            setState(() {
              _selectedRegion = value;
            });
          },
          asyncItems: _getRegions,
          validator: (value) {
            if (_selectedRegion == null) {
              return 'يرجى اختيار المنطقة';
            }
            return null;
          },
        ),
        const Gap(AppSpaces.medium),
        
        // Nearest Point Field
        CustomTextFormField(
          label: 'أقرب نقطة دالة',
          hint: 'أدخل أقرب نقطة دالة',
          controller: _nearestPointController,
          fillColor: Colors.white,
          labelStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'يرجى إدخال أقرب نقطة دالة';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Previous Button
        Expanded(
          child: OutlinedButton(
            onPressed: widget.onPrevious,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text(
              'السابق',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const Gap(AppSpaces.medium),
        
        // Submit Button
        Expanded(
          child: ElevatedButton(
            onPressed: widget.onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text(
              'إرسال طلب',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}