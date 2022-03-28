import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../Network/UserNetwork.dart';
import '../../../models/Client.dart';
import '../../../models/User.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class AccountController extends GetxController {
  AuthController _authController = Get.find<AuthController>();

  UserNetwork _userNetwork = UserNetwork();
  var currentuser = User();
  var currentProfile = Client();
  DocumentReference d;

  Future<void> onInit() async {
    Get.put<ProfileController>(ProfileController());

    currentuser = _authController.currentuser;
    currentProfile = _authController.currentProfile;
    print('user logged :' + currentuser.toString());
    print('client logged :' + currentProfile.toString());
    super.onInit();
  }
}
