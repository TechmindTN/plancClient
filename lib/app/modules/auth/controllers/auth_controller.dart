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
  UserNetwork _userNetwork = UserNetwork();
  Image im;
  File file;

  Future<void> onInit() {
    file = File('');
    im = Image.file(file);
    super.onInit();
  }

  Future<bool> verifylogin(String email, String pass) async {
    bool ok;
    var data = await _userNetwork.getUserByEmailPassword(email, pass);
    data != null ? ok = true : ok = false;
    return ok;
    // if (data == null) return false;
    // return true;
  }

  registerUser(User u) {
    var data = _userNetwork.addUser(u);
  }

  registerClient(Client c, DocumentReference d) async {
    var url;
    await uploadFile().then((value) {
      url = value;
    });
    c.profile_photo = url;
    print(url);
    print(d);
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
