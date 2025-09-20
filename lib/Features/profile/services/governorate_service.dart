import 'package:Tosell/Features/profile/models/zone.dart' as ZoneModel;
import 'package:Tosell/core/api/client/BaseClient.dart';

class GovernorateService {
  final BaseClient<ZoneModel.Governorate> baseClient;

  GovernorateService()
      : baseClient = BaseClient<ZoneModel.Governorate>(
            fromJson: (json) => ZoneModel.Governorate.fromJson(json));
  Future<List<ZoneModel.Governorate>> getAllZones(
      {Map<String, dynamic>? queryParams, int page = 1}) async {
    try {
      var result = await baseClient.getAll(
          endpoint: '/governorate', page: page, queryParams: queryParams);

      if (result.data == null) {
        return [];
      }

      return result.data!;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ZoneModel.Governorate>> searchGovernorates(String query,
      {int page = 1}) async {
    try {
      if (query.trim().isEmpty) {
        return await getAllZones(page: page);
      }

      // جلب جميع المحافظات من جميع الصفحات للبحث الصحيح
      List<ZoneModel.Governorate> allGovernorates = [];
      int currentPage = 1;
      bool hasMoreData = true;

      while (hasMoreData) {
        final pageResult = await getAllZones(page: currentPage);

        if (pageResult.isEmpty) {
          hasMoreData = false;
        } else {
          allGovernorates.addAll(pageResult);
          currentPage++;

          // إذا كانت النتائج أقل من 10 (حجم الصفحة المعتاد)، فهذا يعني أنها الصفحة الأخيرة
          if (pageResult.length < 10) {
            hasMoreData = false;
          }
        }
      }

      // البحث في جميع المحافظات
      final searchResults = allGovernorates
          .where((gov) =>
              gov.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();

      return searchResults;
    } catch (e) {
      rethrow;
    }
  }

  Future<ZoneModel.Governorate?> getGovernorateById(int id) async {
    try {
      final result = await baseClient.getById(
        endpoint: '/governorate',
        id: id.toString(),
      );

      return result.getSingle;
    } catch (e) {
      rethrow;
    }
  }
}
