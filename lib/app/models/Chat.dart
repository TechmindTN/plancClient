import 'Message.dart';
import 'User.dart';

class Chat {
  String id;
  User user;
  List<Message> conversation;
  Chat({this.id, this.user, this.conversation});

  Chat.fromFire(fire)
      : id = null,
        user = null,
        conversation = fire['conversation'];
  Map<String, dynamic> tofire() => {
        'users': user,
        'conversation': conversation,
      };
}
