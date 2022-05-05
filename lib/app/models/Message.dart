import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_services/app/models/User.dart';

class Message {
  String id;
  User sent_by;
  User sent_to;
  String content;
  Timestamp time;

  Message({this.id, this.content, this.sent_by, this.sent_to, this.time});

  Message.fromFire(fire)
      : id = null,
        sent_by = null,
        sent_to = null,
        content = fire["content"],
        time = fire["time"];

  Map<String, dynamic> tofire() => {'content': content, 'time': time};
}
