// lib/core/providers/home/home_provider.dart
import 'dart:async';
import 'package:Tosell/features/home/data/models/Home.dart';
import 'package:Tosell/features/home/data/services/home_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  final HomeService _service = HomeService();

  Future<Home?> get() async {
    return (await _service.getInfo());
  }

  @override
  FutureOr<Home> build() async {
    try {
      return await get() ?? Home();
    } catch (e) {
      // في حالة حدوث خطأ، نعيد Home فارغ بدلاً من رمي الخطأ
      return Home();
    }
  }
}