import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import '../../../Network/ChatNetwork.dart';
import '../../../Network/ClientNetwork.dart';
import '../../../models/Chat.dart';
import '../../../Network/UserNetwork.dart';

import '../../../models/Message.dart';
import 'package:path/path.dart';

import '../../../models/Client.dart';
import '../../../models/Provider.dart';
import '../../../models/User.dart';
import '../../../repositories/chat_repository.dart';
import '../../../services/auth_service.dart';
import '../../auth/controllers/auth_controller.dart';
// import '../repository/notification_repository.dart';

class MessagesController extends GetxController {
  UserNetwork userNetwork;
  ClientNetwork _clientNetwork = ClientNetwork();
  AuthController _authController;
  RxList<Asset> images = <Asset>[].obs;
  Rx<File> file = File('').obs;

  final chatTextController = TextEditingController();
  Client client;
  User user;
  RxList<User> receiver = <User>[].obs;
  List<ServiceProvider> receiver_provider = [];
  DocumentReference clientRef;

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
    clientRef = await _clientNetwork.getClientRef(client.id);

    super.onInit();
  }

  @override
  void onClose() {
    chatTextController.dispose();
  }

  Future<String> uploadFile(file) async {
    final filename = basename(file.path);
    final destination = "/Chat/media/$filename";
    // FirebaseStorage storage = FirebaseStorage.instance;
    // Reference refimage = storage.ref().child("/stores_main/$filename");
    final ref = FirebaseStorage.instance.ref(destination);
    UploadTask uploadtask = ref.putFile(file);
    // TaskSnapshot dowurl = await (await uploadtask.whenComplete(() {}));
    final snapshot = await uploadtask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    //var url = dowurl.toString();
    print(urlDownload);
    return urlDownload;
  }

  Future changeImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile pickedimage =
        await _picker.pickImage(source: ImageSource.gallery);
    file.value = File(pickedimage.path);
    update();
    print(file.value);
  }
}
