// lib/Features/profile/services/zone_service.dart
import 'package:Tosell/Features/profile/models/zone.dart' as ZoneModel;
import 'package:Tosell/core/api/client/BaseClient.dart';

class ZoneService {
  final BaseClient<ZoneModel.Zone> baseClient;

  ZoneService()
      : baseClient = BaseClient<ZoneModel.Zone>(
            fromJson: (json) => ZoneModel.Zone.fromJson(json));

  /// جلب جميع المناطق من الباك اند
  Future<List<ZoneModel.Zone>> getAllZones(
      {Map<String, dynamic>? queryParams, int page = 1}) async {
    try {
      var result = await baseClient.getAll(
          endpoint: '/zone', page: page, queryParams: queryParams);

      if (result.data == null || result.data!.isEmpty) {
        return [];
      }

      return result.data!;
    } catch (e) {
      rethrow;
    }
  }

  /// جلب المناطق حسب ID المحافظة مع إمكانية البحث
  Future<List<ZoneModel.Zone>> getZonesByGovernorateId(
      {required int governorateId, String? query, int page = 1}) async {
    try {
      // جلب جميع المناطق من جميع الصفحات
      List<ZoneModel.Zone> allZones = [];
      int currentPage = 1;
      bool hasMoreData = true;

      while (hasMoreData) {
        final pageResult = await getAllZones(page: currentPage);

        if (pageResult.isEmpty) {
          hasMoreData = false;
        } else {
          allZones.addAll(pageResult);
          currentPage++;

          // إذا كانت النتائج أقل من 10 (حجم الصفحة المعتاد)، فهذا يعني أنها الصفحة الأخيرة
          if (pageResult.length < 10) {
            hasMoreData = false;
          }
        }
      }

      // تصفية المناطق حسب المحافظة
      var filteredZones = allZones.where((zone) {
        return zone.governorate?.id == governorateId;
      }).toList();

      // تطبيق البحث إذا كان موجوداً
      if (query != null && query.trim().isNotEmpty) {
        filteredZones = filteredZones
            .where((zone) =>
                zone.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
            .toList();
      }

      return filteredZones;
    } catch (e) {
      rethrow;
    }
  }

  /// جلب مناطق محددة حسب قائمة من الـ IDs
  Future<List<ZoneModel.Zone>> getZonesByIds(List<int> zoneIds) async {
    try {
      // جلب جميع المناطق من جميع الصفحات
      List<ZoneModel.Zone> allZones = [];
      int currentPage = 1;
      bool hasMoreData = true;

      while (hasMoreData) {
        final pageResult = await getAllZones(page: currentPage);

        if (pageResult.isEmpty) {
          hasMoreData = false;
        } else {
          allZones.addAll(pageResult);
          currentPage++;

          // إذا كانت النتائج أقل من 10 (حجم الصفحة المعتاد)، فهذا يعني أنها الصفحة الأخيرة
          if (pageResult.length < 10) {
            hasMoreData = false;
          }
        }
      }

      final filteredZones =
          allZones.where((zone) => zoneIds.contains(zone.id)).toList();

      return filteredZones;
    } catch (e) {
      rethrow;
    }
  }

  /// البحث في المناطق بالاسم
  Future<List<ZoneModel.Zone>> searchZones(String query, {int page = 1}) async {
    try {
      if (query.trim().isEmpty) {
        return await getAllZones(page: page);
      }

      // جلب جميع المناطق من جميع الصفحات للبحث الصحيح
      List<ZoneModel.Zone> allZones = [];
      int currentPage = 1;
      bool hasMoreData = true;

      while (hasMoreData) {
        final pageResult = await getAllZones(page: currentPage);

        if (pageResult.isEmpty) {
          hasMoreData = false;
        } else {
          allZones.addAll(pageResult);
          currentPage++;

          // إذا كانت النتائج أقل من 10 (حجم الصفحة المعتاد)، فهذا يعني أنها الصفحة الأخيرة
          if (pageResult.length < 10) {
            hasMoreData = false;
          }
        }
      }

      // البحث في جميع المناطق
      final searchResults = allZones
          .where((zone) =>
              zone.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();

      return searchResults;
    } catch (e) {
      rethrow;
    }
  }

  /// جلب المناطق الخاصة بالتاجر الحالي
  Future<List<ZoneModel.Zone>> getMyZones() async {
    try {
      // لهذا endpoint نحتاج ZoneObject لأنه يرجع { zone: {...} }
      final zoneObjectClient = BaseClient<ZoneModel.ZoneObject>(
          fromJson: (json) => ZoneModel.ZoneObject.fromJson(json));

      var result =
          await zoneObjectClient.get(endpoint: '/merchantzones/merchant');

      if (result.data == null) {
        return [];
      }

      final zones = result.data!.map((e) => e.zone!).toList();
      return zones;
    } catch (e) {
      rethrow;
    }
  }
}
