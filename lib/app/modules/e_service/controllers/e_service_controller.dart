import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/e_service_model.dart';
import 'package:home_services/app/their_models/review_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../common/ui.dart';

import '../../../Network/BranchNetwork.dart';
import '../../../Network/ServiceProviderNetwork.dart';
import '../../../Network/UserNetwork.dart';
import '../../../models/Client.dart';
import '../../../models/Provider.dart';
import '../../../repositories/e_service_repository.dart';

class EServiceController extends GetxController {
  ServiceProviderNetwork providerServices = ServiceProviderNetwork();
  List<ServiceProvider> providers = <ServiceProvider>[];
  final eService = EService().obs;
  final Rx<ServiceProvider> serviceProvider = ServiceProvider().obs;
  final reviews = <Review>[].obs;
  final currentSlide = 0.obs;
  EServiceRepository _eServiceRepository;
  BranchNetwork branchServices = BranchNetwork();
  UserNetwork userServices = UserNetwork();
  Client c;
  Review r;
  EServiceController() {
    _eServiceRepository = new EServiceRepository();
  }
  verifyChat(list) async {
    QuerySnapshot snaps = await FirebaseFirestore.instance
        .collection("Chat")
        .where('users', isEqualTo: list)
        .limit(1)
        .get();

    if (snaps.docs.length == 0) {
      return null;
    } else {
      return snaps.docs[0].id;
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  Future<List<ServiceProvider>> getProviders() async {
    // // ServiceProvider serviceProviders
    // List<ServiceProvider> serviceProviders=await providerServices.getProvidersList();
    // serviceProviders.forEach((element) {
    //   Rx<ServiceProvider> rxProvider;
    //   rxProvider.value=element;
    //   // providers.add(rxProvider);
    // });
    List<ServiceProvider> sp = await providerServices.getProvidersList();
    print('spl ' + sp.length.toString());
    return sp;
  }

  @override
  void onInit() async {
    eService.value = Get.arguments as EService;
    super.onInit();
  }

  // @override
  // void onReady() async {
  //   await refreshEService();
  //   super.onReady();
  // }

  Future refreshEService({bool showMessage = false}) async {
    await getEService();
    await getReviews();
    if (showMessage) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "page refreshed successfully".tr));
    }
  }

  getThisProvider(ServiceProvider provider, userId) async {
    // provider.branches=await branchServices.getBranchListByProvider(provider.id);
//    Future.delayed(Duration(seconds: 3),(){
// // print("add "+provider.branches.first.address);
//    }) ;
    provider.user = await userServices.getUserById(userId);
    // serviceProvider.value=provider;
  }

  Future getEService() async {
    try {
      eService.value = await _eServiceRepository.get(eService.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getReviews() async {
    try {
      reviews.value = await _eServiceRepository.getReviews(eService.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
