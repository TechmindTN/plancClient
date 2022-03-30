import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/models/Category.dart';
import 'package:home_services/app/their_models/e_service_model.dart';

import '../../../../common/ui.dart';

import '../../../Network/CategoryNetwork.dart';
import '../../../Network/ServiceProviderNetwork.dart';
import '../../../models/Provider.dart';
import '../../../repositories/e_service_repository.dart';
import '../../home/controllers/home_controller.dart';

enum CategoryFilter { ALL, AVAILABILITY, RATING, FEATURED, POPULAR }

class CategoryController extends GetxController {
  final category = new Category().obs;
  final selected = Rx<CategoryFilter>();
  final eServices = <EService>[].obs;
  final page = 1.obs;
   RxList<ServiceProvider> services = <ServiceProvider>[].obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  EServiceRepository _eServiceRepository;
  ScrollController scrollController = ScrollController();
  String categ_id = '';
  DocumentReference ref;

  CategoryController() {
    _eServiceRepository = new EServiceRepository();
  }

  @override
  Future<void> onInit() async {
    Get.put<HomeController>(HomeController());
    services.value=Get.find<HomeController>().prov;
    category.value = Get.arguments as Category;
    print('cattt' + category.value.name);

    selected.value = CategoryFilter.ALL;
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isDone.value) {
        loadMoreEServicesOfCategory(filter: selected.value);
      }
    });
    await refreshEServices();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  Future refreshEServices({bool showMessage}) async {
    await getEServicesOfCategory(filter: selected.value);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of services refreshed successfully".tr));
    }
  }

  bool isSelected(CategoryFilter filter) => selected == filter;

  void toggleSelected(CategoryFilter filter) {
    if (isSelected(filter)) {
      selected.value = CategoryFilter.ALL;
    } else {
      selected.value = filter;
    }
  }

  Future getEServicesOfCategory({CategoryFilter filter}) async {
    try {
      eServices.value = [];
      switch (filter) {
        case CategoryFilter.ALL:
          this.page.value = 1;
          eServices.value =
              await _eServiceRepository.getAllWithPagination(page: 1);
          break;
        case CategoryFilter.FEATURED:
          eServices.value = await _eServiceRepository.getFeatured();
          break;
        case CategoryFilter.POPULAR:
          eServices.value = await _eServiceRepository.getPopular();
          break;
        case CategoryFilter.RATING:
          eServices.value = await _eServiceRepository.getMostRated();
          break;
        case CategoryFilter.AVAILABILITY:
          eServices.value = await _eServiceRepository.getAvailable();
          break;
        default:
          eServices.value = await _eServiceRepository.getAll();
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future loadMoreEServicesOfCategory({CategoryFilter filter}) async {
    try {
      isLoading.value = true;
      switch (filter) {
        case CategoryFilter.ALL:
          this.page.value++;
          var _eServices = await _eServiceRepository.getAllWithPagination(
              page: this.page.value);
          if (_eServices.isNotEmpty) {
            this.eServices.value += _eServices;
          } else {
            this.isDone.value = true;
          }
          break;
        case CategoryFilter.FEATURED:
          eServices.value = await _eServiceRepository.getFeatured();
          break;
        case CategoryFilter.POPULAR:
          eServices.value = await _eServiceRepository.getPopular();
          break;
        case CategoryFilter.RATING:
          eServices.value = await _eServiceRepository.getMostRated();
          break;
        case CategoryFilter.AVAILABILITY:
          eServices.value = await _eServiceRepository.getAvailable();
          break;
        default:
          eServices.value = await _eServiceRepository.getAll();
      }
    } catch (e) {
      this.isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
