import 'package:cloud_firestore/cloud_firestore.dart';

import 'Message.dart';
import 'User.dart';

class Chat {
  String id;
  User user;
  DocumentReference userref;
  List<dynamic> conversation;
  Chat({this.id, this.user, this.conversation, this.userref});

  Chat.fromFire(fire)
      : id = null,
        user = null,
        userref = fire['user'],
        conversation = fire['messages'];

  Map<String, dynamic> tofire() => {
        'user': user,
        'messages': conversation,
      };
}
