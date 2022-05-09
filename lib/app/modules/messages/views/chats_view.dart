import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Network/MessageNetwork.dart';
import '../../../Network/UserNetwork.dart';
import '../../../models/Chat.dart';
import '../../../models/Message.dart';

import '../../../global_widgets/circular_loading_widget.dart';

import '../controllers/messages_controller.dart';
import '../widgets/chat_message_item_widget.dart';

// ignore: must_be_immutable
class ChatsView extends GetView<MessagesController> {
  MessageNetwork _messageNetwork = MessageNetwork();
  UserNetwork _userNetwork = UserNetwork();
  Message _message;
  CollectionReference usersRef = FirebaseFirestore.instance.collection('User');

  Widget chatList() {
    return GetBuilder<MessagesController>(
        init: MessagesController(),
        builder: (val) => Container(
              height: 345,
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: StreamBuilder(
                      stream: usersRef
                          .doc(val.user.id)
                          .collection('Chat')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text(
                            'No Data...',
                          );
                        } else {
                          print('chat data ' + snapshot.data.docs.toString());
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: ((context, index) {
                                Chat _chat =
                                    Chat.fromFire(snapshot.data.docs[index]);

                                val.chats.add(_chat);
                                // return Padding(
                                //     padding: const EdgeInsets.symmetric(
                                //         horizontal: 16.0),
                                //     child: ChatMessageItem(chat: _chat));
                              }));
                        }
                      }),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    _message = Get.arguments as Message;
    // controller.listenForChats(controller.user.id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () {
              Get.back();
              // if (widget.routeArgument.id == null) {
              //   // from conversation page
              //   Navigator.of(context).pushNamed('/Pages', arguments: 4);
              // } else {
              //   Navigator.of(context).pushNamed('/Details', arguments: RouteArgument(id: '0', param: widget.routeArgument.id, heroTag: 'chat_tab'));
              // }
            }),
        automaticallyImplyLeading: false,
        title: Text(
          // _message.name,
          '',
          overflow: TextOverflow.fade,
          maxLines: 1,
          style: Get.textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: chatList(),
          ),
          Container(
            decoration: BoxDecoration(
              color: Get.theme.primaryColor,
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).hintColor.withOpacity(0.10),
                    offset: Offset(0, -4),
                    blurRadius: 10)
              ],
            ),
            child: TextField(
              controller: controller.chatTextController,
              style: Get.textTheme.bodyText1,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(20),
                hintText: "Type to start chat".tr,
                hintStyle:
                    TextStyle(color: Get.theme.focusColor.withOpacity(0.8)),
                suffixIcon: IconButton(
                  padding: EdgeInsets.only(right: 30),
                  onPressed: () {
                    controller.addMessage(
                        _message, controller.chatTextController.text);
                    Timer(Duration(milliseconds: 100), () {
                      controller.chatTextController.clear();
                    });
                  },
                  icon: Icon(
                    Icons.send_outlined,
                    color: Theme.of(context).accentColor,
                    size: 30,
                  ),
                ),
                border: UnderlineInputBorder(borderSide: BorderSide.none),
                enabledBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
                focusedBorder:
                    UnderlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          )
        ],
      ),
    );
  }
}
