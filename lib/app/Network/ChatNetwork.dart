import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Chat.dart';
import '../models/Message.dart';
import 'MessageNetwork.dart';
import 'UserNetwork.dart';

class ChatNetwork {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference ChatsRef = FirebaseFirestore.instance.collection('Chat');
  UserNetwork _userNetwork = UserNetwork();
  MessageNetwork _messageNetwork = MessageNetwork();
  List<Chat> ChatList = [];
//   Future<List<Chat>> getUserChats(String id) async {
//     var ref = _userNetwork.getUserRef(id);

//     QuerySnapshot q = await ChatsRef.where('users', whereIn: ref).get();
//     q.docs.forEach((element) async {
//       Chat c;
//       c.id = element.id;
//       var user1 = await _userNetwork.getUserById(element.data()['users'][0]);
//       var user2 = await _userNetwork.getUserById(element.data()['users'][1]);
//       List<Message> list = await _messageNetwork.getChatMessages(c.id);
//       c.user = (user1);
//       c.conversation = list;
//       ChatList.add(c);
//     });
//   }
// }
}
