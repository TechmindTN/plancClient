import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../global_widgets/block_button_widget.dart';
import '../../../global_widgets/text_field_widget.dart';
import '../../../their_models/task_model.dart';
import '../../../routes/app_pages.dart';
import '../../auth/bindings/auth_binding.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/book_e_service_controller.dart';

class BookEServiceView extends GetView<BookEServiceController> {
  AuthController _authController = Get.find<AuthController>();
  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Book the Service".tr,
            style: context.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Get.back(),
          ),
          elevation: 0,
        ),
        bottomNavigationBar: buildBlockButtonWidget(),
        body: ListView(
          children: [
            Form(
              key: formGlobalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldWidget(
                    labelText: "Title".tr,
                    iconData: Icons.title,
                    keyboardType: TextInputType.text,
                    isLast: false,
                    isFirst: true,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'field is empty'.tr;
                      }
                      controller.title = text;
                      return null;
                    },
                  ),
                  TextFieldWidget(
                    labelText: "description".tr,
                    iconData: Icons.description,
                    keyboardType: TextInputType.text,
                    isLast: false,
                    isFirst: false,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'field is empty'.tr;
                      }
                      controller.description = text;
                      return null;
                    },
                  ),
                  TextFieldWidget(
                    labelText: "Your Address".tr,
                    initialValue: _authController.currentProfile.home_address,
                    iconData: Icons.home,
                    keyboardType: TextInputType.streetAddress,
                    isLast: false,
                    isFirst: false,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'field is empty'.tr;
                      }
                      controller.address = text;
                      return null;
                    },
                  ),
                  Obx(
                    () => Container(
                        padding: EdgeInsets.only(
                            top: 20, bottom: 14, left: 20, right: 20),
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 0, bottom: 10),
                        decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Get.theme.focusColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5)),
                            ],
                            border: Border.all(
                                color: Get.theme.focusColor.withOpacity(0.05))),
                        child: Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: controller.selectedCategory.value,
                              icon: const Icon(Icons.arrow_downward),
                              style:
                                  const TextStyle(color: Colors.orangeAccent),
                              underline: Container(
                                height: 2,
                                color: Colors.orangeAccent,
                              ),
                              onChanged: (String newValue) {
                                controller.selectedCategory.value = newValue;
                                controller.update();
                                print(controller.selectedCategory.value);
                              },
                              items: controller.catnames
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        )),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Column(children: [
              Text(
                "Media".tr,
                style: context.textTheme.headline6,
              ),
              IconButton(
                  onPressed: () {
                    controller.changeImage();
                    controller.update();
                  },
                  icon: Icon(Icons.add_a_photo_outlined)),
              SizedBox(
                height: 15,
              ),
              GetBuilder<BookEServiceController>(
                  init: BookEServiceController(),
                  builder: (ctrl) => Container(
                      height: 200,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.imlist?.value.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                constraints: BoxConstraints(
                                    maxHeight: 150, maxWidth: 150),
                                child: controller.imlist?.value[index]);
                          }))),
            ]),
            Obx(() {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: Ui.getBoxDecoration(
                    color: controller.getColor(!controller.scheduled.value)),
                child: Theme(
                  data: ThemeData(
                    toggleableActiveColor: Get.theme.primaryColor,
                  ),
                  child: RadioListTile(
                    value: false,
                    groupValue: controller.scheduled.value,
                    onChanged: (value) {
                      controller.toggleScheduled(value);
                    },
                    title: Text("As Soon as Possible".tr,
                            style: controller
                                .getTextTheme(!controller.scheduled.value))
                        .paddingSymmetric(vertical: 20),
                  ),
                ),
              );
            }),
            Obx(() {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: Ui.getBoxDecoration(
                    color: controller.getColor(controller.scheduled.value)),
                child: Theme(
                  data: ThemeData(
                    toggleableActiveColor: Get.theme.primaryColor,
                  ),
                  child: RadioListTile(
                    value: true,
                    groupValue: controller.scheduled.value,
                    onChanged: (value) {
                      controller.toggleScheduled(value);
                    },
                    title: Text("Schedule an Order".tr,
                            style: controller
                                .getTextTheme(controller.scheduled.value))
                        .paddingSymmetric(vertical: 20),
                  ),
                ),
              );
            }),
            Obx(() {
              return AnimatedOpacity(
                opacity: controller.scheduled.value ? 1 : 0,
                duration: Duration(milliseconds: 300),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: controller.scheduled.value ? 20 : 0),
                  padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: controller.scheduled.value ? 20 : 0),
                  decoration: Ui.getBoxDecoration(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                "When would you like us to come to your address?"
                                    .tr,
                                style: Get.textTheme.bodyText1),
                          ),
                          SizedBox(width: 10),
                          MaterialButton(
                            elevation: 0,
                            onPressed: () {
                              controller.showMyDatePicker(context);
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.accentColor.withOpacity(0.2),
                            child: Text("Select a Date".tr,
                                style: Get.textTheme.subtitle1),
                          ),
                        ],
                      ),
                      Divider(thickness: 1.3, height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                "At What time you are free in your address?".tr,
                                style: Get.textTheme.bodyText1),
                          ),
                          SizedBox(width: 10),
                          MaterialButton(
                            elevation: 0,
                            onPressed: () {
                              controller.showMyTimePicker(context);
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.accentColor.withOpacity(0.2),
                            child: Text("Select a time".tr,
                                style: Get.textTheme.subtitle1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            Obx(() {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                transform: Matrix4.translationValues(
                    0, controller.scheduled.value ? 0 : -110, 0),
                child: Obx(() {
                  return Column(
                    children: [
                      Text("Requested Service on".tr)
                          .paddingSymmetric(vertical: 20),
                      Text(
                          '${controller.d.value.toDate().year}' +
                              '-' +
                              '${controller.d.value.toDate().month}' +
                              '-' +
                              '${controller.d.value.toDate().day}',
                          style: Get.textTheme.headline5),
                      Text(
                          'At'.tr +
                              ' ' +
                              '${controller.d.value.toDate().hour}' +
                              ':' +
                              '${controller.d.value.toDate().minute}',
                          style: Get.textTheme.headline3),
                    ],
                  );
                }),
              );
            }),
          ],
        ));
  }

  Widget buildBlockButtonWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Get.theme.focusColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5)),
        ],
      ),
      child: controller.service != null
          ? BlockButtonWidget(
              text: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Continue".tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headline6.merge(
                        TextStyle(color: Get.theme.primaryColor),
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: Get.theme.primaryColor, size: 20)
                ],
              ),
              color: Get.theme.accentColor,
              onPressed: () {
                if (formGlobalKey.currentState.validate()) {
                  controller.addIntervention();
                  Get.toNamed(Routes.CHECKOUT, arguments: controller.service);
                }
              }).paddingOnly(right: 20, left: 20)
          : BlockButtonWidget(
              text: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Submit".tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headline6.merge(
                        TextStyle(color: Get.theme.primaryColor),
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: Get.theme.primaryColor, size: 20)
                ],
              ),
              color: Get.theme.accentColor,
              onPressed: () async {
                if (formGlobalKey.currentState.validate()) {
                  await controller.addIntervention();
                }
              }).paddingOnly(right: 20, left: 20),
    );
  }
}
