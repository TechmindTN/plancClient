import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/models/Provider.dart';
import 'package:home_services/app/routes/app_pages.dart';

import '../../../Network/BranchNetwork.dart';
import '../../../Network/UserNetwork.dart';
import '../../e_service/views/e_service_view.dart';

Widget RecWidget(_service, eServiceController) {
  //  var _service = controller.prov.elementAt(index);
  ServiceProvider provider = ServiceProvider.fromFire(_service);
  // eServiceController.getThisProvider(provider,_service['user'].id);
  UserNetwork userServices = UserNetwork();
  BranchNetwork branchServices = BranchNetwork();
  // provider.branches=await branchServices.getBranchListByProvider(provider.id);
  // provider.user=await userServices.getUserById(_service.id);

  // print(provider.branches.first.address);
  provider.id = _service.id;
  return GestureDetector(
    onTap: () {
      eServiceController.serviceProvider.value = provider;
      // Get.toNamed(Routes.E_SERVICE, arguments: provider);
      Get.to(EServiceView(provider));
    },
    child: Container(
      width: 160,
      // margin: EdgeInsetsDirectional.only(
      //     end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
      // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Get.theme.focusColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 5)),
        ],
      ),
      child: Column(
        //alignment: AlignmentDirectional.topStart,
        children: [
          Hero(
            tag: _service.id,
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                SizedBox(height: 10),
                Wrap(
                  children: [
                    Text(provider.description, style: Get.textTheme.bodyText1),
                    // Text(' - '),
                    // Text("\$" + _service.maxPrice.toString(), style: Get.textTheme.bodyText1),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
