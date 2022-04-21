import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/modules/home/widgets/recWidget.dart';

import '../../../Network/UserNetwork.dart';
import '../../../models/Provider.dart';
import '../../../routes/app_pages.dart';
import '../../e_service/controllers/e_service_controller.dart';
import '../controllers/home_controller.dart';
import 'categories_carousel_widget.dart';

class EntrepriseWidget extends GetWidget<HomeController> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference providersRef =
      FirebaseFirestore.instance.collection('Provider');
  EServiceController eServiceController = Get.find<EServiceController>();
  UserNetwork userServices = UserNetwork();

  List<Widget> recWidgets = [];
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 180,
        margin: EdgeInsets.only(bottom: 15),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                    child: Text("Categories".tr,
                        style: Get.textTheme.headline5
                            .merge(TextStyle(color: Get.theme.focusColor)))),
                MaterialButton(
                  elevation: 0,
                  onPressed: () {
                    Get.toNamed(Routes.CATEGORIES);
                  },
                  shape: StadiumBorder(),
                  color: Get.theme.accentColor.withOpacity(0.1),
                  child: Text("View All".tr, style: Get.textTheme.subtitle1),
                ),
              ],
            ),
          ),
          CategoriesCarouselWidget(),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(children: [
                Expanded(
                    child: Text("Recommended for you".tr,
                        style: Get.textTheme.headline5
                            .merge(TextStyle(color: Get.theme.focusColor)))),
              ])),
          GetBuilder<HomeController>(
              init: HomeController(),
              builder: (val) => Container(
                    height: 345,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: StreamBuilder(
                            stream: providersRef.snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Text(
                                  'No Data...',
                                );
                              } else {
                                val.allproviders = snapshot.data.docs;
                                val.list.clear();
                                for (var i = 0;
                                    i < snapshot.data.docs.length;
                                    i++) {
                                  for (var j = 0;
                                      j < val.entreprise.length;
                                      j++) {
                                    if (val.entreprise[j].id ==
                                        snapshot.data.docs[i]
                                            .data()['user']
                                            .id) {
                                      val.list.add(snapshot.data.docs[i]);
                                      continue;
                                    }
                                  }
                                }
                                if (val.list.isEmpty) {
                                  return CircularProgressIndicator();
                                } else {
                                  return ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: val.list.length,
                                      itemBuilder: ((context, index) {
                                        // ServiceProvider provider =
                                        //     ServiceProvider.fromFire(
                                        //         snapshot.data.docs[index]);
                                        //  eServiceController.getThisProvider(provider,snapshot.data.docs[index].id);

                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: RecWidget(val.list[index],
                                              eServiceController),
                                        );
                                      }));
                                }
                              }
                            }),
                      ),
                    ),
                  )),
        ]));
  }
}
