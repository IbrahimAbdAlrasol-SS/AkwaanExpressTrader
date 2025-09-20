// lib/core/model_core/User.dart
import 'package:Tosell/Features/profile/models/zone.dart' as ZoneModel;
import 'package:Tosell/core/model_core/Role.dart';

class User {
  String? token;
  String? fullName;
  String? userName;
  String? phoneNumber;
  String? img;
  Role? role;
  ZoneModel.Zone? zone;
  dynamic branch;
  String? type;
  String? id;
  bool? deleted;
  String? creationDate;
  String? password;
  bool? isActive; // ✅ إضافة خاصية isActive

  User({
    this.token,
    this.fullName,
    this.userName,
    this.phoneNumber,
    this.img,
    this.role,
    this.zone,
    this.branch,
    this.type,
    this.id,
    this.deleted,
    this.password,
    this.creationDate,
    this.isActive, // ✅ إضافة في constructor
  });

  User.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    fullName = json['fullName'];
    userName = json['userName'];
    phoneNumber = json['phoneNumber'];
    role = json['role'] != null ? Role.fromJson(json['role']) : null;
    zone = json['zone'] != null ? ZoneModel.Zone.fromJson(json['zone']) : null;
    branch = json['branch'];
    type = json['type'];
    id = json['id'];
    deleted = json['deleted'];
    creationDate = json['creationDate'];
    img = json['img'];
    isActive = json['isActive']; // ✅ قراءة isActive من JSON
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['token'] = this.token;
    data['fullName'] = this.fullName;
    data['userName'] = this.userName;
    data['phoneNumber'] = this.phoneNumber;
    if (this.role != null) {
      data['role'] = this.role!.toJson();
    }
    if (this.zone != null) {
      data['zone'] = this.zone!.toJson();
    }
    data['password'] = this.password;
    data['branch'] = this.branch;
    data['type'] = this.type;
    data['id'] = this.id;
    data['deleted'] = this.deleted;
    data['creationDate'] = this.creationDate;
    data['img'] = this.img;
    data['isActive'] = this.isActive; // ✅ حفظ isActive في JSON
    return data;
  }
}
