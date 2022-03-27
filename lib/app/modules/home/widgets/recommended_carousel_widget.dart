import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/Provider.dart';
import '../../../routes/app_pages.dart';
import '../../e_service/controllers/e_service_controller.dart';
import '../controllers/home_controller.dart';

class RecommendedCarouselWidget extends GetWidget<HomeController> {
  bool ok = false;
  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  EServiceController eServiceController = Get.find<EServiceController>();
  @override
  Widget build(BuildContext context) {
    if (!ok) {
      ok = true;
      rebuildAllChildren(context);
    }

    return Container(
        height: 345,
        color: Get.theme.primaryColor,
        child: ListView.builder(
            padding: EdgeInsets.only(bottom: 10),
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            // itemCount: controller.eServices.length,
            itemCount: controller.prov.length,
            itemBuilder: (_, index) {
              // var _service = controller.eServices.elementAt(index);
              var _service = controller.prov.elementAt(index);
              return GestureDetector(
                onTap: () {
                  eServiceController.serviceProvider.value = _service;
                  Get.toNamed(Routes.E_SERVICE, arguments: _service);
                },
                child: Container(
                  width: 160,
                  margin: EdgeInsetsDirectional.only(
                      end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
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
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          child: CachedNetworkImage(
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl: _service.profile_photo,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 100,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
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
                              _service.name,
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
                                Text(_service.description,
                                    style: Get.textTheme.bodyText1),
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
            }));
  }
}
