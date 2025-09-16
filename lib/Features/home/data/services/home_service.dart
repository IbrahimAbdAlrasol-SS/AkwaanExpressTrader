import 'package:Tosell/core/api/client/BaseClient.dart';
import 'package:Tosell/core/api/endpoints/APIendpoint.dart';
import 'package:Tosell/features/home/data/models/Home.dart';

class HomeService {
  final BaseClient<Home> baseClient;

  HomeService()
      : baseClient = BaseClient<Home>(fromJson: (json) => Home.fromJson(json));

  Future<Home?> getInfo() async {
    try {
      // var result = await baseClient.get(endpoint: 'dashboard/mobile');
      var result = await baseClient.get_noResponse(
          endpoint: DashboardEndpoints.mobileMerchant);
      // if (result.singleData == null) return Home();
      return result;
    } catch (e) {
      // في حالة فشل جلب البيانات، نعيد Home فارغ بدلاً من رمي الخطأ
      return Home();
    }
  }
}
