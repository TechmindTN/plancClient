import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../global_widgets/block_button_widget.dart';
import '../../../services/auth_service.dart';
import '../controllers/rating_controller.dart';

class RatingView extends GetView<RatingController> {
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
                        Get.find<AuthService>().user.value.email,
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
                        imageUrl: controller.task.value.eService.profile_photo,
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
                      controller.task.value.eService.name,
                      style: Get.textTheme.headline6,
                    ),
                    SizedBox(height: 30),
                    Wrap(
                      spacing: 8,
                      children: Ui.getStarsList(4.5, size: 38),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Great!".tr,
                      style: Get.textTheme.bodyText1,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      onChanged: (text) {
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
                onPressed: () {
                  Get.back();
                }),
          )
        ],
      ),
    );
  }
}
