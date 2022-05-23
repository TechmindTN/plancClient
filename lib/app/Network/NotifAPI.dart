import 'dart:io';

import 'package:http/http.dart' as http;

class Api {
  final HttpClient httpClient = HttpClient();
  final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  final fcmKey =
      "AAAAp7exie4:APA91bEf08-dtpZ5dpMNtGHx97QKM-bqY84JrINgigRpzTZOqj-XMsvewxAhWJ2WtsydpqN9W0mG9gN7Ucu5IBa7GZM3i3oPFdHOUD1dS_Pdbyrk3uYfRq9EmEh5wcJyx38p2_Cx2Nj6";

  void sendFcm(String title, String body, String fcmToken) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmKey'
    };
    var request = http.Request('POST', Uri.parse(fcmUrl));
    request.body =
        '''{"to":"$fcmToken","priority":"high","notification":{"title":"$title","body":"$body","sound": "default"}}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print('here 1 ' + await response.stream.bytesToString());
    } else {
      print('here 2 ' + response.reasonPhrase);
    }
  }
}
