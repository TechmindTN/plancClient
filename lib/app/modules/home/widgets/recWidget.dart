import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/models/Provider.dart';
import 'package:home_services/app/routes/app_pages.dart';

import '../../../Network/BranchNetwork.dart';
import '../../../Network/MediaNetwork.dart';
import '../../../Network/UserNetwork.dart';
import '../../e_service/views/e_service_view.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

Widget RecWidget(_service, eServiceController, {String id}) {
  //  var _service = controller.prov.elementAt(index);
  ServiceProvider provider = ServiceProvider.fromFire(_service);
  UserNetwork userServices = UserNetwork();
  BranchNetwork branchServices = BranchNetwork();
  MediaNetwork mediaServices = MediaNetwork();
  userServices
      .getUserById(_service["user"].id)
      .then((value) => provider.user = value);
  // provider.branches=await branchServices.getBranchListByProvider(provider.id);
  userServices
      .getUserById(_service['user'].id)
      .then((val) => provider.user = val);

  // print(provider.branches.first.address);
  if (id == null) {
    provider.id = _service.id;
  } else {
    provider.id = id;
  }
  return GestureDetector(
    onTap: () async {
      // provider.media = await mediaServices.getMediaListByProvider(provider.id);
      eServiceController.serviceProvider.value = provider;
      // Get.toNamed(Routes.E_SERVICE, arguments: provider);
      Get.to(EServiceView(provider));
    },
    child: Container(
      width: 155,
      // margin: EdgeInsetsDirectional.only(
      //     end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.01),
            blurRadius: 2,
            spreadRadius: 1,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        //alignment: AlignmentDirectional.topStart,
        children: [
          Hero(
            tag: provider.id,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: CachedNetworkImage(
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                imageUrl: provider.profile_photo,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 100,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            height: 115,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Get.theme.primaryColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  provider.name,
                  // _service.title,
                  maxLines: 2,
                  style: Get.textTheme.bodyText2
                      .merge(TextStyle(color: Get.theme.hintColor)),
                ),
                // Wrap(
                //   children: Ui.getStarsList(_service.rate),
                // ),
                Wrap(children: [
                  Text(provider.description, style: Get.textTheme.bodyText1),
                  // Text(' - '),
                  // Text("\$" + _service.maxPrice.toString(), style: Get.textTheme.bodyText1),
                ]),
                SmoothStarRating(
                  rating: provider.rate,
                  isReadOnly: true,
                  size: 20,
                  filledIconData: Icons.star,
                  halfFilledIconData: Icons.star_half,
                  defaultIconData: Icons.star_border,
                  starCount: 5,
                  allowHalfRating: true,
                  spacing: 2.0,
                  color: Colors.orange,
                  onRated: (value) {
                    print("rating value -> $value");
                    // print("rating value dd -> ${value.truncate()}");
                  },
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
