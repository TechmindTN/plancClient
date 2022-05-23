import 'package:get/get.dart';

import '../../../global_widgets/tab_bar_widget.dart' show TabBarController;
import '../controllers/language_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/theme_mode_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabBarController>(
      () => TabBarController(),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
    Get.lazyPut<ThemeModeController>(
      () => ThemeModeController(),
    );
    Get.lazyPut<LanguageController>(
      () => LanguageController(),
    );
  }
}
