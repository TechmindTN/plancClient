import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../global_widgets/block_button_widget.dart';
import '../../../global_widgets/text_field_widget.dart';
import '../../../models/User.dart' as user;
import '../../../their_models/setting_model.dart';
import '../../../routes/app_pages.dart';
import '../../../services/settings_service.dart';
import '../controllers/auth_controller.dart';
import 'register_view2.dart';

class RegisterView extends GetView<AuthController> {
  // final _currentUser = Get.find<AuthService>().user;
  FirebaseAuth auth = FirebaseAuth.instance;

  final Setting _settings = Get.find<SettingsService>().setting.value;
  String _email = '';
  String _pass = '';
  bool confirm_pass = false;
  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register".tr,
          style: Get.textTheme.headline6
              .merge(TextStyle(color: context.theme.primaryColor)),
        ),
        centerTitle: true,
        backgroundColor: Get.theme.accentColor,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: ListView(primary: true, children: [
        Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Container(
              height: 160,
              width: Get.width,
              decoration: BoxDecoration(
                color: Get.theme.accentColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Get.theme.focusColor.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5)),
                ],
              ),
              margin: EdgeInsets.only(bottom: 50),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      _settings.appName,
                      style: Get.textTheme.headline6.merge(TextStyle(
                          color: Get.theme.primaryColor, fontSize: 24)),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Welcome to the best service provider system!".tr,
                      style: Get.textTheme.caption
                          .merge(TextStyle(color: Get.theme.primaryColor)),
                      textAlign: TextAlign.center,
                    ),
                    // Text("Fill the following credentials to login your account", style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
                  ],
                ),
              ),
            ),
            Container(
              decoration: Ui.getBoxDecoration(
                radius: 14,
                border: Border.all(width: 5, color: Get.theme.primaryColor),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  'assets/icon/icon.png',
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ],
        ),
        Form(
            key: formGlobalKey,
            child: Column(children: [
              TextFieldWidget(
                labelText: "Email Address".tr,
                hintText: "johndoe@gmail.com".tr,
                iconData: Icons.alternate_email,
                keyboardType: TextInputType.emailAddress,
                isFirst: true,
                isLast: false,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'field is empty'.tr;
                  }
                  _email = text;
                  return null;
                },
              ),
              Obx(() {
                return TextFieldWidget(
                  labelText: "Password".tr,
                  hintText: "••••••••••••".tr,
                  obscureText: controller.hidePassword.value,
                  iconData: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                  isLast: false,
                  isFirst: false,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'field is empty'.tr;
                    } else {
                      if (text.length < 8) {
                        return 'Password too short'.tr + ' !';
                      }
                    }
                    _pass = text;
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.hidePassword.value =
                          !controller.hidePassword.value;
                    },
                    color: Theme.of(context).focusColor,
                    icon: Icon(controller.hidePassword.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                  ),
                );
              }),
              Obx(() {
                return TextFieldWidget(
                  labelText: "Confirm Password".tr,
                  hintText: "••••••••••••".tr,
                  obscureText: controller.hidePassword.value,
                  iconData: Icons.lock_outline,
                  keyboardType: TextInputType.visiblePassword,
                  isLast: true,
                  isFirst: false,
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'field is empty'.tr;
                    }
                    if (text != _pass) {
                      return 'Not matching !';
                    }

                    return null;
                  },
                );
              }),
            ])),
      ]),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            direction: Axis.vertical,
            children: [
              SizedBox(
                width: Get.width,
                child: BlockButtonWidget(
                  onPressed: () async {
                    UserCredential userCredential;
                    if (formGlobalKey.currentState.validate()) {
                      try {
                        userCredential =
                            await auth.createUserWithEmailAndPassword(
                          email: _email,
                          password: _pass,
                        );
                        controller.currentfireuser = userCredential.user;
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('The password provided is too weak.');
                          Get.showSnackbar(Ui.ErrorSnackBar(
                              message: 'The password provided is too weak.'));
                        } else if (e.code == 'email-already-in-use') {
                          Get.showSnackbar(Ui.ErrorSnackBar(
                              message:
                                  'The account already exists for that email.'));
                          print('The account already exists for that email.');
                        } else {
                          print('cooooooode' + e.code);
                        }
                        return null;
                      }

                      try {
                        if (userCredential.user != null &&
                            !userCredential.user.emailVerified) {
                          await userCredential.user.sendEmailVerification();
                        }
                      } catch (e) {
                        print(e);
                        return null;
                      }
                      ;
                      if (userCredential.user != null) {
                        print('verif' +
                            userCredential.user.emailVerified.toString());
                        print('user' + userCredential.toString());
                        controller.u1 = user.User(
                            email: _email,
                            password: _pass,
                            username: _email,
                            creation_date: Timestamp.now());
                        controller.registerUser(controller.u1);

                        navigator.pushAndRemoveUntil<void>(
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  RegisterView2()),
                          ModalRoute.withName('/'),
                        );
                        // Get.offAllNamed(Routes.REGISTER2);
                      }
                    }
                  },
                  color: Get.theme.accentColor,
                  text: Text(
                    "Continue".tr,
                    style: Get.textTheme.headline6
                        .merge(TextStyle(color: Get.theme.primaryColor)),
                  ),
                ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20),
              ),
              TextButton(
                onPressed: () {
                  Get.offAllNamed(Routes.LOGIN);
                },
                child: Text("You already have an account?".tr),
              ).paddingOnly(bottom: 10),
            ],
          ),
        ],
      ),
    );
  }
}
