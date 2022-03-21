import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/search_bar_widget.dart';
import '../../home/widgets/address_widget.dart';
import '../controllers/category_controller.dart';
import '../widgets/services_list_widget.dart';

class CategoryView extends GetView<CategoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            controller.category.value.name,
            style: Get.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => {Get.back()},
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            controller.refreshEServices(showMessage: true);
          },
          child: ListView(
            primary: true,
            children: [
              AddressWidget(),
              SearchBarWidget().paddingSymmetric(horizontal: 20, vertical: 10),
              Container(
                height: 90,
                child: ListView(
                    primary: false,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: List.generate(CategoryFilter.values.length, (index) {
                      var _filter = CategoryFilter.values.elementAt(index);
                      return Obx(() {
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(start: 20),
                          child: RawChip(
                            elevation: 0,
                            label: Text(_filter.toString().tr),
                            labelStyle: controller.isSelected(_filter) ? Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)) : Get.textTheme.bodyText2,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                            backgroundColor: Theme.of(context).focusColor.withOpacity(0.1),
                            selectedColor: Theme.of(context).accentColor,
                            selected: controller.isSelected(_filter),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            showCheckmark: true,
                            checkmarkColor: Get.theme.primaryColor,
                            onSelected: (bool value) {
                              controller.toggleSelected(_filter);
                              controller.getEServicesOfCategory(filter: controller.selected.value);
                            },
                          ),
                        );
                      });
                    })),
              ),
              ServicesListWidget()
            ],
          ),
        ));
  }
}
