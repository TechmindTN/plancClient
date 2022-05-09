import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  Notification({this.id, this.title, this.description, this.creation_date});
  String id;
  String title;
  String description;
  Timestamp creation_date;

  Notification.fromFire(fire)
      : title = fire["title"],
        creation_date = fire['creation_date'],
        description = fire['description'];

  Map<String, dynamic> tofire() => {
        'title': title,
        'description': description,
        'creation_date': creation_date
      };

  @override
  String toString() {
    // TODO: implement toString
    return 'Notification : title: ' +
        title +
        ' description: ' +
        description +
        ' creation_date: ' +
        creation_date.toDate().toString();
  }
}
