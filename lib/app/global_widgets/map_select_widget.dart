import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../common/ui.dart';
import '../modules/auth/controllers/auth_controller.dart';

Widget MapSelect(context, AuthController profileController,
    TextEditingController addresscontrol) {
  return InkWell(
    onTap: () {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                InkWell(
                  onTap: () async {
                    AuthController profileController =
                        Get.find<AuthController>();
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                        profileController.position.latitude,
                        profileController.position.longitude);
                    profileController.marks = placemarks;
                    addresscontrol.text = placemarks.first.country +
                        ", " +
                        placemarks.first.administrativeArea +
                        ", " +
                        placemarks.first.subAdministrativeArea +
                        ", " +
                        placemarks.first.street;
                    profileController.update();
                    print(placemarks.length);

                    placemarks.forEach((element) {
                      print(element.country);
                      print(element.administrativeArea);
                      // print(element.isoCountryCode);
                      // print(element.locality);
                      // print(element.name);
                      // print(element.postalCode);
                      print(element.street);
                      print(element.subAdministrativeArea);
                      // print(element.subLocality);
                      // print(element.subThoroughfare);
                      // print(element.thoroughfare);
                      //  Navigator.pop(context);
                    });
                    profileController.update();

                    Navigator.pop(context);
                    profileController.update();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(4)),
                      color: Get.theme.accentColor,
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.height * 0.05,
                    child: Center(
                      child: Text(
                        "Confirm".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
                // TextButton(onPressed: (){}, child: Text("Confirm".tr))
                // TextButton(onPressed: (){}, child: Text("Confirm".tr))
              ],
              buttonPadding: EdgeInsets.all(0),
              actionsPadding: EdgeInsets.all(0),
              content: GetBuilder<AuthController>(builder: (controller) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: GoogleMap(
                      compassEnabled: true,
                      indoorViewEnabled: true,
                      mapToolbarEnabled: true,
                      buildingsEnabled: true,
                      onMapCreated: ((controller) {
                        profileController.markers.clear();
                      }),
                      mapType: MapType.normal,
                      onTap: (argument) {
                        if (profileController.markers.length > 0) {
                          profileController.markers.clear();
                          profileController.update();
                        }
                        profileController.markers.add(Marker(
                            markerId: MarkerId('value'),
                            position:
                                LatLng(argument.latitude, argument.longitude)));
                        profileController.position =
                            LatLng(argument.latitude, argument.longitude);
                        profileController.update();
                      },
                      markers: profileController.markers,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      initialCameraPosition: CameraPosition(
                          tilt: 60,
                          zoom: 16,
                          target: LatLng(36.844283, 10.2032505))),
                );
              }),
            );
          });
      print("got you address");
    },
    child: Container(
      height: MediaQuery.of(context).size.height * 0.12,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 20, bottom: 14, left: 20, right: 20),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 14),
      decoration: BoxDecoration(
          color: Get.theme.primaryColor,
          // borderRadius: buildBorderRadius,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Get.theme.focusColor.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5)),
          ],
          border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(
          "Address".tr,
          style: Get.textTheme.bodyText1,
          textAlign: TextAlign.start,
        ),
        Container(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.1,
              maxWidth: MediaQuery.of(context).size.width),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.05,
          child: TextFormField(
            enabled: false,

            controller: addresscontrol,
            keyboardType: TextInputType.text,
            // onSaved: onSaved,
            // validator: validator,
            // initialValue: initialValue ?? '',
            style: Get.textTheme.bodyText2,
            obscureText: false,
            textAlign: TextAlign.start,
            decoration: Ui.getInputDecoration(
              hintText: 'Choose your address'.tr,
              // iconData: Icons.map,
              suffixIcon: Icon(Icons.pin_drop),
            ),
          ),
        ),
      ]),
    ),
  );
}
