import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Network/ChatNetwork.dart';
import '../../../models/Chat.dart';
import '../../../Network/UserNetwork.dart';

import '../../../models/Message.dart';

import '../../../models/Client.dart';
import '../../../models/Provider.dart';
import '../../../models/User.dart';
import '../../../repositories/chat_repository.dart';
import '../../../services/auth_service.dart';
import '../../auth/controllers/auth_controller.dart';
// import '../repository/notification_repository.dart';

class MessagesController extends GetxController {
  UserNetwork userNetwork;

  AuthController _authController;

  final chatTextController = TextEditingController();
  Client client;
  User user;
  RxList<User> receiver = <User>[].obs;
  RxList<ServiceProvider> receiver_provider = <ServiceProvider>[].obs;
  DocumentReference userRef;

  MessagesController() {
    userNetwork = new UserNetwork();
    _authController = Get.find<AuthController>();
  }

  @override
  void onInit() async {
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Appliance Repair Company'));
    // await createMessage(new Message([_authService.user.value], id: UniqueKey().toString(), name: 'Shifting Home'));
    client = Get.find<AuthController>().currentProfile;
    user = Get.find<AuthController>().currentuser;
    userRef = await userNetwork.getUserRef(user.id);

    super.onInit();
  }

  @override
  void onClose() {
    chatTextController.dispose();
  }
  
}