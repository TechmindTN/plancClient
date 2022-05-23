import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/models/Notification.dart';
import 'app/models/User.dart';
import 'app/modules/auth/controllers/auth_controller.dart';
import 'app/modules/category/controllers/category_controller.dart';
import 'app/modules/e_service/controllers/e_service_controller.dart';
import 'app/modules/home/controllers/home_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/services/auth_service.dart';
import 'app/services/global_service.dart';
import 'app/services/settings_service.dart';
import 'app/services/translation_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void initServices() async {
  Get.log('starting services ...');
  Firebase.initializeApp();

  await Get.putAsync(() => TranslationService().init());
  await Get.putAsync(() => GlobalService().init());

  await Get.putAsync(() => AuthService().init());
  await Get.put(AuthController());

  await Get.putAsync(() => SettingsService().init());

  if (await Geolocator.isLocationServiceEnabled() == false) {
    Geolocator.openLocationSettings();
  }

  Get.log('All services started...');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var useremail = prefs.get('email');
  if (useremail != null) {
    var userpass = prefs.get('pass');
    Get.find<AuthController>().verifylogin(useremail, userpass);
  }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(
    GetMaterialApp(
      title: Get.find<SettingsService>().setting.value.appName,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      localizationsDelegates: [GlobalMaterialLocalizations.delegate],
      supportedLocales: Get.find<TranslationService>().supportedLocales(),
      translationsKeys: Get.find<TranslationService>().translations,
      locale: Get.find<TranslationService>().fallbackLocale,
      fallbackLocale: Get.find<TranslationService>().fallbackLocale,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      themeMode: Get.find<SettingsService>().getThemeMode(),
      theme: Get.find<SettingsService>()
          .getLightTheme(), //Get.find<SettingsService>().getLightTheme.value,
      darkTheme: Get.find<SettingsService>().getDarkTheme(),
    ),
  );
}
