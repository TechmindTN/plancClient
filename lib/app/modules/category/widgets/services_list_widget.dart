import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/circular_loading_widget.dart';
import '../../e_service/views/e_service_view.dart';
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
        return GetBuilder<CategoryController>(
            init: CategoryController(),
            builder: (value) => ListView.builder(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                primary: false,
                shrinkWrap: true,
                itemCount: controller.services.length,
                itemBuilder: ((_, index) {
                  return Obx(() {
                    var _service = controller.services.elementAt(index);
                    if (_service.categories
                        .contains('Category/' + controller.categ_id)) {
                      return EServiceView(_service);
                    }
                  });
                })));
      }
    });
  }
}
