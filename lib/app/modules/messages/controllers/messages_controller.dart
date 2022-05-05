import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Network/ChatNetwork.dart';
import '../../../models/Chat.dart';
import '../../../Network/UserNetwork.dart';

import '../../../models/Message.dart';

import '../../../models/Client.dart';
import '../../../models/User.dart';
import '../../../repositories/chat_repository.dart';
import '../../../services/auth_service.dart';
import '../../auth/controllers/auth_controller.dart';
// import '../repository/notification_repository.dart';

class MessagesController extends GetxController {
  var message = Message().obs;
  ChatNetwork _chatNetwork;
  UserNetwork userNetwork;

  AuthService _authService;
  AuthController _authController;

  var messages = <Message>[].obs;
  var chats = <Chat>[].obs;
  final chatTextController = TextEditingController();
  Client client;
  User user;
  MessagesController() {
    userNetwork = new UserNetwork();
    _authService = Get.find<AuthService>();
    _authController = Get.find<AuthController>();
  }

  @override
  void onInit() async {
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Appliance Repair Company'));
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Shifting Home'));
    client = Get.find<AuthController>().currentProfile;
    user = Get.find<AuthController>().currentuser;

    super.onInit();
  }

  @override
  void onClose() {
    chatTextController.dispose();
  }

  signIn() {
    //_chatRepository.signUpWithEmailAndPassword(_authService.user.value.email, _authService.user.value.apiToken);
//    _chatRepository.signInWithToken(_authService.user.value.apiToken);
  }

  // Future createMessage(Message _message) async {
  //   print(_message);
  //   _message.lastMessageTime = DateTime.now().toUtc().millisecondsSinceEpoch;

  //   message.value = _message;

  //   _chatRepository.createMessage(_message).then((value) {
  //     listenForChats(_message);
  //   });
  // }

  // Future listenForMessages() async {
  //   _chatRepository.getUserMessages(user.id).listen((event) {
  //     event.sort((Message a, Message b) {
  //       return b.lastMessageTime.compareTo(a.lastMessageTime);
  //     });
  //     messages.value = event;
  //   });
  // }

  // listenForChats(String id) async {
  //   chats.value = await userNetwork.getUserChats(id);
  //   chats.value.forEach((element) {
  //     messages = (element.conversation);
  //   });
  // }

  addMessage(Message _message, String text) {}
  //   Chat _chat =
  //       new Chat(text, DateTime.now().toUtc().millisecondsSinceEpoch, user.id);
  //   if (_message.id == null) {
  //     _message.id = UniqueKey().toString();
  //     createMessage(_message);
  //   }
  //   _message.lastMessage = text;
  //   _message.lastMessageTime = _chat.time;
  //   _message.readByUsers = [_authService.user.value.id];
  //   _chatRepository.addMessage(_message, _chat).then((value) {
  //     _message.users.forEach((_user) {
  //       if (_user.id != _authService.user.value.id) {
  //         //sendNotification(text, "New Message From".tr + " " + _authService.user.value.name, _user);
  //       }
  //     });
  //   });
  // }
}
