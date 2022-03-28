import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/slide_model.dart';

import '../../../Network/ServiceProviderNetwork.dart';
import '../../../global_widgets/home_search_bar_widget.dart';
import '../../../global_widgets/notifications_button_widget.dart';
import '../../../models/Provider.dart';
import '../../../routes/app_pages.dart';
import '../../../services/settings_service.dart';
import '../../e_service/controllers/e_service_controller.dart';
import '../controllers/home_controller.dart';
import '../widgets/address_widget.dart';
import '../widgets/categories_carousel_widget.dart';
import '../widgets/featured_categories_widget.dart';
import '../widgets/recWidget.dart';
import '../widgets/recommended_carousel_widget.dart';
import '../widgets/slide_item_widget.dart';

class Home2View extends GetView<HomeController> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference providersRef =
      FirebaseFirestore.instance.collection('Provider');
    EServiceController eServiceController = Get.find<EServiceController>();
List<Widget> recWidgets=[];
  @override
  Widget build(BuildContext context) {

    // eServiceController.providers.forEach(((element) {
    //   recWidgets.add(RecWidget(element, eServiceController));
    //   controller.update();
    // }));

    // for(int i=0;i<eServiceController.providers.length;i++){
    //    recWidgets.add(RecWidget(eServiceController.providers[i], eServiceController));
    //   controller.update();
    // }
          controller.update();

    // print(controller.)
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            controller.refreshHome(showMessage: true);
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 280,
                elevation: 0.5,
                // pinned: true,
                floating: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                title: Text(
                  "Plan C",
                  // Get.find<SettingsService>().setting.value.appName,
                  style: Get.textTheme.headline6,
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: new IconButton(
                  icon: new Icon(Icons.sort, color: Colors.black87),
                  onPressed: () => {Scaffold.of(context).openDrawer()},
                ),
                actions: [NotificationsButtonWidget()],
                bottom: HomeSearchBarWidget(),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: 
                  // Obx(() {
                     Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: <Widget>[
                        CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 7),
                            height: 310,
                            viewportFraction: 1.0,
                            onPageChanged: (index, reason) {
                              controller.currentSlide.value = index;
                            },
                          ),
                          items: controller.slider.map((Slide slide) {
                            return SlideItemWidget(slide: slide);
                          }).toList(),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 70, horizontal: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: controller.slider.map((Slide slide) {
                              return Container(
                                width: 20.0,
                                height: 5.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 20.0, horizontal: 2.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    color: controller.currentSlide.value ==
                                            controller.slider.indexOf(slide)
                                        ? Colors.black87
                                        : Colors.black87.withOpacity(0.4)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    )
                  // }),
                ).marginOnly(bottom: 42),
              ),

              // WelcomeWidget(),
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    AddressWidget(),
                    Image.asset("assets/img/banner2.jpg"),

                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text("Categories".tr,
                                  style: Get.textTheme.headline5)),
                          MaterialButton(
                            elevation: 0,
                            onPressed: () {
                              Get.toNamed(Routes.CATEGORIES);
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.accentColor.withOpacity(0.1),
                            child: Text("View All".tr,
                                style: Get.textTheme.subtitle1),
                          ),
                        ],
                      ),
                    ),
                    CategoriesCarouselWidget(),
                    Container(
                      color: Get.theme.primaryColor,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text("Recommended for you".tr,
                                  style: Get.textTheme.headline5)),
                          MaterialButton(
                            elevation: 0,
                            onPressed: () {},
                            shape: StadiumBorder(),
                            color: Get.theme.accentColor.withOpacity(0.1),
                            child: Text("View All".tr,
                                style: Get.textTheme.subtitle1),
                          ),
                        ],
                      ),
                    ),
                    // for(var rec in recWidgets)
                    // rec,
                    // RecommendedCarouselWidget(),
                    Container(
                      height: 345,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: StreamBuilder(
    stream: providersRef.snapshots(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return Text(
          'No Data...',
        );
      } else { 
          // DocumentSnapshot items = snapshot.data.documents;
          return  ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.docs.length,
            itemBuilder: ((context, index) {

                        ServiceProvider provider=ServiceProvider.fromFire(snapshot.data.docs[index]);
                              //  eServiceController.getThisProvider(provider,snapshot.data.docs[index].id);
                               
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal:16.0),
              child: RecWidget(snapshot.data.docs[index], eServiceController),
            );
          }));
      }}
                        ),
                      ),),
                    ),
                    Image.asset("assets/img/banner3.png"),

                    // FeaturedCategoriesWidget(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
