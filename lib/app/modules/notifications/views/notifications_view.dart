import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/circular_loading_widget.dart';
import '../controllers/notifications_controller.dart';
import '../widgets/notification_item_widget.dart';

class NotificationsView extends GetView<NotificationsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications".tr,
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
          print('length notifs' + controller.notifications.length.toString());
          await controller.refreshNotifications(showMessage: true);
        },
        child: ListView(
          primary: true,
          children: <Widget>[
            Text("Incoming Notifications".tr, style: Get.textTheme.headline5)
                .paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
            Text("Swipe item left to delete it.".tr,
                    style: Get.textTheme.caption)
                .paddingSymmetric(horizontal: 22, vertical: 5),
            notificationsList(),
          ],
        ),
      ),
    );
  }

  Widget notificationsList() {
    return GetBuilder<NotificationsController>(
        init: NotificationsController(),
        builder: (val) {
          if (controller.notifications.isEmpty) {
            return CircularLoadingWidget(
              height: 300,
              onCompleteText: "Notification List is Empty".tr,
            );
          } else {
            var _notifications = controller.notifications;
            return ListView.separated(
                itemCount: _notifications.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 7);
                },
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  // Message _message = _messages.elementAt(index);
                  // printInfo(info: _message.toMap().toString());
                  return NotificationItemWidget(
                    notification: val.notifications.value.elementAt(index),
                    onDismissed: (conversation) {
                      val.notifications.value.removeAt(index);
                    },
                  );
                });
          }
        });
  }
}
