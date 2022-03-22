import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/models/User.dart';

import '../../../../common/ui.dart';
import '../../../services/auth_service.dart';

class ProfileController extends GetxController {
  var user = new User().obs;
  final hidePassword = true.obs;

  @override
  void onInit() {
    user.value = Get.find<AuthService>().user.value;
    super.onInit();
  }

  void saveProfileForm(GlobalKey<FormState> profileForm) {
    if (profileForm.currentState.validate()) {
      profileForm.currentState.save();
      user.refresh();
      Get.showSnackbar(Ui.SuccessSnackBar(message: "Profile saved successfully".tr));
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "There are errors in some fields please correct them!".tr));
    }
  }

  void resetProfileForm(GlobalKey<FormState> profileForm) {
    profileForm.currentState.reset();
  }
}
