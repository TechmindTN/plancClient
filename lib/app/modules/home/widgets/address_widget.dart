import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
// import 'package:google_maps_place_picker/google_maps_place_picker.dart';

import '../../../global_widgets/map_select_widget.dart';
import '../../../models/Provider.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressWidget extends StatelessWidget {
  TextEditingController _address;
  AuthController _authController = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.place_outlined),
          SizedBox(width: 10),
          Expanded(
            child: Obx(() {
              return Text(
                  Get.find<HomeController>().presentAddress.value ??
                      "Loading...".tr,
                  style: Get.textTheme.bodyText1);
            }),
          ),
          SizedBox(width: 10),
          IconButton(
              icon: Icon(Icons.gps_fixed),
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        buttonPadding: EdgeInsets.all(0),
                        actionsPadding: EdgeInsets.all(0),
                        content: GetBuilder<AuthController>(builder: (control) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: GoogleMap(
                                compassEnabled: true,
                                indoorViewEnabled: true,
                                mapToolbarEnabled: true,
                                buildingsEnabled: true,
                                onMapCreated: ((controller) {
                                  var l = [];
                                  l = Get.find<HomeController>().list +
                                      Get.find<HomeController>().list1;
                                  Get.find<HomeController>()
                                      .prov
                                      .forEach((_service) {
                                    print('serviceeeeee' + _service.name);
                                    print('serviceeeeee' +
                                        _service.location.toString());

                                    if (_service.location != null) {
                                      print('location' +
                                          _service.location.toString());
                                      control.providers_markers.add(Marker(
                                          infoWindow: InfoWindow(
                                              title: _service.name,
                                              snippet: _service.description),
                                          markerId: MarkerId('value'),
                                          position: LatLng(
                                              _service.location.latitude,
                                              _service.location.longitude)));
                                      control.update();
                                    }
                                  });
                                }),
                                mapType: MapType.normal,
                                onTap: (argument) {
                                  // if (_authController.markers.length > 0) {
                                  //   _authController.markers.clear();
                                  //   _authController.update();
                                  // }
                                  // _authController.markers.add(Marker(
                                  //     markerId: MarkerId('value'),
                                  //     position: LatLng(argument.latitude,
                                  //         argument.longitude)));
                                  // _authController.position = LatLng(
                                  //     argument.latitude, argument.longitude);
                                  // _authController.update();
                                },
                                markers: _authController.providers_markers,
                                myLocationButtonEnabled: true,
                                myLocationEnabled: true,
                                initialCameraPosition: CameraPosition(
                                    tilt: 60,
                                    zoom: 10,
                                    target: LatLng(
                                        Get.find<HomeController>()
                                            .presentposition
                                            .latitude,
                                        Get.find<HomeController>()
                                            .presentposition
                                            .longitude))),
                          );
                        }),
                      );
                    });
              }
/*              LocationResult result = await showLocationPicker(context, Get.find<SettingsService>().setting.value.googleMapsKey,
                  initialCenter: Get.find<AuthService>().address.value.getLatLng(),
                  automaticallyAnimateToCurrentLocation: false,
                  myLocationButtonEnabled: true,
                  layersButtonEnabled: true,
                  language: Get.locale.languageCode,
                  desiredAccuracy: LocationAccuracy.best,
                  appBarColor: Get.theme.primaryColor);
              print("result = $result");
              Get.find<AuthService>().address.update((val) {
                val.address = result.address;
                val.latitude = result.latLng.latitude;
                val.longitude = result.latLng.longitude;
              });*/

              // return PlacePicker(
              //   apiKey: Get.find<SettingsService>().setting.value.googleMapsKey,
              //   initialPosition: Get.find<AuthService>().address.value.getLatLng(),
              //   useCurrentLocation: true,
              //   selectInitialPosition: true,
              //   usePlaceDetailSearch: true,
              //   onPlacePicked: (result) {
              //     Get.find<AuthService>().address.update((val) {
              //       val.address = result.formattedAddress;
              //       val.latitude = result.geometry.location.lat;
              //       val.longitude = result.geometry.location.lng;
              //     });
              //     Get.back();
              //   },
              //   //forceSearchOnZoomChanged: true,
              //   //automaticallyImplyAppBarLeading: false,
              //   //autocompleteLanguage: "ko",
              //   //region: 'au',
              //   //selectInitialPosition: true,
              //   // selectedPlaceWidgetBuilder: (_, selectedPlace, state, isSearchBarFocused) {
              //   //   print("state: $state, isSearchBarFocused: $isSearchBarFocused");
              //   //   return isSearchBarFocused
              //   //       ? Container()
              //   //       : FloatingCard(
              //   //           bottomPosition: 0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
              //   //           leftPosition: 0.0,
              //   //           rightPosition: 0.0,
              //   //           width: 500,
              //   //           borderRadius: BorderRadius.circular(12.0),
              //   //           child: state == SearchingState.Searching
              //   //               ? Center(child: CircularProgressIndicator())
              //   //               : RaisedButton(
              //   //                   child: Text("Pick Here"),
              //   //                   onPressed: () {
              //   //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
              //   //                     //            this will override default 'Select here' Button.
              //   //                     print("do something with [selectedPlace] data");
              //   //                     Navigator.of(context).pop();
              //   //                   },
              //   //                 ),
              //   //         );
              //   // },
              //   // pinBuilder: (context, state) {
              //   //   if (state == PinState.Idle) {
              //   //     return Icon(Icons.favorite_border);
              //   //   } else {
              //   //     return Icon(Icons.favorite);
              //   //   }
              //   // },
              // );
              )
        ],
      ),
    );
  }
}
