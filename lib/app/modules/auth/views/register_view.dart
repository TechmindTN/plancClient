import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../global_widgets/block_button_widget.dart';
import '../../../global_widgets/text_field_widget.dart';
import '../../../their_models/setting_model.dart';
import '../../../routes/app_pages.dart';
import '../../../services/settings_service.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  // final _currentUser = Get.find<AuthService>().user;
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Register".tr,
          style: Get.textTheme.headline6.merge(TextStyle(color: context.theme.primaryColor)),
        ),
        centerTitle: true,
        backgroundColor: Get.theme.accentColor,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: ListView(
        primary: true,
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Container(
                height: 160,
                width: Get.width,
                decoration: BoxDecoration(
                  color: Get.theme.accentColor,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(color: Get.theme.focusColor.withOpacity(0.2), blurRadius: 10, offset: Offset(0, 5)),
                  ],
                ),
                margin: EdgeInsets.only(bottom: 50),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        _settings.appName,
                        style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor, fontSize: 24)),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Welcome to the best service provider system!".tr,
                        style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor)),
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
          TextFieldWidget(
            labelText: "Email Address".tr,
            hintText: "johndoe@gmail.com".tr,
            iconData: Icons.alternate_email,
            isFirst: true,
            isLast: false,
          ),
          TextFieldWidget(
            labelText: "Phone Number".tr,
            hintText: "+1 223 665 7896".tr,
            iconData: Icons.phone_android_outlined,
            isLast: false,
            isFirst: false,
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
              suffixIcon: IconButton(
                onPressed: () {
                  controller.hidePassword.value = !controller.hidePassword.value;
                },
                color: Theme.of(context).focusColor,
                icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
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
            );
          }),
        ],
      ),
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
                  onPressed: () {
                    Get.offAllNamed(Routes.PHONE_VERIFICATION);
                  },
                  color: Get.theme.accentColor,
                  text: Text(
                    "Register".tr,
                    style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor)),
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
