import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/e_provider_model.dart';
import 'package:home_services/app/their_models/e_service_model.dart';

import '../../../../common/ui.dart';

import '../../../repositories/e_provider_repository.dart';

enum CategoryFilter { ALL, AVAILABILITY, RATING, FEATURED, POPULAR }

class EServicesController extends GetxController {
  final eProvider = new EProvider().obs;
  final selected = Rx<CategoryFilter>();
  final eServices = <EService>[].obs;
  final page = 1.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  EProviderRepository _eProviderRepository;
  ScrollController scrollController = ScrollController();

  EServicesController() {
    _eProviderRepository = new EProviderRepository();
  }

  @override
  Future<void> onInit() async {
    eProvider.value = Get.arguments as EProvider;
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
          eServices.value = await _eProviderRepository
              .getEServicesWithPagination(eProvider.value.id, page: 1);
          break;
        case CategoryFilter.FEATURED:
          eServices.value = await _eProviderRepository
              .getFeaturedEServices(eProvider.value.id);
          break;
        case CategoryFilter.POPULAR:
          eServices.value = await _eProviderRepository
              .getPopularEServices(eProvider.value.id);
          break;
        case CategoryFilter.RATING:
          eServices.value = await _eProviderRepository
              .getMostRatedEServices(eProvider.value.id);
          break;
        case CategoryFilter.AVAILABILITY:
          eServices.value = await _eProviderRepository
              .getAvailableEServices(eProvider.value.id);
          break;
        default:
          eServices.value = [];
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
          var _eServices = await await _eProviderRepository
              .getEServicesWithPagination(eProvider.value.id,
                  page: this.page.value);
          if (_eServices.isNotEmpty) {
            this.eServices.value += _eServices;
          } else {
            this.isDone.value = true;
          }
          break;
        case CategoryFilter.FEATURED:
          eServices.value = await _eProviderRepository
              .getFeaturedEServices(eProvider.value.id);
          break;
        case CategoryFilter.POPULAR:
          eServices.value = await _eProviderRepository
              .getPopularEServices(eProvider.value.id);
          break;
        case CategoryFilter.RATING:
          eServices.value = await _eProviderRepository
              .getMostRatedEServices(eProvider.value.id);
          break;
        case CategoryFilter.AVAILABILITY:
          eServices.value = await _eProviderRepository
              .getAvailableEServices(eProvider.value.id);
          break;
        default:
          eServices.value = [];
      }
    } catch (e) {
      this.isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
