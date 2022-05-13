import 'package:get/get.dart';
import '../../../Network/UserNetwork.dart';
import '../../../models/Notification.dart';

import '../../../../common/ui.dart';
import '../../../repositories/notification_repository.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../home/controllers/home_controller.dart';

class NotificationsController extends GetxController {
  List<Notification> notifications;
  NotificationRepository _notificationRepository;
  UserNetwork _userNetwork = UserNetwork();
  String uid;
  NotificationsController() {
    _notificationRepository = new NotificationRepository();
  }

  @override
  void onInit() async {
    notifications = <Notification>[];
    uid = Get.find<AuthController>().currentuser.id;
    if (uid != null) {
      notifications.clear();
      notifications = Get.find<HomeController>().notifs.value;
    }
    super.onInit();
  }

  Future refreshNotifications({bool showMessage}) async {
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: "List of notifications refreshed successfully".tr));
    }
  }

  Future getNotifications() async {
    try {} catch (e) {}
  }

  // Future getNotifications() async {
  //   try {
  //     notifications.value = await _notificationRepository.getAll();
  //   } catch (e) {
  //     Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
  //   }
  // }
}
