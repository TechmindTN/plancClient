import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Message.dart';

class MessageNetwork {
  CollectionReference MessagesRef =
      FirebaseFirestore.instance.collection('Message');
  CollectionReference ChatsRef = FirebaseFirestore.instance.collection('Chat');
  CollectionReference UserRef = FirebaseFirestore.instance.collection('User');
  Future<DocumentReference> addMessage(
      String content, DocumentReference u1, u2) async {
    try {
      Message m = Message(content: content, time: Timestamp.now());
      var data = m.tofire();
      data['sent_by'] = u1;
      data['sent_to'] = u2;
      DocumentReference ref = await MessagesRef.add(data);
    } catch (e) {}
  }

  Stream<List<Message>> getChatMessages(String id, String uid) {
    Stream<DocumentSnapshot> q =
        UserRef.doc(uid).collection('Chat').doc(id).snapshots();
  }
}
