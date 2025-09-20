import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gap/gap.dart';

/// ويدجت الخريطة التفاعلية التي تملأ حجم الورقة
class InteractiveMapWidget extends StatefulWidget {
  final Function(LatLng)? onLocationSelected;
  final LatLng? initialLocation;
  final bool showCurrentLocationButton;
  final bool showConfirmButton;
  final bool showAppBar;

  const InteractiveMapWidget({
    super.key,
    this.onLocationSelected,
    this.initialLocation,
    this.showCurrentLocationButton = true,
    this.showConfirmButton = true,
    this.showAppBar = true,
  });

  @override
  State<InteractiveMapWidget> createState() => _InteractiveMapWidgetState();
}

class _InteractiveMapWidgetState extends State<InteractiveMapWidget> {
  MapController? _mapController;
  LatLng? _selectedLocation;
  LatLng? _currentLocation;
  bool _isLoadingCurrentLocation = false;
  List<Marker> _markers = [];

  // الموقع الافتراضي (بغداد، العراق)
  static const LatLng _defaultLocation = LatLng(33.3152, 44.3661);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _selectedLocation = widget.initialLocation ?? _defaultLocation;
    _updateMarker(_selectedLocation!);
    _getCurrentLocation();
  }

  /// الحصول على الموقع الحالي
  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingCurrentLocation = true;
    });

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

      _currentLocation = LatLng(position.latitude, position.longitude);
    } catch (e) {
      _showSnackBar('خطأ في الحصول على الموقع الحالي');
    } finally {
      setState(() {
        _isLoadingCurrentLocation = false;
      });
    }
  }

  /// تحديث العلامة على الخريطة
  void _updateMarker(LatLng location) {
    setState(() {
      _markers = [
        Marker(
          point: location,
          child: GestureDetector(
            onTap: () {
              // يمكن إضافة معلومات إضافية هنا
            },
            child: const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 40,
            ),
          ),
        ),
      ];
    });
  }

  /// عند تغيير الموقع
  void _onLocationChanged(LatLng newLocation) {
    setState(() {
      _selectedLocation = newLocation;
    });
    _updateMarker(newLocation);
    widget.onLocationSelected?.call(newLocation);
  }

  /// الانتقال إلى الموقع الحالي
  void _goToCurrentLocation() {
    if (_currentLocation != null && _mapController != null) {
      _mapController!.move(_currentLocation!, 15);
      _onLocationChanged(_currentLocation!);
    } else {
      _getCurrentLocation();
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

  /// تأكيد اختيار الموقع
  void _confirmLocation() {
    if (_selectedLocation != null) {
      widget.onLocationSelected?.call(_selectedLocation!);
      Navigator.of(context).pop(_selectedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showAppBar) {
      // عرض الخريطة بدون شريط التطبيق (للاستخدام داخل ويدجت آخر)
      return Stack(
        children: [
          // الخريطة التفاعلية
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation ?? _defaultLocation,
              initialZoom: 13,
              onTap: (tapPosition, point) => _onLocationChanged(point),
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.Tosell',
              ),
              MarkerLayer(
                markers: _markers,
              ),
            ],
          ),

          // زر الموقع الحالي (للخريطة التفاعلية بدون شريط التطبيق)
          if (widget.showCurrentLocationButton)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed:
                      _isLoadingCurrentLocation ? null : _goToCurrentLocation,
                  icon: _isLoadingCurrentLocation
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
        ],
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // الخريطة التفاعلية
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation ?? _defaultLocation,
              initialZoom: 13,
              onTap: (tapPosition, point) => _onLocationChanged(point),
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.Tosell',
              ),
              MarkerLayer(
                markers: _markers,
              ),
            ],
          ),

          // شريط علوي مع أزرار التحكم
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // زر الإغلاق
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: Colors.black87,
                  ),
                ),

                // عنوان الخريطة
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'اختر الموقع',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),

                // زر الموقع الحالي
                if (widget.showCurrentLocationButton)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: _isLoadingCurrentLocation
                          ? null
                          : _goToCurrentLocation,
                      icon: _isLoadingCurrentLocation
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.my_location),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),

          // شريط سفلي مع معلومات الموقع وزر التأكيد
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // معلومات الموقع
                  const Text(
                    'الموقع المختار',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Gap(8),
                  if (_selectedLocation != null)
                    Text(
                      'خط العرض: ${_selectedLocation!.latitude.toStringAsFixed(6)}\n'
                      'خط الطول: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),

                  const Gap(16),

                  // زر التأكيد
                  if (widget.showConfirmButton)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _confirmLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'تأكيد الموقع',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
