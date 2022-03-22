import 'package:get/get.dart';
import 'package:home_services/app/their_models/faq_category_model.dart';

import '../../../../common/ui.dart';
import '../../../repositories/faq_repository.dart';

class HelpController extends GetxController {
  FaqRepository _faqRepository;
  final faqs = <FaqCategory>[].obs;

  HelpController() {
    _faqRepository = new FaqRepository();
  }

  @override
  Future<void> onInit() async {
    await refreshFaqs();
    super.onInit();
  }

  Future refreshFaqs({bool showMessage}) async {
    await getFaqs();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of faqs refreshed successfully".tr));
    }
  }

  Future getFaqs() async {
    try {
      faqs.value = await _faqRepository.getCategoriesWithFaqs();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
