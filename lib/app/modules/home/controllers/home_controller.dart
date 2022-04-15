import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/modules/e_service/controllers/e_service_controller.dart';
import 'package:home_services/app/their_models/address_model.dart';
import 'package:home_services/app/their_models/e_service_model.dart';
import 'package:home_services/app/their_models/slide_model.dart';

import '../../../../common/ui.dart';
import '../../../Network/CategoryNetwork.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import '../../../Network/InterventionNetwork.dart';
import '../../../Network/UserNetwork.dart';
import '../../../models/Client.dart';
import '../../../models/Intervention.dart';
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
  RxList<Asset> images = <Asset>[].obs;
  HomeController() {
    _userRepo = new UserRepository();
    _sliderRepo = new SliderRepository();
    _categoryRepository = new CategoryRepository();
    _eServiceRepository = new EServiceRepository();
  }

  @override
  Future<void> onInit() async {
    pro.value = await _userNetwork.getUsersByRole('Professionel');
    entreprise.value = await _userNetwork.getUsersByRole('Entreprise');

    Get.put<EServiceController>(EServiceController());
    if (Get.find<AuthController>().currentProfile.first_name != null) {
      print('there is client connected !');
      client.value = Get.find<AuthController>().currentProfile;
      interventions.value.clear();
      interventions.value =
          await _interventionNetwork.getInterventionsList(client.value.id);
      print('bbbbbbbboking' + interventions.string);
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
    super.onInit();
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
    await getAddresses();
    await getCategories();
    await getFeatured();
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
