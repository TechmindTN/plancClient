import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../../common/ui.dart';
import '../../../Network/UserNetwork.dart';
import '../../../global_widgets/block_button_widget.dart';
import '../../../services/auth_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/feedback_controller.dart';

class RatingView extends GetView<FeedbackController> {
  double rate = 0.0;
  String review = '';
  UserNetwork _userNetwork = UserNetwork();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rating".tr,
          style: Get.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: ListView(
        primary: true,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 60),
              margin: EdgeInsets.only(bottom: 20),
              width: Get.width,
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Get.theme.focusColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5)),
                ],
              ),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(children: [
                      Text("Hi,".tr),
                      Text(
                        Get.find<AuthController>().currentuser.email,
                        style: Get.textTheme.bodyText2
                            .merge(TextStyle(color: Get.theme.accentColor)),
                      )
                    ]),
                    SizedBox(height: 10),
                    Text(
                      "How do you feel this services?".tr,
                      style: Get.textTheme.bodyText1,
                    ),
                    SizedBox(height: 30),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                        imageUrl: controller.task.value.provider.profile_photo,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 70,
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error_outline),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      controller.task.value.provider.name,
                      style: Get.textTheme.headline6,
                    ),
                    SizedBox(height: 30),
                    // Wrap(
                    //   spacing: 8,
                    //   children: Ui.getStarsList(4.5, size: 38),
                    // ),
                    // SizedBox(height: 10),
                    // Text(
                    //   "Great!".tr,
                    //   style: Get.textTheme.bodyText1,
                    // ),
                    Center(
                        child: Expanded(
                            child: SmoothStarRating(
                      rating: 0,
                      isReadOnly: false,
                      size: 40,
                      borderColor: Colors.yellow[700],
                      filledIconData: Icons.star,
                      halfFilledIconData: Icons.star_half,
                      defaultIconData: Icons.star_border,
                      starCount: 5,
                      allowHalfRating: true,
                      spacing: 2.0,
                      color: Colors.yellow[700],
                      onRated: (value) {
                        print("rating value -> $value");
                        rate = value;
                        // print("rating value dd -> ${value.truncate()}");
                      },
                    ))),
                    SizedBox(height: 20),
                    TextField(
                      onChanged: (text) {
                        review = text;
                        print(review);
                        // _con.productsReviews[index].review = text;
                      },
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(12),
                        hintText: "Tell us somethings about this service".tr,
                        hintStyle: Get.textTheme.caption
                            .merge(TextStyle(fontSize: 14)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Get.theme.focusColor.withOpacity(0.1))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Get.theme.focusColor.withOpacity(0.2))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Get.theme.focusColor.withOpacity(0.1))),
                      ),
                    ),
                  ],
                ),
              )),
          Align(
            alignment: Alignment.center,
            child: BlockButtonWidget(
                text: Text(
                  "Done".tr,
                  style: Get.textTheme.headline6
                      .merge(TextStyle(color: Get.theme.primaryColor)),
                ),
                color: Get.theme.accentColor,
                onPressed: () async {
                  var ref = await _userNetwork
                      .getUserRef(Get.find<AuthController>().currentuser.id);
                  FirebaseFirestore.instance
                      .collection("Provider")
                      .doc(controller.task.value.provider.id)
                      .collection("Review")
                      .add({"user": ref, "rate": rate, "review": review});
                  Get.back();
                }),
          )
        ],
      ),
    );
  }
}
