import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/text_field_widget.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final bool hideAppBar;
  final GlobalKey<FormState> _profileForm = new GlobalKey<FormState>();
  ProfileView({this.hideAppBar = false}) {
    // controller.profileForm = new GlobalKey<FormState>();
  }

  @override
  Widget build(BuildContext context) {
    var _currentProfile = Get.find<AuthController>().currentProfile;
    return Scaffold(
        appBar: hideAppBar
            ? null
            : AppBar(
                title: Text(
                  "Profile".tr,
                  style: context.textTheme.headline6,
                ),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                    icon: new Icon(Icons.arrow_back_ios,
                        color: Get.theme.hintColor),
                    onPressed: () {
                      controller.update();
                      Get.back();
                    }),
                elevation: 0,
              ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                  color: Get.theme.focusColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, -5)),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: MaterialButton(
                  elevation: 0,
                  onPressed: () {
                    controller.saveProfileForm(_profileForm);
                  },
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Get.theme.accentColor,
                  child: Text("Save".tr,
                      style: Get.textTheme.bodyText2
                          .merge(TextStyle(color: Get.theme.primaryColor))),
                ),
              ),
              SizedBox(width: 10),
              MaterialButton(
                elevation: 0,
                onPressed: () {
                  controller.resetProfileForm(_profileForm);
                },
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Get.theme.hintColor.withOpacity(0.1),
                child: Text("Reset".tr, style: Get.textTheme.bodyText2),
              ),
            ],
          ).paddingSymmetric(vertical: 10, horizontal: 20),
        ),
        body: Form(
            key: _profileForm,
            child: ListView(
              primary: true,
              children: [
                Text("Profile details".tr, style: Get.textTheme.headline5)
                    .paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
                Text("Change the following details and save them".tr,
                        style: Get.textTheme.caption)
                    .paddingSymmetric(horizontal: 22, vertical: 5),
                TextFieldWidget(
                  onSaved: (input) =>
                      controller.currentProfile.first_name = input,
                  validator: (input) => input.length < 3
                      ? "Should be more than 3 letters".tr
                      : null,
                  initialValue: controller.currentProfile.first_name,
                  hintText: "John Doe".tr,
                  labelText: "Firstname".tr,
                  iconData: Icons.person_outline,
                ),
                TextFieldWidget(
                  onSaved: (input) =>
                      controller.currentProfile.last_name = input,
                  validator: (input) => input.length < 3
                      ? "Should be more than 3 letters".tr
                      : null,
                  initialValue: controller.currentProfile.last_name,
                  hintText: "John Doe".tr,
                  labelText: "Lastname".tr,
                  iconData: Icons.person_outline,
                ),
                TextFieldWidget(
                  onSaved: (input) => controller.currentuser.email = input,
                  validator: (input) =>
                      !input.contains('@') ? "Should be a valid email" : null,
                  initialValue: controller.currentuser.email,
                  hintText: "johndoe@gmail.com",
                  labelText: "Email".tr,
                  iconData: Icons.alternate_email,
                ),

                TextFieldWidget(
                  onSaved: (input) =>
                      controller.currentProfile.home_address = input,
                  validator: (input) => input.length < 3
                      ? "Should be more than 3 letters".tr
                      : null,
                  initialValue: controller.currentProfile.home_address,
                  hintText: "home address".tr,
                  labelText: "Home address".tr,
                  iconData: Icons.person_outline,
                ),
                TextFieldWidget(
                    onSaved: (input) =>
                        controller.currentProfile.phone = int.parse(input),
                    validator: (input) =>
                        input.length < 3 ? "Should  8 numbers".tr : null,
                    initialValue: controller.currentProfile.phone.toString(),
                    hintText: "Phone number".tr,
                    labelText: "Phone number".tr,
                    iconData: Icons.phone),
                TextFieldWidget(
                  onSaved: (input) => controller
                      .currentProfile.social_media['facebook'] = input,
                  validator: (input) => input.length < 3
                      ? "Should be more than 3 chars".tr
                      : null,
                  initialValue:
                      controller.currentProfile.social_media['facebook'] ?? '',
                  hintText: "Facebook Account Username".tr,
                  labelText: "Facebook Account".tr,
                  iconData: Icons.facebook,
                ),
                TextFieldWidget(
                  onSaved: (input) => controller
                      .currentProfile.social_media['instagram'] = input,
                  validator: (input) => input.length < 3
                      ? "Should be more than 3 chars".tr
                      : null,
                  initialValue:
                      controller.currentProfile.social_media['instagram'],
                  hintText: "Instagram Account Username".tr,
                  labelText: "Instagram Account".tr,
                  iconData: Icons.message_rounded,
                ),

                // TextFieldWidget(
                //   keyboardType: TextInputType.phone,
                //   onSaved: (input) => controller.currentuser.value.phone = input,
                //   validator: (input) => !input.startsWith('+') && !input.startsWith('00') ? "Phone number must start with country code!".tr : null,
                //   initialValue: controller.currentuser.value.phone,
                //   hintText: "+1 565 6899 659",
                //   labelText: "Phone number".tr,
                //   iconData: Icons.phone_android_outlined,
                // ),
                // TextFieldWidget(
                //   onSaved: (input) => controller.currentuser.value.address = input,
                //   validator: (input) => input.length < 3 ? "Should be more than 3 letters".tr : null,
                //   initialValue: controller.currentuser.value.address,
                //   hintText: "123 Street, City 136, State, Country".tr,
                //   labelText: "Address".tr,
                //   iconData: Icons.map_outlined,
                // ),
                Text("Change password".tr, style: Get.textTheme.headline5)
                    .paddingOnly(top: 25, bottom: 0, right: 22, left: 22),
                Text(
                        "Fill your old password and type new password and confirm it"
                            .tr,
                        style: Get.textTheme.caption)
                    .paddingSymmetric(horizontal: 22, vertical: 5),
                Obx(() {
                  return TextFieldWidget(
                    labelText: "Old Password".tr,
                    hintText: "••••••••••••".tr,
                    obscureText: controller.hidePassword.value,
                    iconData: Icons.lock_outline,
                    keyboardType: TextInputType.visiblePassword,
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
                    isFirst: true,
                    isLast: false,
                  );
                }),
                Obx(() {
                  return TextFieldWidget(
                    labelText: "New Password".tr,
                    hintText: "••••••••••••".tr,
                    obscureText: controller.hidePassword.value,
                    iconData: Icons.lock_outline,
                    keyboardType: TextInputType.visiblePassword,
                    isFirst: false,
                    isLast: false,
                  );
                }),
                Obx(() {
                  return TextFieldWidget(
                    labelText: "Confirm New Password".tr,
                    hintText: "••••••••••••".tr,
                    obscureText: controller.hidePassword.value,
                    iconData: Icons.lock_outline,
                    keyboardType: TextInputType.visiblePassword,
                    isFirst: false,
                    isLast: true,
                  );
                }),
                GetBuilder<ProfileController>(
                    init: ProfileController(),
                    builder: (value) {
                      if (_currentProfile != null) {
                        return Column(
                          children: [
                            Text("Change Profile photo".tr,
                                    style: Get.textTheme.headline5)
                                .paddingOnly(
                                    top: 25, bottom: 0, right: 22, left: 22),
                            _currentProfile.profile_photo != null
                                ? Container(
                                    height: 300,
                                    child: Image.network(
                                        _currentProfile.profile_photo))
                                : Container(
                                    height: 300,
                                    child: Image.asset(
                                      'assets/img/helmet.png',
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 100,
                                    ),
                                  ),
                            Container(
                                child: FloatingActionButton(
                                    onPressed: () async {
                                      controller.changeImage();
                                    },
                                    child: Icon(Icons.camera_alt_outlined)))
                          ],
                        );
                      } else {
                        return SizedBox(
                          height: 50,
                        );
                      }
                    }),
              ],
            )));
  }
}
