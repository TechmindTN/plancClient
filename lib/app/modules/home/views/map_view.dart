import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/home_controller.dart';

class MapView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(
          init: HomeController(),
          builder: (v) {
            return Stack(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: GoogleMap(
                    compassEnabled: true,
                    indoorViewEnabled: true,
                    mapToolbarEnabled: true,
                    buildingsEnabled: true,
                    onMapCreated: ((control) {
                      print(
                          'list prov ' + v.providers_markers.value.toString());
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
                    markers: controller.providers_markers.value,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    initialCameraPosition:
                        Get.find<HomeController>().presentposition != null
                            ? CameraPosition(
                                tilt: 60,
                                zoom: 10,
                                target: LatLng(
                                    Get.find<HomeController>()
                                        .presentposition
                                        .latitude,
                                    Get.find<HomeController>()
                                        .presentposition
                                        .longitude))
                            : CameraPosition(
                                tilt: 60,
                                zoom: 10,
                                target: LatLng(36.80278, 10.17972))),
              ),
              Positioned(bottom: 20, left: 53, child: v.cards[0]),
            ]);
          }),
    );
  }
}
