import 'package:flutter/material.dart';

class OrderEnum {
  String? name;
  Color? textColor;
  String? icon;
  Color? iconColor;

  Color? color;
  String? description;
  int? value;

  OrderEnum({
    this.name,
    this.icon,
    this.color,
    this.value,
    this.description,
    this.iconColor,
    this.textColor,
  });
}

var orderStatus = [
  //? index = 0
  OrderEnum(
      name: 'في الانتطار',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'طلبك قيد انتظار الموافقة',
      value: 0),
  //? index = 1
  OrderEnum(
      name: 'قائمة استحصال',
      color: const Color(0xFFE5F6FF),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'في قائمة الاستحصال',
      value: 1),
  //? index = 2
  OrderEnum(
      name: 'قيد الاستحصال',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: ' طلبك قيد الاستحصال من قبل المندوب',
      value: 2),
  //? index = 3 - AtPickUpPoint
  OrderEnum(
      name: 'في نقطة الاستحصال',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'الطلب في نقطة الاستحصال',
      value: 3),
  //? index = 4 - Received
  OrderEnum(
      name: 'تم الاستحصال',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'تم استحصال الطلب من قبل المندوب',
      value: 4),
  //? index = 5 - NotReceived
  OrderEnum(
      name: 'غير مستحصل',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'لم يتم استحصال الطلب من قبل المندوب',
      value: 5),
  //? index = 6 - InWarehouse
  OrderEnum(
      name: 'في المخزن',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'تم وصول الطلب الى المخزن',
      value: 6),
  //? index = 7 - InDeliveryShipment
  OrderEnum(
      name: 'في شحنة التوصيل',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'الطلب في شحنة التوصيل',
      value: 7),
  //? index = 8 - InDeliveryProgress
  OrderEnum(
      name: 'قيد التوصيل',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'طلبك قيد التوصيل للزبون',
      value: 8),
  //? index = 9 - AtDeliveryPoint
  OrderEnum(
      name: 'في نقطة التوصيل',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'الطلب في نقطة التوصيل',
      value: 9),
  //? index = 10 - Delivered
  OrderEnum(
      name: 'تم التوصيل',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'تم ايصال الطلب للزبون',
      value: 10),
  //? index = 11 - PartiallyDelivered
  OrderEnum(
      name: 'توصيل جزئي',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'تم الايصال الجزئي للزبون',
      value: 11),
  //? index = 12 - Rescheduled
  OrderEnum(
      name: 'اعادة جدولة',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'تم اعادة جدولة موعد الطلب',
      value: 12),
  //? index = 13 - Cancelled
  OrderEnum(
      name: 'ملغي',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'تم الغاء الطلب',
      value: 13),
  //? index = 14 - Refunded
  OrderEnum(
      name: 'مرتجع',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'تم ارجاع الطلب',
      value: 14),
  //? index = 15 - Completed
  OrderEnum(
      name: 'مكتمل',
      color: const Color(0xFFE8FCF5),
      iconColor: Colors.black,
      textColor: Colors.black,
      icon: 'assets/svg/box.svg',
      description: 'تم اكتمال الطلب',
      value: 15),
//? Order Status Values:
//? 0-  Pending - في الانتظار
//? 1-  InPickUpShipment - في شحنة الاستحصال
//? 2-  InPickUpProgress - قيد الاستحصال
//? 3-  AtPickUpPoint - في نقطة الاستحصال
//? 4-  Received - تم الاستلام
//? 5-  NotReceived - لم يتم الاستلام
//? 6-  InWarehouse - في المخزن
//? 7-  InDeliveryShipment - في شحنة التوصيل
//? 8-  InDeliveryProgress - قيد التوصيل
//? 9-  AtDeliveryPoint - في نقطة التوصيل
//? 10- Delivered - تم التوصيل
//? 11- PartiallyDelivered - توصيل جزئي
//? 12- Rescheduled - اعادة جدولة
//? 13- Cancelled - ملغي
//? 14- Refunded - مرتجع
//? 15- Completed - مكتمل
];

// ignore: unused_element

class OrderSizeEnum {
  String? name;

  int? value;

  OrderSizeEnum({
    this.name,
    this.value,
  });
}

var orderSizes = [
  OrderSizeEnum(name: 'صغير', value: 0),
  OrderSizeEnum(name: 'متوسط', value: 1),
  OrderSizeEnum(name: 'كبير', value: 2),
];
