import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import '../../../models/Client.dart';
import '../../../models/User.dart';
import '../../../Network/UserNetwork.dart';

class AuthController extends GetxController {
  final hidePassword = true.obs;
  Image im = Image.asset('assets/img/tools.png');
  File file;
  User currentuser;
  Client currentProfile;
  RxString gender = 'Male'.obs;
  DocumentReference data;

  Future<void> onInit() {
    file = File('');
    // im = Image.file(file);
    currentuser = User();
    currentProfile = Client();
    super.onInit();
  }

  Future<bool> verifylogin(String email, String pass) async {
    UserNetwork _userNetwork = UserNetwork();

    bool ok = true;
    var data = await _userNetwork.getUserByEmailPassword(email, pass);
    data != null ? currentuser = data : ok = false;
    var d = _userNetwork.getUserRef(currentuser.id);
    await _userNetwork
        .getClientByUserRef(d)
        .then((value) => currentProfile = value);
    return ok;
    // if (data == null) return false;
    // return true;
  }

  registerUser(User u) async {
    UserNetwork _userNetwork = UserNetwork();

    await _userNetwork.addUser(u).then((dr) => data=dr);

  }

  registerClient(Client c, DocumentReference d) async {
    UserNetwork _userNetwork = UserNetwork();

    var url;
    await uploadFile().then((value) {
      url = value;
    });
    c.profile_photo = url;
    var data = _userNetwork.addClient(c, d);
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
