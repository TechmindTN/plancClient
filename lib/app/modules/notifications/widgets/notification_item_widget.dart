import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/Notification.dart' as model;
import '../../auth/controllers/auth_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/notifications_controller.dart';

class NotificationItemWidget extends StatelessWidget {
  NotificationItemWidget({Key key, this.notification, this.onDismissed})
      : super(key: key);
  final model.Notification notification;
  final ValueChanged<model.Notification> onDismissed;

  @override
  Widget build(BuildContext context) {
    // AuthService _authService = Get.find<AuthService>();
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: Ui.getBoxDecoration(color: Colors.red),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        onDismissed(this.notification);

        Get.find<HomeController>().notifs.remove(this.notification);
        Get.find<NotificationsController>()
            .notifications
            .remove(this.notification);
        FirebaseFirestore.instance
            .collection('User')
            .doc(Get.find<AuthController>().currentuser.id)
            .collection("Notification")
            .doc(this.notification.id)
            .delete();
        // Then show a snackbar
        Get.showSnackbar(
            Ui.SuccessSnackBar(message: "The notification is deleted".tr));
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: Ui.getBoxDecoration(color: Get.theme.primaryColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Get.theme.focusColor.withOpacity(1),
                            Get.theme.focusColor.withOpacity(0.2),
                          ])),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    size: 50,
                  ),
                ),
                Positioned(
                  right: -15,
                  bottom: -30,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  top: -55,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .scaffoldBackgroundColor
                          .withOpacity(0.15),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    this.notification.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .merge(TextStyle(fontWeight: FontWeight.w300)),
                  ),
                  Text(
                    this.notification.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .merge(TextStyle(fontWeight: FontWeight.w100)),
                  ),
                  Text(
                    DateFormat('d, MMMM y | HH:mm')
                        .format(this.notification.creation_date.toDate()),
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
