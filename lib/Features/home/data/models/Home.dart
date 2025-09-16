
 
import 'package:Tosell/Features/order/orders/models/Order.dart';

class Home {
  int? pending; //
  int? inWarehouse; //
  int? inPickUpProgress; //
  int? inDeliveryProgress; //
  int? delivered; //
  int? others; //
  double? dailyProfits;
  int? dailyDoneOrders; //
  int? dailyReturnedOrders; //
  // List<Null>? notifications;
  List<Order>? orders;

  Home(
      {this.pending,
      this.inWarehouse,
      this.inPickUpProgress,
      this.inDeliveryProgress,
      this.delivered,
      this.others,
      this.dailyProfits,
      this.dailyDoneOrders,
      this.dailyReturnedOrders,
      // this.notifications,
      this.orders});

  Home.fromJson(Map<String, dynamic> json) {
    // معالجة القيم العددية بشكل آمن
    pending = _safeParseInt(json['pending']);
    inWarehouse = _safeParseInt(json['inWarehouse']);
    inPickUpProgress = _safeParseInt(json['inPickUpProgress']);
    inDeliveryProgress = _safeParseInt(json['inDeliveryProgress']);
    delivered = _safeParseInt(json['delivered']);
    others = _safeParseInt(json['others']);
    dailyProfits = _safeParseDouble(json['dailyProfits']);
    dailyDoneOrders = _safeParseInt(json['dailyDoneOrders']);
    dailyReturnedOrders = _safeParseInt(json['dailyReturnedOrders']);
    // if (json['notifications'] != null) {
    //   notifications = <Null>[];
    //   json['notifications'].forEach((v) {
    //     notifications!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['orders'] != null) {
      orders = <Order>[];
      try {
        if (json['orders'] is List) {
          for (var v in json['orders']) {
            if (v is Map<String, dynamic>) {
              orders!.add(Order.fromJson(v));
            }
          }
        }
      } catch (e) {
        // في حالة حدوث خطأ، نترك orders فارغة
        print('خطأ في معالجة الطلبات: $e');
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pending'] = this.pending;
    data['inWarehouse'] = this.inWarehouse;
    data['inPickUpProgress'] = this.inPickUpProgress;
    data['inDeliveryProgress'] = this.inDeliveryProgress;
    data['delivered'] = this.delivered;
    data['others'] = this.others;
    data['dailyProfits'] = this.dailyProfits;
    data['dailyDoneOrders'] = this.dailyDoneOrders;
    data['dailyReturnedOrders'] = this.dailyReturnedOrders;
    // if (this.notifications != null) {
    //   data['notifications'] =
    //       this.notifications!.map((v) => v.toJson()).toList();
    // }
    if (this.orders != null) {
      data['orders'] = this.orders!.map((v) => v.toJson()).toList();
    }
    return data;
  }
  
  // دوال مساعدة لمعالجة البيانات بشكل آمن
  static int? _safeParseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      try {
        return int.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
  
  static double? _safeParseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}