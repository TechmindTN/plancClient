import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../Network/ServiceProviderNetwork.dart';
import '../../../Network/UserNetwork.dart';
import '../../../models/Client.dart';
import '../../../models/Provider.dart';
import '../../../models/User.dart';
import '../../auth/controllers/auth_controller.dart';
import '../widgets/message_bubble.dart';

class Messsages extends StatelessWidget {
  final chat_id;
  final ServiceProvider receiver_client;
  const Messsages({Key key, this.chat_id, this.receiver_client})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ServiceProviderNetwork _providerNetwork = ServiceProviderNetwork();

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Chat")
            .doc(chat_id)
            .collection("messages")
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data?.docs;
          User user = Get.find<AuthController>().currentuser;
          Client client = Get.find<AuthController>().currentProfile;

          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            ServiceProvider sp;
            return ListView.builder(
                reverse: true,
                itemCount: chatDocs?.length,
                // ignore: missing_return
                itemBuilder: (ctx, index) {
                  return MessageBubble(
                    chatDocs[index]['content'],
                    chatDocs[index]["type"],
                    chatDocs[index]['userId'] == user.id
                        ? user.username
                        : receiver_client.name,
                    client.profile_photo,
                    receiver_client.profile_photo,
                    chatDocs[index]['userId'] == user.id,
                    key: ValueKey(chatDocs[index].id),
                  );
                });
          }
        });
  }
}
