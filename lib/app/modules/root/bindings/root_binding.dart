import 'package:get/get.dart';

import '../../account/controllers/account_controller.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../e_service/controllers/e_service_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../search/controllers/search_controller.dart';
import '../../tasks/controllers/tasks_controller.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(
      () => RootController(),
    );
    Get.lazyPut<TasksController>(
      () => TasksController(),
    );
    Get.lazyPut<MessagesController>(
      () => MessagesController(),
    );
    Get.lazyPut<AccountController>(
      () => AccountController(),
    );
    Get.put<EServiceController>(EServiceController(), permanent: true);
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.lazyPut<SearchController>(
      () => SearchController(),
    );
  }
}
