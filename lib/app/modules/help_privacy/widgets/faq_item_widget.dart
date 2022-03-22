import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/faq_model.dart';

import '../../../../common/ui.dart';

class FaqItemWidget extends StatelessWidget {
  final Faq faq;

  FaqItemWidget({Key key, this.faq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: Ui.getBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            this.faq.question,
            style: Get.textTheme.bodyText2,
          ),
          Divider(
            height: 30,
            thickness: 1,
          ),
          Ui.applyHtml(this.faq.answer)
        ],
      ),
    );
  }
}
