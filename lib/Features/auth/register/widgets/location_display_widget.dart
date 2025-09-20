import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/Features/auth/register/widgets/interactive_map_widget.dart';
import 'package:Tosell/Features/profile/models/zone.dart';

/// ويدجت عرض الموقع
class LocationDisplayWidget extends ConsumerStatefulWidget {
  final Function(LatLng?) onLocationSelected;
  final Function(Governorate?, Zone?)? onLocationInfoChanged;

  const LocationDisplayWidget({
    super.key,
    required this.onLocationSelected,
    this.onLocationInfoChanged,
  });

  @override
  ConsumerState<LocationDisplayWidget> createState() =>
      _LocationDisplayWidgetState();
}

class _LocationDisplayWidgetState extends ConsumerState<LocationDisplayWidget> {
  LatLng? _selectedLocation;
  bool _showInteractiveMap = false;
  Governorate? _selectedGovernorate;
  Zone? _selectedZone;

  // الموقع الافتراضي (بغداد، العراق)
  static const LatLng _defaultLocation = LatLng(33.3152, 44.3661);

  @override
  void initState() {
    super.initState();
    _selectedLocation = _defaultLocation;
  }

  /// تبديل عرض الخريطة التفاعلية
  void _toggleInteractiveMap() {
    setState(() {
      _showInteractiveMap = !_showInteractiveMap;
    });
  }

  /// تحديث الموقع المحدد
  void _onLocationSelected(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _showInteractiveMap = false; // إخفاء الخريطة بعد اختيار الموقع
    });
    widget.onLocationSelected(location);
  }

  /// تحديث معلومات الموقع (المحافظة والمنطقة)
  void _onLocationInfoChanged(Governorate? governorate, Zone? zone) {
    setState(() {
      _selectedGovernorate = governorate;
      _selectedZone = zone;
    });
    widget.onLocationInfoChanged?.call(governorate, zone);
  }

  /// الحصول على الموقع الحالي
  Future<void> _getCurrentLocation() async {
    try {
      // التحقق من الأذونات
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar('تم رفض إذن الموقع');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnackBar('إذن الموقع مرفوض نهائياً. يرجى تفعيله من الإعدادات');
        return;
      }

      // الحصول على الموقع الحالي
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng currentLocation = LatLng(position.latitude, position.longitude);
      _onLocationSelected(currentLocation);
    } catch (e) {
      _showSnackBar('خطأ في الحصول على الموقع الحالي');
    }
  }

  /// عرض رسالة
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // نظام البحث عن المحافظة والمنطقة

      // قسم الخريطة
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // عنوان قسم الخريطة

        // زر التعديل
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            TextButton(
              onPressed: _toggleInteractiveMap,
              child: Text(
                _showInteractiveMap ? 'إخفاء الخريطة' : 'تعديل موقع',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),

        const Gap(12),

        // عرض الخريطة
        Container(
          height: _showInteractiveMap ? 400 : 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _showInteractiveMap
                ? // الخريطة التفاعلية
                InteractiveMapWidget(
                    initialLocation: _selectedLocation,
                    onLocationSelected: _onLocationSelected,
                    showAppBar: false, // إخفاء شريط التطبيق
                  )
                : // خريطة المعاينة
                Stack(
                    children: [
                      // خريطة Flutter Map صغيرة (معاينة)
                      if (_selectedLocation != null)
                        FlutterMap(
                          options: MapOptions(
                            initialCenter: _selectedLocation!,
                            initialZoom: 15,
                            interactionOptions: const InteractionOptions(
                              flags: InteractiveFlag.none,
                            ),
                            onTap: (_, __) => _toggleInteractiveMap(),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.Tosell',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: _selectedLocation!,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      else
                        // في حالة عدم وجود موقع، عرض رمز بديل
                        Container(
                          color: Colors.grey.shade100,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.map,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const Gap(8),
                                Text(
                                  'اضغط لاختيار الموقع',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // طبقة شفافة للنقر (فقط في وضع المعاينة)
                      if (!_showInteractiveMap)
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _toggleInteractiveMap,
                              borderRadius: BorderRadius.circular(12),
                              child: Container(),
                            ),
                          ),
                        ),

                      // زر الموقع الحالي (فقط في وضع المعاينة)
                      if (!_showInteractiveMap)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _getCurrentLocation,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.my_location,
                                  size: 20,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),

                      // مؤشر الموقع في الزاوية (فقط في وضع المعاينة)
                      if (_selectedLocation != null && !_showInteractiveMap)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                const Gap(4),
                                Text(
                                  'تم تحديد الموقع',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ),
      ])
    ]);
  }
}
