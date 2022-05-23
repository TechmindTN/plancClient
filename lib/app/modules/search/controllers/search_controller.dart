import 'package:get/get.dart';
import 'package:home_services/app/models/Category.dart';
import 'package:home_services/app/their_models/e_service_model.dart';

import '../../../../common/ui.dart';

import '../../../models/Provider.dart';
import '../../../repositories/category_repository.dart';
import '../../../repositories/e_service_repository.dart';
import '../../e_service/controllers/e_service_controller.dart';
import '../../home/controllers/home_controller.dart';

class SearchController extends GetxController {
  final heroTag = "".obs;
  final categories = <Category>[].obs;
  var services;
  final eServices = <ServiceProvider>[].obs;
  EServiceRepository _eServiceRepository;
  CategoryRepository _categoryRepository;

  SearchController() {
    _eServiceRepository = new EServiceRepository();
    _categoryRepository = new CategoryRepository();
  }

  @override
  void onInit() async {
    eServices.value = await Get.find<EServiceController>()
        .getProviders()
        .then((value) => services = value);

    await refreshSearch();
    super.onInit();
  }

  @override
  void onReady() {
    heroTag.value = Get.arguments as String;
    super.onReady();
  }

  Future refreshSearch({bool showMessage}) async {
    await searchEServices();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of services refreshed successfully".tr));
    }
  }

  Future searchEServices({String keywords}) async {
    try {
      eServices.value = services;

      if (keywords != null && keywords.isNotEmpty) {
        eServices.value = eServices.where((ServiceProvider _service) {
          return _service.name.toLowerCase().contains(keywords.toLowerCase());
        }).toList();
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  // Future getCategories() async {
  //   try {
  //     _categoryRepository.getAll().then((value) {
  //       categories.clear();
  //       return value;
  //     }).then((value) {
  //       categories.value = value;
  //     });
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }
}
