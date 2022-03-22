import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/e_provider_model.dart';
import 'package:home_services/app/their_models/media_model.dart';

import '../../../../common/ui.dart';
import '../../../global_widgets/circular_loading_widget.dart';

import '../../../routes/app_pages.dart';
import '../controllers/e_provider_controller.dart';
import '../widgets/e_provider_til_widget.dart';
import '../widgets/e_provider_title_bar_widget.dart';
import '../widgets/featured_carousel_widget.dart';
import '../widgets/review_item_widget.dart';

class EProviderView extends GetView<EProviderController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var _eProvider = controller.eProvider.value;
      if (!_eProvider.hasData) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return Scaffold(
          // bottomNavigationBar: buildBlockButtonWidget(_eService),
          body: RefreshIndicator(
              onRefresh: () async {
                controller.refreshEProvider(showMessage: true);
              },
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    expandedHeight: 320,
                    elevation: 0,
                    // pinned: true,
                    floating: true,
                    iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: new IconButton(
                      icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                      onPressed: () => {Get.back()},
                    ),
                    bottom: buildEProviderTitleBarWidget(_eProvider),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Obx(() {
                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: <Widget>[
                            buildCarouselSlider(_eProvider),
                            buildCarouselBullets(_eProvider),
                          ],
                        );
                      }),
                    ).marginOnly(bottom: 50),
                  ),

                  // WelcomeWidget(),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        buildContactUs(),
                        //buildCategories(_eService),
                        EProviderTilWidget(
                          title: Text("Description".tr, style: Get.textTheme.subtitle2),
                          content: Text(_eProvider.about, style: Get.textTheme.bodyText1),
                        ),
                        EProviderTilWidget(
                          horizontalPadding: 0,
                          title: Text("Featured Services".tr, style: Get.textTheme.subtitle2).paddingSymmetric(horizontal: 20),
                          content: RecommendedCarouselWidget(),
                          actions: [
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.E_PROVIDER_E_SERVICES, arguments: _eProvider);
                              },
                              child: Text("View All".tr, style: Get.textTheme.subtitle1),
                            ).paddingSymmetric(horizontal: 20),
                          ],
                        ),
                        EProviderTilWidget(
                          horizontalPadding: 0,
                          title: Text("Galleries".tr, style: Get.textTheme.subtitle2).paddingSymmetric(horizontal: 20),
                          content: Container(
                            height: 120,
                            child: ListView.builder(
                                primary: false,
                                shrinkWrap: false,
                                scrollDirection: Axis.horizontal,
                                itemCount: _eProvider.media.length,
                                itemBuilder: (_, index) {
                                  var _media = _eProvider.media.elementAt(index);
                                  return InkWell(
                                    onTap: () {
                                      // TODO show fullscreen gallery
                                      //Get.toNamed(Routes.CATEGORY, arguments: _category);
                                    },
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 10, bottom: 10),
                                      child: Stack(
                                        alignment: AlignmentDirectional.topStart,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            child: CachedNetworkImage(
                                              height: 100,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              imageUrl: _media.thumb,
                                              placeholder: (context, url) => Image.asset(
                                                'assets/img/loading.gif',
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 100,
                                              ),
                                              errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.only(start: 12, top: 8),
                                            child: Text(
                                              _media.name ?? '',
                                              maxLines: 2,
                                              style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          actions: [
                            InkWell(
                              onTap: () {
                                // TODO show all galleries
                                // Get.toNamed(Routes.Galleries, argument, eProvider);
                              },
                              child: Text("View All".tr, style: Get.textTheme.subtitle1).paddingSymmetric(horizontal: 20),
                            ),
                          ],
                        ),
                        EProviderTilWidget(
                          title: Text("Reviews & Ratings".tr, style: Get.textTheme.subtitle2),
                          content: Column(
                            children: [
                              Text(_eProvider.rate.toString(), style: Get.textTheme.headline1),
                              Wrap(
                                children: Ui.getStarsList(_eProvider.rate, size: 32),
                              ),
                              Text(
                                "Reviews (%s)".trArgs([_eProvider.totalReviews.toString()]),
                                style: Get.textTheme.caption,
                              ).paddingOnly(top: 10),
                              Divider(height: 35, thickness: 1.3),
                              Obx(() {
                                if (controller.reviews.isEmpty) {
                                  return CircularLoadingWidget(height: 100);
                                }
                                return ListView.separated(
                                  padding: EdgeInsets.all(0),
                                  itemBuilder: (context, index) {
                                    return ReviewItemWidget(review: controller.reviews.elementAt(index));
                                  },
                                  separatorBuilder: (context, index) {
                                    return Divider(height: 35, thickness: 1.3);
                                  },
                                  itemCount: controller.reviews.length,
                                  primary: false,
                                  shrinkWrap: true,
                                );
                              }),
                            ],
                          ),
                          actions: [
                            InkWell(
                              onTap: () {
                                // Get.offAllNamed(Routes.REGISTER);
                              },
                              child: Text("View All".tr, style: Get.textTheme.subtitle1),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        );
      }
    });
  }

  Container buildContactUs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Contact us".tr, style: Get.textTheme.subtitle2),
                Text("If your have any question!".tr, style: Get.textTheme.caption),
              ],
            ),
          ),
          Wrap(
            spacing: 5,
            children: [
              MaterialButton(
                elevation: 0,
                onPressed: () {
                  //controller.saveProfileForm(_profileForm);
                },
                height: 44,
                minWidth: 44,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.accentColor.withOpacity(0.2),
                child: Icon(
                  Icons.phone_android_outlined,
                  color: Get.theme.accentColor,
                ),
              ),
              MaterialButton(
                elevation: 0,
                onPressed: () {
                  //controller.saveProfileForm(_profileForm);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                color: Get.theme.accentColor.withOpacity(0.2),
                padding: EdgeInsets.zero,
                height: 44,
                minWidth: 44,
                child: Icon(
                  Icons.chat_outlined,
                  color: Get.theme.accentColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  CarouselSlider buildCarouselSlider(EProvider _eProvider) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        height: 350,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          controller.currentSlide.value = index;
        },
      ),
      items: _eProvider.media.map((Media media) {
        return Builder(
          builder: (BuildContext context) {
            return Hero(
              tag: _eProvider.id,
              child: CachedNetworkImage(
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
                imageUrl: media.url,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Container buildCarouselBullets(EProvider _eProvider) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 92, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _eProvider.media.map((Media media) {
          return Container(
            width: 20.0,
            height: 5.0,
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: controller.currentSlide.value == _eProvider.media.indexOf(media) ? Get.theme.hintColor : Get.theme.primaryColor.withOpacity(0.4)),
          );
        }).toList(),
      ),
    );
  }

  EProviderTitleBarWidget buildEProviderTitleBarWidget(EProvider _eProvider) {
    return EProviderTitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _eProvider.name,
                  style: Get.textTheme.headline5,
                ),
              ),
              if (_eProvider.available)
                Container(
                  child: Text("Available".tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyText2.merge(
                        TextStyle(color: Colors.green, height: 1.4, fontSize: 10),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
              if (!_eProvider.available)
                Container(
                  child: Text("Offline".tr,
                      maxLines: 1,
                      style: Get.textTheme.bodyText2.merge(
                        TextStyle(color: Colors.grey, height: 1.4, fontSize: 10),
                      ),
                      softWrap: false,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: List.from(Ui.getStarsList(_eProvider.rate))
                    ..addAll([
                      SizedBox(width: 5),
                      Text(
                        "Reviews (%s)".trArgs([_eProvider.totalReviews.toString()]),
                        style: Get.textTheme.caption,
                      ),
                    ]),
                ),
              ),
              Text(
                "Tasks (%s)".trArgs([_eProvider.tasksInProgress.toString()]),
                style: Get.textTheme.caption,
              ),
              // Ui.getPrice(
              //   _eService.minPrice,
              //   style: Get.textTheme.headline3.merge(TextStyle(color: Get.theme.accentColor)),
              //   unit: _eService.pricing != 'fixed' ? "/h".tr : null,
              // ),
            ],
          ),
        ],
      ),
    );
  }

// Widget buildCategories(EService _eService) {
//   return Padding(
//     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//     child: Wrap(
//       alignment: WrapAlignment.start,
//       spacing: 5,
//       runSpacing: 8,
//       children: List.generate(_eService.categories.length, (index) {
//         var _category = _eService.categories.elementAt(index);
//         return Container(
//           padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//           child: Text(_category.name, style: Get.textTheme.bodyText1.merge(TextStyle(color: _category.color))),
//           decoration: BoxDecoration(
//               color: _category.color.withOpacity(0.2),
//               border: Border.all(
//                 color: _category.color.withOpacity(0.1),
//               ),
//               borderRadius: BorderRadius.all(Radius.circular(20))),
//         );
//       }) +
//           List.generate(_eService.subCategories.length, (index) {
//             return Container(
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//               child: Text(_eService.subCategories.elementAt(index).name, style: Get.textTheme.caption),
//               decoration: BoxDecoration(
//                   color: Get.theme.primaryColor,
//                   border: Border.all(
//                     color: Get.theme.focusColor.withOpacity(0.2),
//                   ),
//                   borderRadius: BorderRadius.all(Radius.circular(20))),
//             );
//           }),
//     ),
//   );
// }
//
// Widget buildBlockButtonWidget(EService _eService) {
//   return Container(
//     padding: EdgeInsets.symmetric(vertical: 20),
//     decoration: BoxDecoration(
//       color: Get.theme.primaryColor,
//       borderRadius: BorderRadius.all(Radius.circular(20)),
//       boxShadow: [
//         BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -5)),
//       ],
//     ),
//     child: BlockButtonWidget(
//         text: Stack(
//           alignment: AlignmentDirectional.centerEnd,
//           children: [
//             SizedBox(
//               width: double.infinity,
//               child: Text(
//                 "Book This Service".tr,
//                 textAlign: TextAlign.center,
//                 style: Get.textTheme.headline6.merge(
//                   TextStyle(color: Get.theme.primaryColor),
//                 ),
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios, color: Get.theme.primaryColor, size: 20)
//           ],
//         ),
//         color: Get.theme.accentColor,
//         onPressed: () {
//           Get.toNamed(Routes.BOOK_E_SERVICE, arguments: _eService);
//         }).paddingOnly(right: 20, left: 20),
//   );
// }
}
