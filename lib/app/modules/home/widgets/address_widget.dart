import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_maps_place_picker/google_maps_place_picker.dart';

import '../../../global_widgets/map_select_widget.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';

class AddressWidget extends StatelessWidget {
  TextEditingController _address;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.place_outlined),
          SizedBox(width: 10),
          Expanded(
              child: TextFormField(
                  initialValue:
                      Get.find<AuthController>().currentProfile.home_address ??
                          'Address',
                  controller: _address,
                  maxLines: 1,
                  readOnly: true,

                  // Get.find<AuthService>().address.value?.address ??
                  //     "Loading...".tr,
                  style: Get.textTheme.bodyText1)),
          SizedBox(width: 10),
          IconButton(
              icon: Icon(Icons.gps_fixed),
              onPressed: () async {
                GetBuilder<AuthController>(builder: (_authController) {
                  return MapSelect(context, _authController, _address);
                });
              }),
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
        ],
      ),
    );
  }
}
