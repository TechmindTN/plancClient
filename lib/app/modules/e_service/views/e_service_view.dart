import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/e_service_model.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../../common/ui.dart';
import '../../../Network/MediaNetwork.dart';
import '../../../Network/UserNetwork.dart';
import '../../../global_widgets/block_button_widget.dart';
import '../../../global_widgets/circular_loading_widget.dart';

import '../../../models/Media.dart';
import '../../../models/Provider.dart';
import '../../../routes/app_pages.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../messages/views/chats_view.dart';
import '../controllers/e_service_controller.dart';
import '../widgets/e_provider_item_widget.dart';
import '../widgets/e_service_til_widget.dart';
import '../widgets/e_service_title_bar_widget.dart';
import '../widgets/review_item_widget.dart';

class EServiceView extends GetView<EServiceController> {
  final ServiceProvider prov;

  EServiceView(
    this.prov,
  );

  @override
  Widget build(BuildContext context) {
    MediaNetwork mediaServices = MediaNetwork();
    UserNetwork _userNetwork = UserNetwork();
    print('name: ' + prov.name);
    print('id: ' + prov.id);
    List<dynamic> images = [];
    // List<String> images = [
    //   'assets/img/1.png',
    //   'assets/img/2.png',
    //   'assets/img/3.png',
    //   'assets/img/4.png',
    //   'assets/img/5.png',
    //   'assets/img/6.png',
    //   'assets/img/7.png',
    //   'assets/img/8.png',
    // ];

    // Obx(() {
    // var provider = controller.serviceProvider;
    images = prov.media;

    // List<dynamic> images =prov.media;
    // if (!provider.isBlank) {
    //   return Scaffold(
    //     body: CircularLoadingWidget(height: Get.height),
    //   );
    // } else {
    return Scaffold(
        bottomNavigationBar: buildBlockButtonWidget(prov),
        body: CustomScrollView(
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
                icon:
                    new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
                onPressed: () => {Get.back()},
              ),
              bottom: buildEServiceTitleBarWidget(prov),
              flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background:
                      // Obx(() {
                      Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Image.network(prov.profile_photo)
                      // buildCarouselSlider(provider),
                      // buildCarouselBullets(provider),
                    ],
                  )
                  // }),
                  ).marginOnly(bottom: 50),
            ),

            // WelcomeWidget(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10),

                  // buildCategories(provider),
                  EServiceTilWidget(
                    title:
                        Text("Description".tr, style: Get.textTheme.subtitle2),
                    content:
                        Text(prov.description, style: Get.textTheme.bodyText1),
                  ),

                  EServiceTilWidget(
                    title: Text("Contact".tr, style: Get.textTheme.subtitle2),
                    content: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(prov.phone.toString() ?? '12345678',
                                style: Get.textTheme.bodyText1),
                            Icon(Icons.phone_outlined)
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Add a message',
                                style: Get.textTheme.bodyText1),
                            IconButton(
                                icon: Icon(Icons.message),
                                onPressed: () async {
                                  var list = [];

                                  var ref1 = await _userNetwork
                                      .getUserRef(prov.user.id);
                                  var ref2 = await _userNetwork.getUserRef(
                                      Get.find<AuthController>()
                                          .currentuser
                                          .id);

                                  list.add(ref1);
                                  list.add(ref2);

                                  var ok = await controller.verifyChat(list);

                                  if (ok == null) {
                                    FirebaseFirestore.instance
                                        .collection('Chat')
                                        .add({
                                      "createdAt": Timestamp.now(),
                                      "users": list
                                    }).then((value) => Get.to(ChatsView(
                                              chat_id: value.id,
                                              user: prov.user,
                                              provider: prov,
                                            )));
                                  } else {
                                    Get.find<MessagesController>()
                                        .receiver
                                        .add(prov.user);
                                    Get.find<MessagesController>()
                                        .receiver_provider
                                        .add(prov);
                                    Get.to(ChatsView(
                                      chat_id: ok,
                                      user: prov.user,
                                      provider: prov,
                                    ));
                                  }
                                })
                          ],
                        ),
                        //   Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text(prov.user.email,
                        //         style: Get.textTheme.bodyText1),
                        //         Icon(Icons.email_outlined)
                        //   ],
                        // ),
                      ],
                    ),
                  ),

                  EServiceTilWidget(
                    title: Text("Address".tr, style: Get.textTheme.subtitle2),
                    content: Text(prov.address ?? '123 Centre Urbain Nord',
                        style: Get.textTheme.bodyText1),
                  ),

                  // EServiceTilWidget(
                  //   title: Text("Service Provider".tr, style: Get.textTheme.subtitle2),
                  //   content: EProviderItemWidget(provider: _eService.eProvider),
                  //   actions: [
                  //     GestureDetector(
                  //       onTap: () {
                  //         Get.toNamed(Routes.E_PROVIDER, arguments: _eService.eProvider);
                  //       },
                  //       child: Text("View More".tr, style: Get.textTheme.subtitle1),
                  //     ),
                  //   ],
                  // ),
                  EServiceTilWidget(
                    horizontalPadding: 0,
                    title: Text("Galleries".tr, style: Get.textTheme.subtitle2)
                        .paddingSymmetric(horizontal: 20),
                    content: Container(
                      height: 120,
                      child: FutureBuilder(
                          future: mediaServices.getMediaListByProvider(prov.id),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                  child: Container(
                                      child: CircularProgressIndicator()));
                            } else {
                              List<Media> img = snapshot.data;
                              return ListView.builder(
                                  primary: false,
                                  shrinkWrap: false,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: img.length,
                                  itemBuilder: (_, index) {
                                    // var _media = _eService.media.elementAt(index);
                                    var media = img[index];
                                    return InkWell(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                  insetPadding:
                                                      EdgeInsets.all(0),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Container(
                                                    color: Colors.transparent
                                                        .withOpacity(0.3),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.7,
                                                    child: Image.network(
                                                      media.url,
                                                      // scale: 20,

                                                      fit: BoxFit.fill,
                                                      // width: MediaQuery.of(context).size.width*0.9,
                                                      // height: MediaQuery.of(context).size.height*0.8,

                                                      // scale: 0.1,
                                                    ),
                                                  ));
                                            });
                                        //Get.toNamed(Routes.CATEGORY, arguments: _category);
                                      },
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        margin: EdgeInsetsDirectional.only(
                                            end: 20,
                                            start: index == 0 ? 20 : 0,
                                            top: 10,
                                            bottom: 10),
                                        child: Stack(
                                          alignment:
                                              AlignmentDirectional.topStart,
                                          children: [
                                            ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                                child: Image.network(
                                                  img[index].url,
                                                  height: 100,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                )
                                                // child: CachedNetworkImage(
                                                //   height: 100,
                                                //   width: double.infinity,
                                                //   fit: BoxFit.cover,
                                                //   imageUrl: media,
                                                //   placeholder: (context, url) => Image.asset(
                                                //     'assets/img/loading.gif',
                                                //     fit: BoxFit.cover,
                                                //     width: double.infinity,
                                                //     height: 100,
                                                //   ),
                                                //   errorWidget: (context, url, error) => Icon(Icons.error_outline),
                                                // ),
                                                ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .only(start: 12, top: 8),
                                              child: Text(
                                                'Item' ?? '',
                                                maxLines: 2,
                                                style: Get.textTheme.bodyText2
                                                    .merge(TextStyle(
                                                        color: Get.theme
                                                            .primaryColor)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }
                          }),
                    ),
                    actions: [
                      InkWell(
                        onTap: () {
                          // Get.offAllNamed(Routes.REGISTER);
                        },
                        child:
                            Text("View All".tr, style: Get.textTheme.subtitle1),
                      ).paddingSymmetric(horizontal: 20),
                    ],
                  ),
                  EServiceTilWidget(
                    title:
                        Text("Social Media".tr, style: Get.textTheme.subtitle2),
                    content: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Website".tr, style: Get.textTheme.bodyText1),
                            Text(prov.website, style: Get.textTheme.bodyText1),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Facebook".tr, style: Get.textTheme.bodyText1),
                            Text(prov.social_media['Facebook'] ?? prov.name,
                                style: Get.textTheme.bodyText1),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Instagram".tr,
                                style: Get.textTheme.bodyText1),
                            Text(prov.social_media['Instagram'] ?? prov.name,
                                style: Get.textTheme.bodyText1),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("LinkedIn".tr, style: Get.textTheme.bodyText1),
                            Text(prov.social_media['LinkedIn'] ?? prov.name,
                                style: Get.textTheme.bodyText1),
                          ],
                        ),
                      ],
                    ),
                  ),
                  EServiceTilWidget(
                    title: Text("Reviews & Ratings".tr,
                        style: Get.textTheme.subtitle2),
                    content: Column(
                      children: [
                        Text(prov.rate.toString(),
                            style: Get.textTheme.headline1),
                        Wrap(children: [
                          SmoothStarRating(
                            rating: prov.rate,
                            isReadOnly: false,
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
                          ),
                        ]),
                        Divider(height: 35, thickness: 1.3),
                        Obx(() {
                          if (controller.reviews.isEmpty) {
                            return CircularLoadingWidget(height: 100);
                          }
                          return ListView.separated(
                            padding: EdgeInsets.all(0),
                            itemBuilder: (context, index) {
                              return ReviewItemWidget(
                                  review: controller.reviews.elementAt(index));
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
                        child:
                            Text("View All".tr, style: Get.textTheme.subtitle1),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
    // }
    // });
  }

  // CarouselSlider buildCarouselSlider(ServiceProvider provider) {
  //   return CarouselSlider(
  //     options: CarouselOptions(
  //       autoPlay: true,
  //       autoPlayInterval: Duration(seconds: 7),
  //       height: 350,
  //       viewportFraction: 1.0,
  //       onPageChanged: (index, reason) {
  //         controller.currentSlide.value = index;
  //       },
  //     ),
  //     items: _eService.media.map((Media media) {
  //       return Builder(
  //         builder: (BuildContext context) {
  //           return Hero(
  //             tag: _eService.id,
  //             child: CachedNetworkImage(
  //               width: double.infinity,
  //               height: 350,
  //               fit: BoxFit.cover,
  //               imageUrl: media.url,
  //               placeholder: (context, url) => Image.asset(
  //                 'assets/img/loading.gif',
  //                 fit: BoxFit.cover,
  //                 width: double.infinity,
  //               ),
  //               errorWidget: (context, url, error) => Icon(Icons.error_outline),
  //             ),
  //           );
  //         },
  //       );
  //     }).toList(),
  //   );
  // }

  // Container buildCarouselBullets(EService _eService) {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 92, horizontal: 20),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       children: _eService.media.map((Media media) {
  //         return Container(
  //           width: 20.0,
  //           height: 5.0,
  //           margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.all(
  //                 Radius.circular(10),
  //               ),
  //               color: controller.currentSlide.value == _eService.media.indexOf(media) ? Get.theme.hintColor : Get.theme.primaryColor.withOpacity(0.4)),
  //         );
  //       }).toList(),
  //     ),
  //   );
  // }

  EServiceTitleBarWidget buildEServiceTitleBarWidget(ServiceProvider provider) {
    return EServiceTitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  provider.name,
                  style: Get.textTheme.headline5,
                ),
              ),
              // Text(
              //   "Start from".tr,
              //   style: Get.textTheme.caption,
              // ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: SmoothStarRating(
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
              )),

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

  Widget buildCategories(EService _eService) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 5,
        runSpacing: 8,
        children: List.generate(_eService.categories.length, (index) {
              var _category = _eService.categories.elementAt(index);
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_category.name,
                    style: Get.textTheme.bodyText1
                        .merge(TextStyle(color: _category.color))),
                decoration: BoxDecoration(
                    color: _category.color.withOpacity(0.2),
                    border: Border.all(
                      color: _category.color.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            }) +
            List.generate(_eService.subCategories.length, (index) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(_eService.subCategories.elementAt(index).name,
                    style: Get.textTheme.caption),
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    border: Border.all(
                      color: Get.theme.focusColor.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              );
            }),
      ),
    );
  }

  Widget buildBlockButtonWidget(ServiceProvider provider) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Get.theme.focusColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5)),
        ],
      ),
      child: BlockButtonWidget(
          text: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Book This Service".tr,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.headline6.merge(
                    TextStyle(color: Get.theme.primaryColor),
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: Get.theme.primaryColor, size: 20)
            ],
          ),
          color: Get.theme.accentColor,
          onPressed: () {
            if (Get.find<AuthController>().currentuser.email != null) {
              Get.toNamed(Routes.BOOK_E_SERVICE, arguments: provider);
            } else {
              Get.showSnackbar(
                  Ui.ErrorSnackBar(message: 'You must login before !'));
            }
          }).paddingOnly(right: 20, left: 20),
    );
  }
}
