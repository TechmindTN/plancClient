import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
// import 'package:google_maps_place_picker/google_maps_place_picker.dart';

import '../../../Network/MediaNetwork.dart';
import '../../../global_widgets/map_select_widget.dart';
import '../../../models/Provider.dart';
import '../../../routes/app_pages.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../e_service/views/e_service_view.dart';
import '../controllers/home_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../views/map_view.dart';

class AddressWidget extends GetWidget<HomeController> {
  MediaNetwork mediaServices = MediaNetwork();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        child: Row(children: [
          Icon(Icons.place_outlined),
          SizedBox(width: 10),
          Get.find<AuthController>().currentuser != null
              ? Expanded(
                  child: Obx(() {
                    return Text(
                        controller.presentAddress.value ?? "Loading...".tr,
                        style: Get.textTheme.subtitle1);
                  }),
                )
              : Expanded(child: Text(' Look at providers location ')),
          SizedBox(width: 10),
          IconButton(
              icon: Icon(Icons.gps_fixed),
              onPressed: () async {
                controller.cards.clear();
                controller.allproviders.forEach((snap) async {
                  var _service = ServiceProvider.fromFire(snap.data());
                  _service.id = snap.id;
                  print('serviceeeeee' + _service.name);
                  print('serviceeeeee' + _service.location.toString());

                  if (_service.location != null) {
                    print('service here ' +
                        _service.name +
                        ' lat ' +
                        _service.location.latitude.toString() +
                        ' long ' +
                        _service.location.longitude.toString());
                    controller.cards.add(ServiceMapCard(context, _service));
                    controller.providers_markers.add(Marker(
                        consumeTapEvents: true,
                        infoWindow: InfoWindow(
                          title: _service.name,
                          snippet: 'Téléphone: ' + _service.phone.toString(),
                          // onTap: () {
                          //   print('service id ' + _service.id);
                          //   //
                          //   // _service.printProvider();
                          //   // Get.to(EServiceView(_service));
                          // },
                        ),
                        onTap: () async {
                          if (controller.cards.length > 0) {
                            controller.cards.clear();
                            controller.cards.add(
                              ServiceMapCard(
                                context,
                                _service,
                              ),
                            );
                            print(controller.cards.length);
                          }
                          controller.update();
                        },
                        markerId: MarkerId(_service.name),
                        position: LatLng(_service.location.latitude,
                            _service.location.longitude)));
                  }
                });
                print('card list ' + controller.cards.toString());
                Get.to(MapView());
              })
        ]));
  }

  Widget ServiceMapCard(context, ServiceProvider service) {
    final double width = MediaQuery.of(context).size.width * 0.7;
    final double height = 200;
    final Color borderColor = Color(0xffE2E2E2);
    final double borderRadius = 20;
    return InkWell(
      borderRadius: BorderRadius.circular(
        borderRadius,
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EServiceView(service),
            ));
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                spreadRadius: 2,
                blurRadius: 20,
                offset: Offset(2, 6))
          ],
          color: Colors.white,
          border: Border.all(
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(
            borderRadius,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: imageWidget(service),
                ),
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(height: 10),
              Text(service.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )),
              Text(service.address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF7C7C7C),
                  )),
              SizedBox(
                height: 10,
              ),
              // Center(
              //   child: AppText(
              //     textAlign: TextAlign.center,
              //     text: store.opentime.toDate().hour.toString()+":"+
              //     store.opentime.toDate().minute.toString()+"h ~ "+
              //     store.closetime.toDate().hour.toString()+":"+
              //     store.closetime.toDate().minute.toString()+"h",
              //     fontSize: 18,
              //     fontWeight: FontWeight.w600,
              //     color: AppColors.primaryColor,
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              Row(
                children: [
                  // AppText(
                  //   text: "\$${item.price.toStringAsFixed(2)}",
                  //   fontSize: 18,
                  //   fontWeight: FontWeight.bold,
                  // ),
                  Spacer(),
                  // addWidget()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget imageWidget(ServiceProvider service) {
    return Container(
      child: Image.network(service.profile_photo, width: 500, height: 500),
    );
  }
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
      

