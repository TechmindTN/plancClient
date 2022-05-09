import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/messages_controller.dart';
import 'chat_message.dart';
import 'text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends GetWidget<MessagesController> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  void _sendMessage({String text, File imgFile}) async {
    final user = controller.user;
    final profile = controller.client;
    if (user == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content:
              Text('Não foi  possível realizar seu login. Tente novamente...'),
          backgroundColor: Colors.red,
        ),
      );
    }

    var data = <String, dynamic>{
      'uid': user.id,
      'senderName': user.username,
      'senderPhotoUrl': profile.profile_photo,
      'time': Timestamp.now(),
    };

    if (imgFile != null) {
      UploadTask task = FirebaseStorage.instance
          .ref('Image/name')
          .child(user.id + DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(imgFile);

      _isLoading = true;
      controller.update();

      var taskSnapshot = await task.whenComplete(() {});
      String url = await taskSnapshot.ref.getDownloadURL();
      data['imgUrl'] = url;

      _isLoading = false;
      controller.update();
    }
    if (text != null) data['text'] = text;
    FirebaseFirestore.instance.collection('messages').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(controller.user != null
            ? 'Olá, ${controller.user.username}'
            : 'Chat App'),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          controller.user != null
              ? IconButton(
                  icon: Icon(Icons.exit_to_app, color: Colors.white),
                  onPressed: () {
                    // FirebaseAuth.instance.signOut();
                    // googleSignIn.signOut();
                    // _scaffoldKey.currentState.showSnackBar(
                    //   SnackBar(content: Text('Você saiu com sucesso.')),
                    // );
                  },
                )
              : Container()
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Message')
                  .orderBy('time')
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    var documents = snapshot.data.docs.reversed.toList();
                    return ListView.builder(
                        itemCount: documents.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return ChatMessage(
                              documents[index].data(),
                              documents[index].data()['uid'] ==
                                  controller.user?.id);
                        });
                }
              },
            ),
          ),
          _isLoading ? LinearProgressIndicator() : Container(),
          TextComposer(_sendMessage),
        ],
      ),
    );
  }
}
