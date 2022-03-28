import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/models/User.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../../../common/ui.dart';
import '../../../Network/UserNetwork.dart';
import '../../../models/Client.dart';
import '../../../services/auth_service.dart';
import '../../account/controllers/account_controller.dart';
import '../../auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
  final hidePassword = true.obs;
  AuthController _authController = Get.find<AuthController>();
  CollectionReference clientRef =
      FirebaseFirestore.instance.collection('Client');
  var currentuser = User();
  var currentProfile = Client();
  Image im;
  File file;
  DocumentReference d;

  @override
  Future<void> onInit() async {
    file = File('');
    im = Image.file(file);
    currentuser = _authController.currentuser;
    currentProfile = _authController.currentProfile;
    print('user logged :' + currentuser.toString());
    print('client logged :' + currentProfile.printClient());
    super.onInit();
  }

  void saveProfileForm(GlobalKey<FormState> profileForm) {
    if (profileForm.currentState.validate()) {
      profileForm.currentState.save();
      currentProfile.printClient();
      updateClient();
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Profile saved successfully".tr));
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "There are errors in some fields please correct them!".tr));
    }
  }

  void resetProfileForm(GlobalKey<FormState> profileForm) {
    profileForm.currentState.reset();
  }

  updateClient() async {
    print('Id profile ' + currentProfile.id);
    await clientRef.doc(currentProfile.id).set(
          currentProfile.tofire(),
        );
  }

  Future<String> uploadFile() async {
    final filename = basename(file.path);
    final destination = "/User/Client/Profile/$filename";
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

  changeImage() async {
    final ImagePicker _picker = ImagePicker();

    final XFile pickedimage =
        await _picker.pickImage(source: ImageSource.gallery);
    file = File(pickedimage.path);
    im = Image.file(file);
    currentProfile.profile_photo = await uploadFile();
    update();
    print("this");
    print(im);

    //       storeimage=Container(
    //         height: 150,
    //         child: Image(
    //   image: FileImage(im,

    //   ),
    // ),
    //       );
    //print(storeimage);
  }
}
