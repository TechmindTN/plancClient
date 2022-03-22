import 'package:get/get.dart';
import 'package:home_services/app/their_models/task_model.dart';


class RatingController extends GetxController {
  final task = Task().obs;

  @override
  void onInit() {
    task.value = Get.arguments as Task;
    super.onInit();
  }
}
