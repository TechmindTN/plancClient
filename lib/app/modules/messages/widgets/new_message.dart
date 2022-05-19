import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import '../../../../common/ui.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/messages_controller.dart';

class NewMessage extends GetWidget<MessagesController> {
  final String chat_id;
  NewMessage({Key key, this.chat_id}) : super(key: key);

  RxString _enteredMessage = ''.obs;
  RxString _imagelink = ''.obs;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void _sendMessage() async {
      if (_enteredMessage.value.trim() != '' ||
          controller.file.value != File('')) {
        final _currentUsre = Get.find<AuthController>().currentuser;
        print('chat id ' + chat_id);
        FirebaseFirestore.instance
            .collection('Chat')
            .doc(chat_id)
            .update({'LastMsgAt': Timestamp.now()});

        if (_enteredMessage.value != '') {
          FirebaseFirestore.instance
              .collection("Chat")
              .doc(chat_id)
              .collection("messages")
              .add({
            'content': _enteredMessage.value,
            'type': "text",
            'createdAt': Timestamp.now(),
            'userId': _currentUsre.id,
          }).then((value) => print('document ref' + value.id));
          _enteredMessage.value = '';
          _controller.clear();
        } else {
          // ignore: missing_return
          await controller.uploadFile(controller.file.value).then((value) {
            FirebaseFirestore.instance
                .collection("Chat")
                .doc(chat_id)
                .collection("messages")
                .add({
              'content': value,
              'type': "file",
              'createdAt': Timestamp.now(),
              'userId': _currentUsre.id
            });
            controller.file.value = File('');
          });
        }
      } else {
        return null;
      }
    }

    return Container(
      decoration: BoxDecoration(
        // gradient: const LinearGradient(colors: [
        //   Color.fromARGB(255, 155, 39, 176),
        //   Color.fromARGB(255, 233, 30, 98)
        // ]),
        color: Ui.parseColor('#00B6BF'),
      ),
      padding: const EdgeInsets.only(bottom: 2),
      margin: const EdgeInsets.only(bottom: 0),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                style: const TextStyle(color: Colors.white),
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Send a message',
                  border: InputBorder.none,
                  labelStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (value) {
                  _enteredMessage.value = value;
                },
              ),
            ),
            Row(children: [
              IconButton(
                onPressed: () async {
                  await controller.changeImage();
                },
                icon: const Icon(Icons.filter),
                color: Colors.white,
              ),
              IconButton(
                icon: const Icon(Icons.send),
                color: Colors.white,
                onPressed: _sendMessage,
              ),
            ])
          ],
        ),
      ),
    );
  }
}
