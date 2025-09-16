import 'dart:io';

import 'package:Tosell/Features/profile/services/governorate_service.dart';
import 'package:Tosell/Features/profile/services/zone_service.dart';
import 'package:Tosell/core/config/routes/app_router.dart';
import 'package:Tosell/core/config/theme/ThemeNotifier.dart';
import 'package:Tosell/core/config/theme/app_theme.dart';
import 'package:Tosell/core/utils/helpers/HttpOverrides.dart';
import 'package:Tosell/core/utils/helpers/SharedPreferencesHelper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  var token = (await SharedPreferencesHelper.getUser())?.token;
  token == null
      ? initialLocation = AppRoutes.login
      : initialLocation = AppRoutes.home;

  _testDataFetching();

  runApp(
    ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(360, 690), // Reference screen size (design size)
        builder: (context, child) {
          return EasyLocalization(
            supportedLocales: const [Locale('en'), Locale('ar')],
            path: 'assets/lang',
            startLocale: const Locale("ar"),
            fallbackLocale: const Locale('ar'),
            child: const MyApp(), // Your root widget
          );
        },
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp.router(
      title: 'Flutter Riverpod App',
      routerConfig: appRouter,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}

// دالة اختبار جلب البيانات
Future<void> _testDataFetching() async {
  try {
    print('🧪 بدء اختبار جلب البيانات من main.dart');
    
    final governorateService = GovernorateService();
    final zoneService = ZoneService();
    
    print('🏛️ اختبار جلب المحافظات...');
    final governorates = await governorateService.getAllZones();
    print('✅ تم جلب ${governorates.length} محافظة');
    
    print('🌍 اختبار جلب المناطق...');
    final zones = await zoneService.getAllZones();
    print('✅ تم جلب ${zones.length} منطقة');
    
  } catch (e) {
    print('❌ خطأ في اختبار جلب البيانات: $e');
  }
}
