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

      final allGovernorates = await getAllZones(page: page);
      final searchResults = allGovernorates
          .where((gov) =>
              gov.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();

      return searchResults;
    } catch (e) {
      rethrow;
    }
  }  Future<ZoneModel.Governorate?> getGovernorateById(int id) async {
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
