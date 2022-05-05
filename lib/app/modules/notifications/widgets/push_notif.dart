// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import '../../../models/Notification.dart';

// class MessagingWidget extends StatefulWidget {
//   @override
//   _MessagingWidgetState createState() => _MessagingWidgetState();
// }

// class _MessagingWidgetState extends State<MessagingWidget> {
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   final List<Notification> messages = [];

//   @override
//   void initState() {
//     super.initState();
//     _firebaseMessaging.
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//         final notification = message['notification'];
        
//           messages.add(PushNotification(
//               title: notification['title'], body: notification['body']));
        
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");

//         final notification = message['data'];
//         setState(() {
//           messages.add(Message(
//             title: '${notification['title']}',
//             body: '${notification['body']}',
//           ));
//         });
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//       },
//     );
//     _firebaseMessaging.requestNotificationPermissions(
//         const IosNotificationSettings(sound: true, badge: true, alert: true));
//   }

//   @override
//   Widget build(BuildContext context) => ListView(
//         children: messages.map(buildMessage).toList(),
//       );

//   Widget buildMessage(Message message) => ListTile(
//         title: Text(message.title),
//         subtitle: Text(message.body),
//       );
// }