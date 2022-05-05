import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/notifications_button_widget.dart';
import '../../../models/Bill.dart';
import '../controllers/tasks_controller.dart';
import '../widgets/bill_widget.dart';
import '../widgets/tasks_carousel_widget.dart';
import '../widgets/tasks_list_widget.dart';

class BillView extends GetView<TasksController> {
  Bill bill = Get.arguments as Bill;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bill".tr,
          style: Get.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Get.theme.hintColor),
          onPressed: () => {Scaffold.of(context).openDrawer()},
        ),
        actions: [NotificationsButtonWidget()],
      ),
      body: BillWidget(
        bill: bill,
      ),
    );
  }
}
