import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/help_controller.dart';
import '../widgets/faq_item_widget.dart';

class HelpView extends GetView<HelpController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return DefaultTabController(
        length: controller.faqs.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Get.theme.accentColor,
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(color: Get.theme.primaryColor),
            bottom: TabBar(
              indicatorColor: Get.theme.primaryColor.withOpacity(0.6),
              indicatorWeight: 3,
              tabs: List.generate(controller.faqs.length, (index) {
                return Tab(
                    child: Text(
                  controller.faqs.elementAt(index).name ?? '',
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: Get.textTheme.bodyText2
                      .merge(TextStyle(color: Get.theme.primaryColor)),
                ));
              }),
              labelColor: Theme.of(context).primaryColor,
            ),
            title: Text(
              "Help & Faq".tr,
              style: Theme.of(context).textTheme.headline6.merge(TextStyle(
                  letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
            ),
            automaticallyImplyLeading: false,
            leading: new IconButton(
              icon:
                  new Icon(Icons.arrow_back_ios, color: Get.theme.primaryColor),
              onPressed: () => Get.back(),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              controller.refreshFaqs(showMessage: true);
            },
            child: TabBarView(
              children: List.generate(controller.faqs.length, (index) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text("Help & Support".tr, style: Get.textTheme.headline5),
                      Text("Most frequently asked questions".tr,
                              style: Get.textTheme.caption)
                          .paddingSymmetric(vertical: 5),
                      ListView.separated(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: controller.faqs.elementAt(index).faqs.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 15);
                        },
                        itemBuilder: (context, indexFaq) {
                          return FaqItemWidget(
                              faq: controller.faqs
                                  .elementAt(index)
                                  .faqs
                                  .elementAt(indexFaq));
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      );
    });
  }
}
