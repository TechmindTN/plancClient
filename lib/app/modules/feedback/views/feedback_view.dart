import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import '../../../../common/ui.dart';
import '../../../Network/UserNetwork.dart';
import '../../auth/controllers/auth_controller.dart';
import '../controllers/feedback_controller.dart';

class FeedbackView extends GetView<FeedbackController> {
  TextEditingController description = TextEditingController();
  double rate;
  UserNetwork _userNetwork = UserNetwork();
  final formGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Feedback".tr,
          style: Get.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => {Get.back()},
        ),
      ),
      body: Container(
          child: Form(
        key: formGlobalKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 20,
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "What do you think about our app ?".tr,
                  style: TextStyle(fontWeight: FontWeight.w900),
                )),
            SizedBox(
              height: 10,
            ),

            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/img/feedback.png',
                width: 150,
              ),
            ),

            SizedBox(
              height: 15,
            ),
            Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  decoration: InputDecoration(hintText: "Write here".tr),
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  controller: description,
                )),
            SizedBox(
              height: 50,
            ),
            Center(
                child: Expanded(
                    child: SmoothStarRating(
              rating: 0,
              isReadOnly: false,
              size: 40,
              borderColor: Ui.parseColor('#00B6BF'),
              filledIconData: Icons.star,
              halfFilledIconData: Icons.star_half,
              defaultIconData: Icons.star_border,
              starCount: 5,
              allowHalfRating: true,
              spacing: 2.0,
              color: Ui.parseColor('#00B6BF'),
              onRated: (value) {
                print("rating value -> $value");
                rate = value;
                // print("rating value dd -> ${value.truncate()}");
              },
            ))),
            SizedBox(
              height: 30,
            ),
            Container(
              child: ElevatedButton(
                onPressed: () async {
                  DocumentReference ref = await _userNetwork
                      .getUserRef(Get.find<AuthController>().currentuser.id);
                  var data = {
                    "user": ref,
                    "message": description.text,
                    "rate": rate ?? 0
                  };
                  await FirebaseFirestore.instance
                      .collection('Feedback')
                      .add(data);
                },
                child: Text('Send'),
              ),
            )

            // Ui.getPrice(
            //   _eService.minPrice,
            //   style: Get.textTheme.headline3.merge(TextStyle(color: Get.theme.accentColor)),
            //   unit: _eService.pricing != 'fixed' ? "/h".tr : null,
            // ),
          ],
        ),
      )),
    );
  }
}
