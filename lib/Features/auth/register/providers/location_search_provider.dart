import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/Features/profile/models/zone.dart';
import 'package:Tosell/Features/profile/services/governorate_service.dart';
import 'package:Tosell/Features/profile/services/zone_service.dart';

/// حالة البحث عن المحافظات
class GovernorateSearchState {
  final List<Governorate> governorates;
  final bool isLoading;
  final String? error;
  final String query;

  const GovernorateSearchState({
    this.governorates = const [],
    this.isLoading = false,
    this.error,
    this.query = '',
  });

  GovernorateSearchState copyWith({
    List<Governorate>? governorates,
    bool? isLoading,
    String? error,
    String? query,
  }) {
    return GovernorateSearchState(
      governorates: governorates ?? this.governorates,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      query: query ?? this.query,
    );
  }
}

/// حالة البحث عن المناطق
class ZoneSearchState {
  final List<Zone> zones;
  final bool isLoading;
  final String? error;
  final String query;
  final int? selectedGovernorateId;

  const ZoneSearchState({
    this.zones = const [],
    this.isLoading = false,
    this.error,
    this.query = '',
    this.selectedGovernorateId,
  });

  ZoneSearchState copyWith({
    List<Zone>? zones,
    bool? isLoading,
    String? error,
    String? query,
    int? selectedGovernorateId,
  }) {
    return ZoneSearchState(
      zones: zones ?? this.zones,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      query: query ?? this.query,
      selectedGovernorateId: selectedGovernorateId ?? this.selectedGovernorateId,
    );
  }
}

/// Provider للبحث عن المحافظات
class GovernorateSearchNotifier extends StateNotifier<GovernorateSearchState> {
  final GovernorateService _governorateService;
  Timer? _debounceTimer;

  GovernorateSearchNotifier(this._governorateService) : super(const GovernorateSearchState()) {
    // تحميل جميع المحافظات عند البداية
    loadAllGovernorates();
  }

  /// تحميل جميع المحافظات
  Future<void> loadAllGovernorates() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final governorates = await _governorateService.getAllZones();
      state = state.copyWith(
        governorates: governorates,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// البحث عن المحافظات مع debounce
  void searchGovernorates(String query) {
    // إلغاء المؤقت السابق
    _debounceTimer?.cancel();
    
    // تحديث الاستعلام فوراً
    state = state.copyWith(query: query);
    
    // إنشاء مؤقت جديد
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performSearch(query);
    });
  }

  /// تنفيذ البحث الفعلي
  Future<void> _performSearch(String query) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final governorates = await _governorateService.searchGovernorates(query);
      state = state.copyWith(
        governorates: governorates,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

/// Provider للبحث عن المناطق
class ZoneSearchNotifier extends StateNotifier<ZoneSearchState> {
  final ZoneService _zoneService;
  Timer? _debounceTimer;

  ZoneSearchNotifier(this._zoneService) : super(const ZoneSearchState());

  /// تحديد المحافظة وتحميل مناطقها
  Future<void> setGovernorate(int governorateId) async {
    state = state.copyWith(
      selectedGovernorateId: governorateId,
      isLoading: true,
      error: null,
      query: '',
    );
    
    try {
      final zones = await _zoneService.getZonesByGovernorateId(
        governorateId: governorateId,
      );
      state = state.copyWith(
        zones: zones,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// البحث في المناطق مع debounce
  void searchZones(String query) {
    // إلغاء المؤقت السابق
    _debounceTimer?.cancel();
    
    // تحديث الاستعلام فوراً
    state = state.copyWith(query: query);
    
    // إنشاء مؤقت جديد
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _performZoneSearch(query);
    });
  }

  /// تنفيذ البحث الفعلي في المناطق
  Future<void> _performZoneSearch(String query) async {
    if (state.selectedGovernorateId == null) return;
    
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final zones = await _zoneService.getZonesByGovernorateId(
        governorateId: state.selectedGovernorateId!,
        query: query,
      );
      state = state.copyWith(
        zones: zones,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// مسح البحث وإعادة تحميل جميع المناطق
  void clearSearch() {
    _debounceTimer?.cancel();
    if (state.selectedGovernorateId != null) {
      setGovernorate(state.selectedGovernorateId!);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

/// Providers للخدمات
final governorateServiceProvider = Provider<GovernorateService>((ref) {
  return GovernorateService();
});

final zoneServiceProvider = Provider<ZoneService>((ref) {
  return ZoneService();
});

/// Providers للبحث
final governorateSearchProvider = StateNotifierProvider<GovernorateSearchNotifier, GovernorateSearchState>((ref) {
  final service = ref.watch(governorateServiceProvider);
  return GovernorateSearchNotifier(service);
});

final zoneSearchProvider = StateNotifierProvider<ZoneSearchNotifier, ZoneSearchState>((ref) {
  final service = ref.watch(zoneServiceProvider);
  return ZoneSearchNotifier(service);
});

/// Provider للمحافظة المختارة
final selectedGovernorateProvider = StateProvider<Governorate?>((ref) => null);

/// Provider للمنطقة المختارة
final selectedZoneProvider = StateProvider<Zone?>((ref) => null);