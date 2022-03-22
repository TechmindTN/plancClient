import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../global_widgets/block_button_widget.dart';
import '../../../their_models/task_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/book_e_service_controller.dart';

class BookEServiceView extends GetView<BookEServiceController> {
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
        bottomNavigationBar: buildBlockButtonWidget(controller.task.value),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Your Address".tr, style: Get.textTheme.caption),
                  SizedBox(height: 8),
                  Text(controller.currentAddress.address,
                      style: Get.textTheme.bodyText2),
                ],
              ),
            ),
            SizedBox(height: 20),
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
                                "When would you like us to come to your address?",
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
                                "At What's time you are free in your address?",
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
                          '${DateFormat.yMMMMEEEEd().format(controller.task.value.dateTime)}',
                          style: Get.textTheme.headline5),
                      Text(
                          'At ${DateFormat('HH:mm').format(controller.task.value.dateTime)}',
                          style: Get.textTheme.headline3),
                    ],
                  );
                }),
              );
            })
          ],
        ));
  }

  Widget buildBlockButtonWidget(Task _task) {
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
      child: BlockButtonWidget(
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
            Get.toNamed(Routes.CHECKOUT, arguments: _task);
          }).paddingOnly(right: 20, left: 20),
    );
  }
}
