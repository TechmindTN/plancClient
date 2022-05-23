import 'dart:developer';

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
  CategoryNetwork _categoryNetwork = CategoryNetwork();
  ServiceProviderNetwork _serviceProviderNetwork = ServiceProviderNetwork();
  final selected = Rx<CategoryFilter>();
  final eServices = <EService>[].obs;
  final page = 1.obs;
  RxList<ServiceProvider> services = Get.find<HomeController>().prov.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  EServiceRepository _eServiceRepository;
  ScrollController scrollController = ScrollController();
  String categ_id = '';
  DocumentReference ref;
  RxList<ServiceProvider> allservices = Get.find<HomeController>().prov.obs;
  CategoryController() {
    _eServiceRepository = new EServiceRepository();
  }

  @override
  Future<void> onInit() async {
    services = allservices;
    // Get.find<HomeController>().allproviders.forEach((element) async {
    //   ServiceProvider _service = ServiceProvider.fromFire(element);
    //   List<Category> catlist = [];
    //   element.data()['categories'].forEach((e) async {
    //     var _cat = await _categoryNetwork.getCategoryById(e.id);
    //     catlist.add(_cat);
    //   });
    //   _service.categories = catlist;
    //   services.add(_service);
    // });
    category.value = Get.arguments as Category;
    print('lserv' + services.length.toString());
    List<ServiceProvider> list = [];
    for (var i = 0; i < services.length; i++) {
      // services.value[i].categories.forEach((element) {
      //   print('serviiiiiiiiiiiiiiiiice   ' +
      //       services.value[i].name +
      //       '   categs id   ' +
      //       element.id);
      // });
      print('length' + services.length.toString());
      print('//// testing ///// ' + services.value[i].name);
      var ind = services.value[i].categories
          .indexWhere((element) => element.id == category.value.id);
      if (ind != -1) {
        list.add(services.value[i]);
      }
    }
    services.value = list;
    // services.value =
    //     await _serviceProviderNetwork.getProvidersByCategory(services, dr);

    selected.value = CategoryFilter.ALL;
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
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

  sortRating() {
    services.sort((srv1, srv2) => srv2.rate.compareTo(srv1.rate));
  }

  sortAll() {
    services.shuffle();
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
