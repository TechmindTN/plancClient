import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../../routes/app_pages.dart';
import '../../services/settings_service.dart';
import '../../services/translation_service.dart';
import '../../their_models/media_model.dart';
import '../auth/controllers/auth_controller.dart';

class NetworkError extends StatefulWidget{
  @override
  State<NetworkError> createState() => _NetworkErrorState();
}

class _NetworkErrorState extends State<NetworkError> {
final Connectivity _connectivity = Connectivity();
ConnectivityResult _connectionStatus =ConnectivityResult.none;
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
@override
initState() {
  super.initState();

initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
}

// Be sure to cancel subscription after you are done
@override
dispose() {
  super.dispose();

_connectivitySubscription.cancel();
}

  Future<void> initConnectivity() async {
     ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() async {
      _connectionStatus = result;
      if(_connectionStatus==ConnectivityResult.wifi){
        print('got connection WIFI');
        Firebase.initializeApp();
        // await initServices();
        // Phoenix.rebirth(context);
        
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  // var useremail = prefs.get('email');
  // if (useremail != null) {
  //   var userpass = prefs.get('pass');
  //   Get.find<AuthController>().verifylogin(useremail, userpass);
  // }

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

        Future.delayed(Duration(seconds: 1),(){
          runApp(
    Phoenix(
      child: GetMaterialApp(
        // title: Get.find<SettingsService>().setting.value.appName,
    
        initialRoute: ini,
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
    ),
  );
Navigator.pushReplacementNamed(context, AppPages.INITIAL);
        });
        
        }
        else if(_connectionStatus==ConnectivityResult.mobile){
   print('got connection WIFI');
   Firebase.initializeApp();
  //       await initServices();
  //       Phoenix.rebirth(context);
        
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  // var useremail = prefs.get('email');
  // if (useremail != null) {
  //   var userpass = prefs.get('pass');
  //   Get.find<AuthController>().verifylogin(useremail, userpass);
  // }

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

        Future.delayed(Duration(seconds: 1),(){
          runApp(
    Phoenix(
      child: GetMaterialApp(
        // title: Get.find<SettingsService>().setting.value.appName,
    
        initialRoute: ini,
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
    ),
  );
Navigator.pushReplacementNamed(context, AppPages.INITIAL);
        });
        }
        else if(_connectionStatus==ConnectivityResult.none){
        print('no connection ');}
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (_connectionStatus==ConnectivityResult.none)?Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left:16.0),
              child: Image.asset("assets/icon/wifi.png",
              width: MediaQuery.of(context).size.width*0.5,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            Text("No Internet Connection",
            style: TextStyle(
              fontSize: 18
            ),
            ),
          ],
        ),
      ):Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: MediaQuery.of(context).size.height*0.01,),
            Text("Connection restored please wait",
            style: TextStyle(
              fontSize: 18
            ),
            ),
          ],
        ),
      ),
    );

    // TODO: implement build
    throw UnimplementedError();
  }
}