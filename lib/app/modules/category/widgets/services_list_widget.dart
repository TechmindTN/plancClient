import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/models/Category.dart';

import '../../../global_widgets/circular_loading_widget.dart';
import '../../../models/Provider.dart';
// import '../../../their_models/category_model.dart';
import '../../e_service/controllers/e_service_controller.dart';
import '../../e_service/views/e_service_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/widgets/recWidget.dart';
import '../controllers/category_controller.dart';
import 'services_list_item_widget.dart';

class ServicesListWidget extends GetView<CategoryController> {
  ServicesListWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.services.isEmpty) {
        return CircularLoadingWidget(height: 300);
      } else {
        print("many cats " +
            Get.find<HomeController>().categories.length.toString());
        int index = 0;
        List<ServiceProvider> filtered = [];

        Get.find<HomeController>().categories.forEach((element) {
          bool a;
          controller.services.forEach((element2) {
            element2.categories.forEach((value) {
              if (controller.category.value.name == value.name) {
                filtered.add(element2);
              }
            });
          });

          index++;
        });

        return GetBuilder<CategoryController>(
            init: CategoryController(),
            builder: (value) => ListView.builder(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                primary: false,
                shrinkWrap: true,
                itemCount: filtered.length,
                itemBuilder: ((_, index) {
                  // return Obx(() {
                  var _service = filtered.elementAt(index);
                  if (filtered.length > 0) {
                    Map<String, dynamic> data = _service.tofire();
                    data['id'] = _service.id;
                    return Padding(
                      padding: const EdgeInsets.only(
                          right: 48.0, left: 48, bottom: 24),
                      child: RecWidget(data, Get.find<EServiceController>(),
                          id: _service.id),
                    );
                  } else {
                    return Center(child: Text("Pas de data"));
                  }
                  // });
                })));
      }
    });
  }
}
