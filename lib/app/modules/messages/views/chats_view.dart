import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/ui.dart';
import '../../../Network/MessageNetwork.dart';
import '../../../Network/UserNetwork.dart';
import '../../../models/Chat.dart';
import '../../../models/Message.dart';

import '../../../global_widgets/circular_loading_widget.dart';

import '../../../models/Provider.dart';
import '../../../models/User.dart';
import '../controllers/messages_controller.dart';
import '../widgets/chat_message_item_widget.dart';
import '../widgets/message.dart';
import '../widgets/new_message.dart';

// ignore: must_be_immutable
class ChatsView extends GetView<MessagesController> {
  final chat_id;
  final ServiceProvider provider;
  ChatsView({this.chat_id, this.provider});

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
          title: Text(
            provider.name,
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
        body: Container(
          color: Color.fromARGB(131, 253, 193, 229),
          child: Column(
            children: [
              Expanded(
                child: Messsages(
                  chat_id: chat_id,
                  receiver_client: provider,
                ),
              ),
              NewMessage(
                chat_id: chat_id,
              ),
              GetBuilder<MessagesController>(
                  init: MessagesController(),
                  builder: (val) => Visibility(
                      visible: val.file.value.toString() != File('').toString()
                          ? true
                          : false,
                      child: Container(
                        child: Image.file(val.file.value),
                        height: 100,
                        width: 200,
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
