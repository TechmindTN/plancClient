import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
import '../controllers/categories_controller.dart';
import '../controllers/category_controller.dart';

class CategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.lazyPut<CategoryController>(
      () => CategoryController(),
    );
    Get.lazyPut<CategoriesController>(
      () => CategoriesController(),
    );
  }
}
