import 'package:get/get.dart';
import '../../../models/Intervention.dart';

class FeedbackController extends GetxController {
  final task = Intervention().obs;

  @override
  void onInit() {
    task.value = Get.arguments as Intervention;
    super.onInit();
  }
}
