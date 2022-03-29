import 'package:get/get.dart';
import 'package:home_services/app/modules/e_service/controllers/e_service_controller.dart';
import 'package:home_services/app/their_models/address_model.dart';
import 'package:home_services/app/their_models/e_service_model.dart';
import 'package:home_services/app/their_models/slide_model.dart';

import '../../../../common/ui.dart';
import '../../../Network/CategoryNetwork.dart';

import '../../../Network/UserNetwork.dart';
import '../../../models/Provider.dart';
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

class HomeController extends GetxController {
  CategoryNetwork _categoryNetwork = CategoryNetwork();
  UserRepository _userRepo;
  SliderRepository _sliderRepo;
  CategoryRepository _categoryRepository;
  EServiceRepository _eServiceRepository;
  EServiceController eServiceController = Get.find<EServiceController>();

  final addresses = <Address>[].obs;
  final slider = <Slide>[].obs;
  final currentSlide = 0.obs;
  var prov = <ServiceProvider>[];

  final eServices = <EService>[].obs;
  final categories = <Category>[].obs;
  final featured = <Category>[].obs;
  HomeController() {
    _userRepo = new UserRepository();
    _sliderRepo = new SliderRepository();
    _categoryRepository = new CategoryRepository();
    _eServiceRepository = new EServiceRepository();
  }

  @override
  Future<void> onInit() async {
    Get.put<EServiceController>(EServiceController());

    prov = await eServiceController.getProviders();
    Get.put<AuthController>(AuthController());

    await refreshHome();
    super.onInit();
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
