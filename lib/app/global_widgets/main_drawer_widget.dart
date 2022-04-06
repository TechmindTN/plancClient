/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/ui.dart';
import '../models/Client.dart';
import '../models/User.dart';
import '../modules/auth/controllers/auth_controller.dart';
import '../modules/root/controllers/root_controller.dart' show RootController;
import '../routes/app_pages.dart';
import '../services/settings_service.dart';
import 'drawer_link_widget.dart';

class MainDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthController _authController = Get.find<AuthController>();
    _authController.update();
    User user = _authController.currentuser;
    return Drawer(
      child: ListView(
        children: [
          GestureDetector(
            onTap: () {
              //currentUser.value.apiToken != null ? Navigator.of(context).pushNamed('/Profile') : Navigator.of(context).pushNamed('/Login');
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome".tr,
                      style: Get.textTheme.headline5.merge(
                          TextStyle(color: Theme.of(context).accentColor))),
                  SizedBox(height: 5),
                  user.email == null
                      ? Text("Login account or create new one for free".tr,
                          style: Get.textTheme.bodyText1)
                      : Text("Want to Logout ?".tr,
                          style: Get.textTheme.bodyText1),
                  SizedBox(height: 15),
                  user.email == null
                      ? Wrap(
                          spacing: 10,
                          children: <Widget>[
                            MaterialButton(
                              elevation: 0,
                              onPressed: () {
                                Get.offAndToNamed(Routes.LOGIN);
                              },
                              color: Get.theme.accentColor,
                              height: 40,
                              child: Wrap(
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 9,
                                children: [
                                  Icon(Icons.exit_to_app_outlined,
                                      color: Get.theme.primaryColor, size: 24),
                                  Text(
                                    "Login".tr,
                                    style: Get.textTheme.subtitle1.merge(
                                        TextStyle(
                                            color: Get.theme.primaryColor)),
                                  ),
                                ],
                              ),
                              shape: StadiumBorder(),
                            ),
                            MaterialButton(
                              elevation: 0,
                              color: Get.theme.focusColor.withOpacity(0.2),
                              height: 40,
                              onPressed: () {
                                Get.offAllNamed(Routes.REGISTER);
                              },
                              child: Wrap(
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 9,
                                children: [
                                  Icon(Icons.person_add_outlined,
                                      color: Get.theme.hintColor, size: 24),
                                  Text(
                                    "Register".tr,
                                    style: Get.textTheme.subtitle1.merge(
                                        TextStyle(color: Get.theme.hintColor)),
                                  ),
                                ],
                              ),
                              shape: StadiumBorder(),
                            ),
                          ],
                        )
                      : Wrap(
                          spacing: 10,
                          children: <Widget>[
                            MaterialButton(
                              elevation: 0,
                              onPressed: () {
                                Get.find<AuthController>().currentuser = User();
                                Get.find<AuthController>().currentProfile =
                                    Client();
                                _authController.update();
                                Get.offAllNamed(Routes.ROOT);
                              },
                              color: Get.theme.accentColor,
                              height: 40,
                              child: Wrap(
                                runAlignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 9,
                                children: [
                                  Icon(Icons.exit_to_app_outlined,
                                      color: Get.theme.primaryColor, size: 24),
                                  Text(
                                    "Logout".tr,
                                    style: Get.textTheme.subtitle1.merge(
                                        TextStyle(
                                            color: Get.theme.primaryColor)),
                                  ),
                                ],
                              ),
                              shape: StadiumBorder(),
                            ),
                          ],
                        )
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          DrawerLinkWidget(
            icon: Icons.home_outlined,
            text: "Home",
            onTap: (e) {
              Get.back();
              Get.find<RootController>().changePage(0);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.folder_special_outlined,
            text: "Categories",
            onTap: (e) {
              Get.offAndToNamed(Routes.CATEGORIES);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.assignment_outlined,
            text: "Bookings",
            onTap: (e) {
              if (user.email == null) {
                Get.showSnackbar(
                    Ui.ErrorSnackBar(message: 'You must login before !'));
                return null;
              } else {
                Get.back();
                Get.find<RootController>().changePage(1);
              }
            },
          ),
          DrawerLinkWidget(
            icon: Icons.notifications_none_outlined,
            text: "Notifications",
            onTap: (e) {
              if (user.email == null) {
                Get.showSnackbar(
                    Ui.ErrorSnackBar(message: 'You must login before !'));
                return null;
              } else {
                Get.offAndToNamed(Routes.NOTIFICATIONS);
              }
            },
          ),
          DrawerLinkWidget(
            icon: Icons.favorite_outline,
            text: "Favorites",
            onTap: (e) {
              if (user.email == null) {
                Get.showSnackbar(
                    Ui.ErrorSnackBar(message: 'You must login before !'));
                return null;
              } else {
                Get.offAndToNamed(Routes.FAVORITES);
              }
            },
          ),
          DrawerLinkWidget(
            icon: Icons.chat_outlined,
            text: "Messages",
            onTap: (e) {
              if (user.email == null) {
                Get.showSnackbar(
                    Ui.ErrorSnackBar(message: 'You must login before !'));
                return null;
              } else {
                Get.back();
                Get.find<RootController>().changePage(2);
              }
            },
          ),
          ListTile(
            dense: true,
            title: Text(
              "Application preferences".tr,
              style: Get.textTheme.caption,
            ),
            trailing: Icon(
              Icons.remove,
              color: Get.theme.focusColor.withOpacity(0.3),
            ),
          ),
          DrawerLinkWidget(
            icon: Icons.person_outline,
            text: "Account",
            onTap: (e) {
              if (user.email == null) {
                Get.showSnackbar(
                    Ui.ErrorSnackBar(message: 'You must login before !'));
                return null;
              } else {
                Get.back();
                Get.find<RootController>().changePage(3);
              }
            },
          ),
          DrawerLinkWidget(
            icon: Icons.settings_outlined,
            text: "Settings",
            onTap: (e) {
              Get.offAndToNamed(Routes.SETTINGS);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.translate_outlined,
            text: "Languages",
            onTap: (e) {
              Get.offAndToNamed(Routes.SETTINGS_LANGUAGE);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.brightness_6_outlined,
            text: Get.isDarkMode ? "Light Theme" : "Dark Theme",
            onTap: (e) {
              Get.offAndToNamed(Routes.SETTINGS_THEME_MODE);
            },
          ),
          ListTile(
            dense: true,
            title: Text(
              "Help & Privacy",
              style: Get.textTheme.caption,
            ),
            trailing: Icon(
              Icons.remove,
              color: Get.theme.focusColor.withOpacity(0.3),
            ),
          ),
          DrawerLinkWidget(
            icon: Icons.help_outline,
            text: "Help & FAQ",
            onTap: (e) {
              Get.offAndToNamed(Routes.HELP);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.privacy_tip_outlined,
            text: "Privacy Policy",
            onTap: (e) {
              Get.offAndToNamed(Routes.PRIVACY);
            },
          ),
          user.email != null
              ? DrawerLinkWidget(
                  icon: Icons.logout,
                  text: "Logout",
                  onTap: (e) {
                    Get.offAllNamed(Routes.LOGIN);
                  },
                )
              : SizedBox(),
          if (Get.find<SettingsService>().setting.value.enableVersion)
            ListTile(
              dense: true,
              title: Text(
                "Version".tr +
                    " " +
                    Get.find<SettingsService>().setting.value.appVersion,
                style: Get.textTheme.caption,
              ),
              trailing: Icon(
                Icons.remove,
                color: Get.theme.focusColor.withOpacity(0.3),
              ),
            )
        ],
      ),
    );
  }
}
