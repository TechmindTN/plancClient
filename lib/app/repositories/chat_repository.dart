import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../their_models/chat_model.dart';
import '../their_models/message_model.dart';

class ChatRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//  User _userFromFirebaseUser(User user) {
//    return user != null ? User(uid: user.uid) : null;
//  }

  Future signInWithToken(String token) async {
    try {
      UserCredential result = await _auth.signInWithCustomToken(token);
      if (result.user != null) {
        return true;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (result.user != null) {
        return true;
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String token) async {
    return FirebaseFirestore.instance.collection("users").where("token", isEqualTo: token).get().catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance.collection("users").where('userName', isEqualTo: searchField).get();
  }

  // Create Message
  Future<void> createMessage(Message message) {
    return FirebaseFirestore.instance.collection("messages").doc(message.id).set(message.toJson()).catchError((e) {
      print(e);
    });
  }

  Stream<List<Message>> getUserMessages(String userId) {
    return FirebaseFirestore.instance
        .collection("messages")
        .where('visible_to_users', arrayContains: userId)
        //.orderBy('time', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Message> retVal = [];
      query.docs.forEach((element) {
        retVal.add(Message.fromDocumentSnapshot(element));
      });
      return retVal;
    });
  }

  Stream<List<Chat>> getChats(Message message) {
    return FirebaseFirestore.instance.collection("messages").doc(message.id).collection("chats").orderBy('time', descending: true).snapshots().map((QuerySnapshot query) {
      List<Chat> retVal = [];
      query.docs.forEach((element) {
        retVal.add(Chat.fromDocumentSnapshot(element));
      });
      return retVal;
    });
    // return updateMessage(message.id, {'read_by_users': message.readByUsers}).then((value) async {
    //
    // });
  }

  Future<void> addMessage(Message message, Chat chat) {
    return FirebaseFirestore.instance.collection("messages").doc(message.id).collection("chats").add(chat.toJson()).whenComplete(() {
      updateMessage(message.id, message.toUpdatedMap());
    }).catchError((e) {
      print(e.toString());
    });
  }

  Future<void> updateMessage(String messageId, Map<String, dynamic> message) {
    return FirebaseFirestore.instance.collection("messages").doc(messageId).update(message).catchError((e) {
      print(e.toString());
    });
  }
}
