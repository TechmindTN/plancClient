import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../global_widgets/block_button_widget.dart';
import '../../../global_widgets/text_field_widget.dart';
import '../../../models/User.dart';
import '../../../their_models/setting_model.dart';
import '../../../routes/app_pages.dart';
import '../../../services/settings_service.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  // final _currentUser = Get.find<AuthService>().user;
  final Setting _settings = Get.find<SettingsService>().setting.value;
  final formGlobalKey = GlobalKey<FormState>();

  String _email = '';
  String _pass = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Login".tr,
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
                height: 180,
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
                  child:  Image.asset(
                    'assets/img/planc_2.png',
                    fit: BoxFit.scaleDown,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
            ],
          ),
          Form(
              key: formGlobalKey,
              child: Column(
                children: [
                  TextFieldWidget(
                    labelText: "Email Address".tr,
                    hintText: "johndoe@gmail.com".tr,
                    iconData: Icons.alternate_email,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'field is empty'.tr;
                      } else {
                        if (!text.isEmail) {
                          return 'Email Format not valid';
                        }
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
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'field is empty'.tr;
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.offAndToNamed(Routes.FORGOT_PASSWORD);
                        },
                        child: Text("Forgot Password?".tr),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 20),
                  GetBuilder<AuthController>(
                    builder: (controller) {
                      return (!controller.loading)?BlockButtonWidget(
                        onPressed: () async {
                          controller.loading=true;
                          controller.update();
                          if (formGlobalKey.currentState.validate()) {
                            if (await controller.verifylogin(_email, _pass) ==
                                true) {
                                  controller.loading=false;
                          controller.update();
                              print('user logged');
                              Get.offAllNamed(Routes.ROOT);
                            } else {
                              controller.loading=false;
                          controller.update();
                              Get.showSnackbar(Ui.ErrorSnackBar(
                                  message: 'No user with these credentials !'));
                            }
                          }
                        },
                        color: Get.theme.accentColor,
                        text: Text(
                          "Login".tr,
                          style: Get.textTheme.headline6
                              .merge(TextStyle(color: Get.theme.primaryColor)),
                        ),
                      ).paddingSymmetric(vertical: 10, horizontal: 20):CircularProgressIndicator();
                    }
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Get.offAllNamed(Routes.REGISTER);
                        },
                        child: Text("You don't have an account?".tr),
                      ),
                    ],
                  ).paddingSymmetric(vertical: 20),
                ],
              ))
        ]));
  }
}
