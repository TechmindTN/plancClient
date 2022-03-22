import 'package:get/get.dart';
import 'package:home_services/app/their_models/notification_model.dart';

import '../../../../common/ui.dart';
import '../../../repositories/notification_repository.dart';

class NotificationsController extends GetxController {
  final notifications = <Notification>[].obs;
  NotificationRepository _notificationRepository;

  NotificationsController() {
    _notificationRepository = new NotificationRepository();
  }

  @override
  void onInit() async {
    await refreshNotifications();
    super.onInit();
  }

  Future refreshNotifications({bool showMessage}) async {
    await getNotifications();
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of notifications refreshed successfully".tr));
    }
  }

  Future getNotifications() async {
    try {
      notifications.value = await _notificationRepository.getAll();
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
