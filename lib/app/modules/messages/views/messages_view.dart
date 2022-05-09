import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Network/MessageNetwork.dart';
import '../../../Network/UserNetwork.dart';
import '../../../global_widgets/circular_loading_widget.dart';
import '../../../global_widgets/notifications_button_widget.dart';
import '../../../models/Chat.dart';
import '../../../models/Message.dart';
import '../../../services/auth_service.dart' show AuthService;
import '../controllers/messages_controller.dart';
import '../widgets/chat_message_item_widget.dart';
import '../widgets/message_item_widget.dart';

class MessagesView extends GetView<MessagesController> {
  CollectionReference usersRef = FirebaseFirestore.instance.collection('User');
  UserNetwork _userNetwork = UserNetwork();
  MessageNetwork _messageNetwork = MessageNetwork();
  Widget conversationsList() {
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
                          Chat _chat = Chat();
                          print(snapshot.data.docs.length);
                          for (var i = 0; i < snapshot.data.docs.length; i++) {
                            _chat.id = snapshot.data.docs[i].id;
                            _userNetwork
                                .getUserById(
                                    snapshot.data.docs[i].data()['user'].id)
                                .then((value) {
                              _chat.user = value;
                            });

                            // _messageNetwork
                            //     .getChatMessages(_chat.id)
                            //     .then((msg) {
                            //   _chat.conversation = msg;
                            // });

                            val.chats.add(_chat);
                          }
                          Future.delayed(Duration(seconds: 3));
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: val.chats.length,
                              itemBuilder: ((context, index) {
                                // ServiceProvider provider =
                                //     ServiceProvider.fromFire(
                                //         snapshot.data.docs[index]);
                                //  eServiceController.getThisProvider(provider,snapshot.data.docs[index].id);
                                // Chat _chat =
                                //     Chat.fromFire(snapshot.data.docs[index]);

                                return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: ChatMessageItem(chat: _chat));
                              }));
                        }
                      }),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chats".tr,
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
      body: !Get.find<AuthService>().isAuth
          ? Text('Permission denied')
          : ListView(
              primary: false,
              children: <Widget>[
                conversationsList(),
              ],
            ),
    );
  }
}
