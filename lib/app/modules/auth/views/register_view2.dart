import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/modules/auth/views/register_view.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/ui.dart';
import '../../../global_widgets/block_button_widget.dart';
import '../../../global_widgets/map_select_widget.dart';
import '../../../global_widgets/text_field_widget.dart';
import '../../../models/Client.dart';
import '../../../models/User.dart';
import '../../../their_models/setting_model.dart';
import '../../../routes/app_pages.dart';
import '../../../services/settings_service.dart';
import '../controllers/auth_controller.dart';

class RegisterView2 extends GetView<AuthController> {
  // final _currentUser = Get.find<AuthService>().user;
  final Setting _settings = Get.find<SettingsService>().setting.value;
  // AuthController _authController = AuthController();

  String _firstname = '';
  String _lastname = '';
  String _phone = '';
  String _country;
  String _address;
  String _zipcode;
  String _city;
  String _state;
  String age;
  TextEditingController _addressmap = TextEditingController();
  Map<String, String> _Social = {"facebook": '', "instagram": ''};
  final formGlobalKey = GlobalKey<FormState>();
  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      controller.im.value = Image.file(File(pickedFile.path));
      controller.update();
    }
  }
  final ScrollController scrollController=ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   // if(controller.file!=null&&!controller.file.isBlank&&controller.file.path!=''){
      //                   scrollController.animateTo(scrollController.position.maxScrollExtent-2, duration: Duration(seconds: 1), curve: Curves.easeIn);
      //                 // }
      //   },),
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
      body: ListView(
        controller: scrollController,
        // primary: true, 
        children: [
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 50,
              ),
              getImageHeaderWidget(context,scrollController),
              // _image != null
              //     ? SizedBox(width: 80, height: 80, child: Image.file(_image))
              //     : SizedBox(height: 80, width: 80),
              // ElevatedButton(
              //   onPressed: () {
              //     _getFromGallery();
              //     print(_image);
              //   },
              //   child: Text("Pick profile_photo"),
              // ),
              Container(
                height: 40.0,
              ),
              TextFieldWidget(
                labelText: "Firstname".tr,
                hintText: "john".tr,
                iconData: Icons.text_fields,
                isFirst: true,
                isLast: false,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'field is empty'.tr;
                  }
                  _firstname = text;
                  return null;
                },
              ),
              TextFieldWidget(
                labelText: "Lastname".tr,
                hintText: "doe".tr,
                iconData: Icons.text_fields,
                isLast: false,
                isFirst: false,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'field is empty'.tr;
                  }
                  _lastname = text;
                  return null;
                },
              ),
              Obx(() => Container(
                  padding:
                      EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Get.theme.focusColor.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                      border: Border.all(
                          color: Get.theme.focusColor.withOpacity(0.05))),
                  child: Row(children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: controller.gender.value,
                        icon: const Icon(Icons.arrow_drop_down),
                        style: TextStyle(color: Ui.parseColor('#00B6BF')),
                        underline: Container(
                          height: 2,
                          color: Ui.parseColor('#00B6BF'),
                        ),
                        onChanged: (String newValue) {
                          controller.gender.value = newValue;
                          controller.update();
                        },
                        items: <String>[
                          'Male',
                          'Female',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ]))),
              // TextFieldWidget(
              //   labelText: "Age".tr,
              //   hintText: "##".tr,
              //   keyboardType: TextInputType.number,
              //   iconData: Icons.numbers,
              //   isLast: false,
              //   isFirst: false,
              //   validator: (text) {
              //     if (text == null || text.isEmpty) {
              //       return 'field is empty'.tr;
              //     }
              //     age = text;
              //     return null;
              //   },
              // ),
              TextFieldWidget(
                labelText: "Phone Number".tr,
                hintText: "+1 223 665 7896".tr,
                keyboardType: TextInputType.phone,
                iconData: Icons.phone_android_outlined,
                isLast: false,
                isFirst: false,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'field is empty'.tr;
                  }
                  _phone = text;
                  return null;
                },
              ),
              // GetBuilder<AuthController>(builder: (_authController) {
              //   return MapSelect(context, _authController, _addressmap);
              // }),

              // TextFieldWidget(
              //   labelText: "Facebook Account".tr,
              //   hintText: "facebook username".tr,
              //   keyboardType: TextInputType.name,
              //   iconData: Icons.facebook,
              //   isLast: false,
              //   isFirst: false,
              //   validator: (text) {
              //     if (text == null || text.isEmpty) {
              //       return 'field is empty'.tr;
              //     }
              //     _Social["facebook"] = text;
              //     return null;
              //   },
              // ),
              // TextFieldWidget(
              //   labelText: "Instagram Account".tr,
              //   hintText: "Instagram username".tr,
              //   keyboardType: TextInputType.name,
              //   iconData: Icons.messenger_rounded,
              //   isLast: false,
              //   isFirst: false,
              //   validator: (text) {
              //     if (text == null || text.isEmpty) {
              //       return 'field is empty'.tr;
              //     }
              //     _Social["instagram"] = text;
              //     return null;
              //   },
              // ),
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
                child: GetBuilder<AuthController>(
                  builder: (controller) {
                    return (!controller.loading)?BlockButtonWidget(
                      onPressed: () async {
                        controller.loading=true;
                        controller.update();
                        if (formGlobalKey.currentState.validate()) {
                          
                          DocumentReference user = controller.dataref;
                          var token = await FirebaseMessaging.instance.getToken();

                          Client c = Client(
                              first_name: _firstname,
                              last_name: _lastname,
                              phone: (int.parse(_phone)),
                              home_address: null,
                              // _addressmap.text,
                              location: null, 
                              // GeoPoint(controller.position.latitude,
                              //     controller.position.longitude),
                              social_media: null, 
                              // _Social,
                              gender: controller.gender.value,
                              fcmToken: token,
                              age:null, 
                              // int.parse(age)
                              );
                          var data = await controller.registerClient(c, user);
                          if (await controller.verifylogin(
                                  controller.u1.email??controller.currentuser.email, controller.u1.password??controller.currentuser.password) ==
                              true) {
                                controller.loading=false;
                        controller.update();
                            Get.offAllNamed(Routes.ROOT);
                          } else {
                            controller.loading=false;
                        controller.update();
                            final snack = SnackBar(
                              content: Text('Problem while registering !'),
                              backgroundColor: Colors.orangeAccent,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snack);
                          }
                        }
                      },
                      color: Get.theme.accentColor,
                      text: Text(
                        "Register".tr,
                        style: Get.textTheme.headline6
                            .merge(TextStyle(color: Get.theme.primaryColor)),
                      ),
                    ).paddingOnly(top: 15, bottom: 5, right: 20, left: 20):Center(child: CircularProgressIndicator());
                  }
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget getImageHeaderWidget(context,ScrollController scrollController) {
    return Container(
      height: 350,
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.blue,
        gradient: new LinearGradient(
            colors: [
              const Color(0xFF3366FF).withOpacity(0.1),
              const Color(0xFF3366FF).withOpacity(0.09),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(0.0, 1.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: GetBuilder<AuthController>(
          init: AuthController(),
          builder: (value) => Column(children: [
                Container(
                    constraints: BoxConstraints(maxHeight: 200),
                    child: controller.im.value),

                //
                //         Container(
                //         height: 150,
                //         child: Image(
                //   image: NetworkImage(store.image,

                //   ),
                // ),
                //       ),
                SizedBox(height: 20),
                FloatingActionButton(
                    onPressed: () async {
                      showModalBottomSheet(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height*0.2
                        ),
                        context: context, builder: (context){
                        return Column(
                          children: [
                            ListTile(
                              onTap: (){
                                controller.changeImage();
                      
                      Future.delayed(Duration(seconds: 5),(){
                        if(controller.file!=null&&controller.file.path!=''){
                        print('got image');
                        scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeIn);
                      }
                      });
                      controller.update();
                      Navigator.pop(context);
                              },
                              leading: Icon(Icons.photo),
                              title: Text("From Gallery"),

                            ),
                            ListTile(
                              onTap: (){
                                controller.changeCameraImage();
                      
                      Future.delayed(Duration(seconds: 5),(){
                        if(controller.file!=null&&controller.file.path!=''){
                        print('got image');
                        scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(seconds: 1), curve: Curves.easeIn);
                      }
                      });
                      controller.update();
                      Navigator.pop(context);
                              },
                              leading: Icon(Icons.camera_alt),
                              title: Text("From Camera"),

                            ),
                          ],
                        );
                      });
                      

                      // storeimage.printInfo();
                      //     final ImagePicker _picker = ImagePicker();

                      //     final XFile image = await _picker.pickImage(source: ImageSource.gallery);
                      //     File im=File(image.path);
                      //     storeimage=Image.file(im);
                      //       storeimage=Container(
                      //         height: 150,
                      //         child: Image(
                      //   image: FileImage(im,

                      //   ),
                      // ),
                      //       );
                      //    print(storeimage);
                      //   storecontrol.update();
                    },
                    child: Icon(Icons.add))
              ])),
    );
  }

  // Widget addImageHeaderWidget(AuthController control) {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
  //     width: double.maxFinite,
  //     decoration: BoxDecoration(
  //       color: Colors.blue,
  //       gradient: new LinearGradient(
  //           colors: [
  //             const Color(0xFF3366FF).withOpacity(0.1),
  //             const Color(0xFF3366FF).withOpacity(0.09),
  //           ],
  //           begin: const FractionalOffset(0.0, 0.0),
  //           end: const FractionalOffset(0.0, 1.0),
  //           stops: [0.0, 1.0],
  //           tileMode: TileMode.clamp),
  //     ),
  //     child: Column(children: [
  //       Column(
  //         children: [
  //           for (var img in control.iml) img,
  //         ],
  //       ),
  //       //
  //       //         Container(
  //       //         height: 150,
  //       //         child: Image(
  //       //   image: NetworkImage(store.image,

  //       //   ),
  //       // ),
  //       //       ),
  //       SizedBox(height: 20),
  //       FloatingActionButton(
  //           onPressed: () async {
  //             control.addImage();
  //             control.update();
  //             // storeimage.printInfo();
  //             //     final ImagePicker _picker = ImagePicker();

  //             //     final XFile image = await _picker.pickImage(source: ImageSource.gallery);
  //             //     File im=File(image.path);
  //             //     storeimage=Image.file(im);
  //             //       storeimage=Container(
  //             //         height: 150,
  //             //         child: Image(
  //             //   image: FileImage(im,

  //             //   ),
  //             // ),
  //             //       );
  //             //    print(storeimage);
  //             //   storecontrol.update();
  //           },
  //           child: Icon(Icons.camera))
  //     ]),
  //   );
  // }
}
