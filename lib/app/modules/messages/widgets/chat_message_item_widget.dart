import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/Chat.dart';
import '../../../models/Message.dart';
import '../controllers/messages_controller.dart';

class ChatMessageItem extends GetWidget<MessagesController> {
  final Chat chat;

  ChatMessageItem({this.chat});

  @override
  Widget build(BuildContext context) {
    return controller.user.id == this.chat.user.id
        ? getSentMessageLayout(context)
        : getReceivedMessageLayout(context);
  }

  Widget getSentMessageLayout(context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
            color: Get.theme.focusColor.withOpacity(0.2),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Flexible(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Text(this.chat.user.username,
                      style: Get.textTheme.bodyText1
                          .merge(TextStyle(fontWeight: FontWeight.w600))),
                  // new Container(
                  //   margin: const EdgeInsets.only(top: 5.0),
                  //   child: new Text(chat.conversation),
                  // ),
                ],
              ),
            ),
            new Container(
              margin: const EdgeInsets.only(left: 8.0),
              width: 42,
              height: 42,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(42)),
                child: CachedNetworkImage(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: controller.client.profile_photo,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error_outline),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getReceivedMessageLayout(context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: Get.theme.accentColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
        margin: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 10),
              width: 42,
              height: 42,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(42)),
                child: CachedNetworkImage(
                  width: double.infinity,
                  fit: BoxFit.cover,
                  imageUrl: controller.client.profile_photo,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error_outline),
                ),
              ),
            ),
            new Flexible(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(this.chat.user.username,
                      style: Get.textTheme.bodyText1.merge(TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Get.theme.primaryColor))),
                  // new Container(
                  //   margin: const EdgeInsets.only(top: 5.0),
                  //   child: new Text(
                  //     chat.text,
                  //     style: TextStyle(color: Get.theme.primaryColor),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
