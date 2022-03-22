import 'package:get/get.dart';
import 'package:home_services/app/their_models/e_provider_model.dart';
import 'package:home_services/app/their_models/e_service_model.dart';
import 'package:home_services/app/their_models/review_model.dart';

import '../../../../common/ui.dart';

import '../../../repositories/e_provider_repository.dart';

class EProviderController extends GetxController {
  final eProvider = EProvider().obs;
  final reviews = <Review>[].obs;
  final featuredEServices = <EService>[].obs;
  final currentSlide = 0.obs;
  EProviderRepository _eProviderRepository;

  EProviderController() {
    _eProviderRepository = new EProviderRepository();
  }

  @override
  void onInit() {
    eProvider.value = Get.arguments as EProvider;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshEProvider();
    super.onReady();
  }

  Future refreshEProvider({bool showMessage = false}) async {
    await getEProvider();
    await getFeaturedEServices();
    await getReviews();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: eProvider.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getEProvider() async {
    try {
      eProvider.value = await _eProviderRepository.get(eProvider.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFeaturedEServices() async {
    try {
      featuredEServices.value = await _eProviderRepository.getFeaturedEServices(eProvider.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getReviews() async {
    try {
      reviews.value = await _eProviderRepository.getReviews(eProvider.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
