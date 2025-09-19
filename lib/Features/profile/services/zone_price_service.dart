import 'package:Tosell/Features/profile/models/zone.dart' as ZoneModel;
import 'package:Tosell/core/api/client/BaseClient.dart';

class ZonePriceService {
  final BaseClient<ZoneModel.Zone> baseClient;

  ZonePriceService()
      : baseClient = BaseClient<ZoneModel.Zone>(
            fromJson: (json) => ZoneModel.Zone.fromJson(json));

  Future<List<ZoneModel.Zone>> getAllZones(
      {required String governorateId, int page = 1}) async {
    try {
      var result = await baseClient.getAll(
          endpoint: '/zone',
          page: page,
          queryParams: {'governorateId': governorateId});
      if (result.data == null) return [];
      return result.data ?? [];
    } catch (e) {
      rethrow;
    }
  }
}
