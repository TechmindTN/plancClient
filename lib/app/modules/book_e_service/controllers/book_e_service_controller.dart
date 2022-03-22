import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/e_service_model.dart';
import 'package:home_services/app/their_models/task_model.dart';

import '../../../services/auth_service.dart';

class BookEServiceController extends GetxController {
  final scheduled = false.obs;
  final Rx<Task> task = Task().obs;

  get currentAddress => Get.find<AuthService>().address.value;

  @override
  void onInit() {
    this.task.value = Task(
      dateTime: DateTime.now(),
      address: Get.find<AuthService>().address.value,
      eService: (Get.arguments as EService),
      // user: Get.find<AuthService>().user.value,
    );
    super.onInit();
  }

  void toggleScheduled(value) {
    scheduled.value = value;
  }

  TextStyle getTextTheme(bool selected) {
    if (selected) {
      return Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor));
    }
    return Get.textTheme.bodyText2;
  }

  Color getColor(bool selected) {
    if (selected) {
      return Get.theme.accentColor;
    }
    return null;
  }

  Future<Null> showMyDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: task.value.dateTime.add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2101),
      locale: Get.locale,
      builder: (BuildContext context, Widget child) {
        return child.paddingAll(10);
      },
    );
    if (picked != null) {
      task.update((val) {
        val.dateTime = DateTime(picked.year, picked.month, picked.day, val.dateTime.hour, val.dateTime.minute);
        ;
      });
    }
  }

  Future<Null> showMyTimePicker(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(task.value.dateTime),
      builder: (BuildContext context, Widget child) {
        return child.paddingAll(10);
      },
    );
    //print(picked);
    if (picked != null) {
      task.update((val) {
        val.dateTime = DateTime(task.value.dateTime.year, task.value.dateTime.month, task.value.dateTime.day).add(Duration(minutes: picked.minute + picked.hour * 60));
      });
    }
  }
}
