import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:home_services/app/modules/e_service/controllers/e_service_controller.dart';
import 'package:home_services/app/their_models/address_model.dart';
import 'package:home_services/app/their_models/e_service_model.dart';
import 'package:home_services/app/their_models/slide_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/ui.dart';
import '../../../../main.dart';
import '../../../Network/CategoryNetwork.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../Network/InterventionNetwork.dart';
import '../../../Network/UserNetwork.dart';
import '../../../models/Chat.dart';
import '../../../models/Client.dart';
import '../../../models/Intervention.dart';
import '../../../models/Notification.dart' as model;
import '../../../models/Provider.dart';
import '../../../models/User.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../repositories/slider_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/auth_service.dart';
import '../../../models/Category.dart';
import '../../account/controllers/account_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../category/controllers/category_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../profile/views/profile_view.dart';
import '../../tasks/controllers/tasks_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  CategoryNetwork _categoryNetwork = CategoryNetwork();
  UserNetwork _userNetwork = UserNetwork();
  UserRepository _userRepo;
  SliderRepository _sliderRepo;
  CategoryRepository _categoryRepository;
  EServiceRepository _eServiceRepository;
  EServiceController eServiceController = Get.find<EServiceController>();
  InterventionNetwork _interventionNetwork = InterventionNetwork();
  CollectionReference providersRef =
      FirebaseFirestore.instance.collection('Provider');
  final addresses = <Address>[].obs;
  RxString presentAddress = ''.obs;
  Position presentposition;
  List providers_snapshots = [];
  final slider = <Slide>[].obs;
  final currentSlide = 0.obs;
  var prov = <ServiceProvider>[];
  var interventions = <Intervention>[].obs;
  final eServices = <EService>[].obs;
  final categories = <Category>[].obs;
  final pro = <User>[].obs;
  final entreprise = <User>[].obs;
  final featured = <Category>[].obs;
  var client = Client().obs;
  final List list = [];
  final List list1 = [];
  List allproviders = [];
  RxSet<Marker> providers_markers = Set<Marker>().obs;
  SharedPreferences prefs;
  RxList<Asset> images = <Asset>[].obs;
  List cards = [];
  RxList notifs = [].obs;
  static int i = 1;
  HomeController() {
    _userRepo = new UserRepository();
    _sliderRepo = new SliderRepository();
    _categoryRepository = new CategoryRepository();
    _eServiceRepository = new EServiceRepository();
  }

  @override
  Future<void> onInit() async {
    Get.put<AuthController>(AuthController(), permanent: true);
    await Permission.location.status.then((val) {
      if (val.isDenied) {
        Permission.locationWhenInUse.request().then((value) {
          if (value.isGranted) {
            getPresentAddress();
          }
        });
      } else {
        if (val.isGranted) {
          getPresentAddress();
        }
      }
    });
    // _getAddressFromLatLng();

    pro.value = await _userNetwork.getUsersByRole('Professionel');
    entreprise.value = await _userNetwork.getUsersByRole('Entreprise');

    Get.put<EServiceController>(EServiceController());
    if (Get.find<AuthController>().currentProfile.first_name != null) {
      client.value = Get.find<AuthController>().currentProfile;
      interventions.clear();
      interventions.value =
          await _interventionNetwork.getInterventionsList(client.value.id);
      notifs.clear();
      await _userNetwork
          .getNotifications(Get.find<AuthController>().currentuser.id)
          .then((value) {
        notifs.value = value;
      });
    }

    //   var index = 0;
    //   while (index <= interventions.length) {
    //     print('eee' + interventions.first.address);
    //     if (interventions.value[index]?.client?.id != client.value.id) {
    //       interventions.removeAt(index);
    //     } else {
    //       index++;
    //     }
    //   }
    // } else {
    //   print("there is not !");
    // }
    prov = await eServiceController.getProviders();

    await refreshHome();

    FirebaseMessaging.instance.getInitialMessage();
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        if (i % 2 != 0) {
          i++;
          var obj = {
            "read_by_user": false,
            "description": notification.body,
            "creation_date": Timestamp.now(),
            "title": notification.title
          };
          _userNetwork.RegisterNotification(
              Get.find<AuthController>().currentuser.id, obj);
          model.Notification nt = model.Notification.fromFire(obj);
          notifs.add(nt);
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  icon: "@mipmap/ic_launcher_new",
                  // other properties...
                ),
              ));
        } else {
          i++;
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // RemoteNotification notification = message.notification;
      // var obj = {
      //   "read_by_user": false,
      //   "description": notification.body,
      //   " creation_date": Timestamp.now(),
      //   "title": notification.title
      // };
      // model.Notification nt = model.Notification.fromFire(obj);
      // notifs.add(nt);
      if (message.data != null) {
        Get.toNamed(message.data['route']);
      }
    });

    super.onInit();
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    // If you're going to use other Firebase services in the background, such as Firestore,
    // make sure you call `initializeApp` before using other Firebase services.
    print('Handling a background message ${message.messageId}');
  }

  Future<void> refreshIntervention() async {
    interventions.value.clear();
    interventions.value =
        await _interventionNetwork.getInterventionsList(client.value.id);
  }

  getPresentAddress() {
    print('searching');
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      print('possssss' + position.latitude.toString());
      presentposition = position;
      _getAddressFromLatLng(position);
      update();
    }).catchError((e) {
      print('bahaaaa error' + e.toString());
    });
  }

  _getAddressFromLatLng(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];
    print('place ' + place.toJson().toString());
    presentAddress.value =
        "${place.street}, ${place.subAdministrativeArea}, ${place.locality}, ${place.country}";
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];

    resultList = await MultiImagePicker.pickImages(
      maxImages: 5,
      enableCamera: false,
      selectedAssets: images.value,
      cupertinoOptions: CupertinoOptions(
        takePhotoIcon: "chat",
        doneButtonTitle: "Fatto",
      ),
      materialOptions: MaterialOptions(
        actionBarColor: "#abcdef",
        actionBarTitle: "Example App",
        allViewTitle: "All Photos",
        useDetailsView: false,
        selectCircleStrokeColor: "#000000",
      ),
    );

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    images.value = resultList;
  }

  Future refreshHome({bool showMessage = false}) async {
    await getSlider();
    // await getAddresses();
    await getCategories();
    // await getFeatured();
    update();

    if (showMessage) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Home page refreshed successfully".tr));
    }
  }

  Address get currentAddress {
    return Get.find<AuthService>().address.value;
  }

  Future getAddresses() async {
    try {
      addresses.value = await _userRepo.getAddresses();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getSlider() async {
    try {
      slider.value = await _sliderRepo.getHomeSlider();
      update();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getCategories() async {
    try {
      categories.value = await _categoryNetwork.getCategoryList();
      // categories.value = await _categoryRepository.getAll();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFeatured() async {
    // TODO Integrate get featured categories
    try {
      // featured.value = await _categoryRepository.getFeatured();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getRecommendedEServices() async {
    try {
      eServices.value = await _eServiceRepository.getRecommended();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
