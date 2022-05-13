import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/task_model.dart';

import '../../../models/Intervention.dart';

class FeedbackController extends GetxController {
  final task = Intervention().obs;

  @override
  void onInit() {
    task.value = Get.arguments as Intervention;
    super.onInit();
  }
}
