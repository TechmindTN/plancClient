import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
import '../../../Network/MessageNetwork.dart';
import '../../../Network/ServiceProviderNetwork.dart';
import '../../../Network/UserNetwork.dart';
import '../../../models/Chat.dart';
import '../../../models/Client.dart';
import '../../../models/Message.dart';

import '../../../global_widgets/circular_loading_widget.dart';

import '../../../models/Provider.dart';
import '../../../models/User.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/messages_controller.dart';
import '../widgets/chat_message_item_widget.dart';
import '../widgets/message.dart';
import '../widgets/new_message.dart';
import 'chats_view.dart';

// ignore: must_be_immutable
class MessagesView extends GetView<MessagesController> {
  ServiceProviderNetwork _providerNetwork = ServiceProviderNetwork();

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Colors.purple, Colors.pink],
        //     tileMode: TileMode.clamp,
        //     begin: Alignment.topRight,
        //     end: Alignment.bottomLeft,
        //   ),
        // ),
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Chat',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Ui.parseColor('#00B6BF'),
              // actions: [
              //   DropdownButton(
              //     icon: const Icon(
              //       Icons.more_vert,
              //       color: Colors.white,
              //     ),
              //     items: [
              //       DropdownMenuItem(
              //         child: Row(children: const [
              //           Icon(
              //             Icons.exit_to_app,
              //             color: Colors.pink,
              //           ),
              //           SizedBox(
              //             width: 8,
              //           ),
              //           Text('Logout')
              //         ]),
              //         value: 'logout',
              //       )
              //     ],
              //     onChanged: (itemIdentifier) {
              //       if (itemIdentifier == 'logout') {}
              //     },
              //   )
              // ],
            ),
            body: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Chat")
                    .where('users', arrayContains: controller.clientRef)
                    .orderBy('LastMsgAt', descending: true)
                    .snapshots(),
                builder: (ctx, chatSnapshot) {
                  if (chatSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final chatDocs = chatSnapshot.data?.docs;
                    ServiceProvider sp;
                    //  var Lastmsg = FirebaseFirestore.instance
                    // .collection("Chat")
                    // .where('users', arrayContains: controller.userRef)
                    int i = 0;
                    return ListView.builder(
                        itemCount: chatDocs?.length,
                        // ignore: missing_return
                        itemBuilder: (ctx, index) {
                          print('chat n° ' +
                              i.toString() +
                              ' ' +
                              chatDocs[index].id.toString());

                          i++;
                          if (chatDocs[index]["users"]
                              .contains(controller.clientRef)) {
                            chatDocs[index]["users"].forEach((el) {
                              if (el.id != controller.user.id) {
                                // print('el.id ' + el.id);
                                // controller.userNetwork
                                //     .getUserById(el.id)
                                //     .then((value) {
                                //   controller.receiver.add(value);
                                //   controller.update();
                                // });
                                // _providerNetwork
                                //     .getProviderByUserRef(el)
                                //     .then((value2) {
                                //   controller.receiver_provider.add(value2);
                                //   controller.update();
                                // });
                                _providerNetwork
                                    .getProviderById(el.id)
                                    .then((value) {
                                  controller.receiver_provider.add(value);
                                  controller.update();
                                });
                              }
                            });
                            print('here');
                            return GetBuilder<MessagesController>(
                                init: MessagesController(),
                                builder: (val) => Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(children: [
                                        InkWell(
                                            child: Container(
                                              height: 80,
                                              child: Column(children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(val
                                                                .receiver_provider[
                                                                    index]
                                                                .profile_photo),
                                                      ),
                                                      SizedBox(width: 15),
                                                      Text(
                                                        val
                                                                .receiver_provider[
                                                                    index]
                                                                .name ??
                                                            '',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w800),
                                                      ),
                                                    ]),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text("Last message",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                  ],
                                                )
                                              ]),
                                            ),
                                            onTap: () {
                                              Get.to(() => ChatsView(
                                                  chat_id: chatDocs[index].id,
                                                  provider: controller
                                                          .receiver_provider[
                                                      index]));
                                            }),
                                        Divider(height: 8, thickness: 1),
                                      ]),
                                    ));
                          }
                        });
                  }
                })));
  }
}
