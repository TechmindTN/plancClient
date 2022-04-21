import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/Client.dart';
import '../../../models/User.dart' as user;
import '../../../Network/UserNetwork.dart';
import '../../home/controllers/home_controller.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  final hidePassword = true.obs;
  Rx<Image> im = Image.network(
          'https://icon-library.com/images/no-photo-available-icon/no-photo-available-icon-20.jpg')
      .obs;
  File file;
  user.User currentuser;
  Client currentProfile;
  var currentfireuser = FirebaseAuth.instance.currentUser;
  RxString gender = 'Male'.obs;
  DocumentReference data;
  user.User u1 = user.User();
  LatLng position;
  List<Placemark> marks = [];
  Set<Marker> markers = Set();
  SharedPreferences prefs;
  Future<void> onInit() async {
    file = File('');
    // prefs = await SharedPreferences.getInstance();
    // if (prefs.get('user') != null) {
    //   var saveduser = user.User.fromFire(json.decode(prefs.get('user')));
    //   verifylogin(saveduser.email, saveduser.password);
    // }
    // im = Image.file(file);
    currentuser = user.User();
    currentProfile = Client();
    super.onInit();
  }

  Future<bool> verifylogin(String email, String pass) async {
    UserNetwork _userNetwork = UserNetwork();

    bool ok = true;
    var data = await _userNetwork.getUserByEmailPassword(email, pass);
    data != null ? currentuser = data : ok = false;
    print(currentuser);
    print(ok);
    if (currentuser == null || currentuser.email == null) {
      return false;
    }
    var d = _userNetwork.getUserRef(currentuser.id);
    await _userNetwork
        .getClientByUserRef(d)
        .then((value) => currentProfile = value);

    Get.find<HomeController>().onInit();
    // prefs.setString('user', json.encode(currentuser.tofire()));
    return ok;
    // if (data == null) return false;
    // return true;
  }

  registerUser(user.User u) async {
    UserNetwork _userNetwork = UserNetwork();

    await _userNetwork.addUser(u).then((dr) => data = dr);
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
    im.value = Image.file(file);
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
