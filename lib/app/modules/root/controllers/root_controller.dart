/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/User.dart';
import '../../../routes/app_pages.dart';
import '../../account/views/account_view.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../home/views/home2_view.dart';
import '../../messages/views/messages_view.dart';
import '../../tasks/views/tasks_view.dart';

class RootController extends GetxController {
  final currentIndex = 0.obs;

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments is int) {
      changePageInRoot(Get.arguments as int);
    } else {
      changePageInRoot(0);
    }
    super.onInit();
  }

  List<Widget> pages = [
    Home2View(),
    TasksView(),
    MessagesView(),
    AccountView(),
  ];

  Widget get currentPage => pages[currentIndex.value];

  /**
   * change page in route
   * */
  void changePageInRoot(int _index) {
    if (_index != 0) {
      if (Get.find<AuthController>().currentuser.email == null) {
        Get.showSnackbar(
            Ui.ErrorSnackBar(message: 'You must login before !'.tr));
        return null;
      } else {
        currentIndex.value = _index;
      }
    } else {
      currentIndex.value = _index;
    }
  }

  void changePageOutRoot(int _index) {
    currentIndex.value = _index;
    Get.offNamedUntil(Routes.ROOT, (Route route) {
      if (route.settings.name == Routes.ROOT) {
        return true;
      }
      return false;
    }, arguments: _index);
  }

  void changePage(int _index) {
    if (Get.currentRoute == Routes.ROOT) {
      changePageInRoot(_index);
    } else {
      changePageOutRoot(_index);
    }
  }
}
