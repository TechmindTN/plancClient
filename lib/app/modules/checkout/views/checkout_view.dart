import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/block_button_widget.dart';
import '../../../models/Provider.dart';
import '../../../their_models/task_model.dart';
import '../../../routes/app_pages.dart';
import '../controllers/checkout_controller.dart';
import '../widgets/payment_details_widget.dart';
import '../widgets/payment_method_item_widget.dart';

class CheckoutView extends GetView<CheckoutController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout".tr,
          style: context.textTheme.headline6,
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
      body: GetBuilder<CheckoutController>(
        init: CheckoutController(),
        builder: (value) =>
            ListView(padding: EdgeInsets.symmetric(vertical: 10), children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              leading: Icon(
                Icons.payment,
                color: Get.theme.hintColor,
              ),
              title: Text(
                "Payment Option".tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Get.textTheme.headline5,
              ),
              subtitle: Text("Select your preferred payment mode".tr,
                  style: Get.textTheme.caption),
            ),
          ),
          if (controller.paymentsList.length > 0)
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: controller.paymentsList.length,
              itemBuilder: (context, index) {
                var _paymentMethod =
                    controller.paymentsList.value.elementAt(index);
                return PaymentMethodItemWidget(paymentMethod: _paymentMethod);
              },
            ),
        ]),
      ),
      bottomNavigationBar: buildBottomWidget(Get.arguments as ServiceProvider),
    );
  }

  Widget buildBottomWidget(ServiceProvider _task) {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PaymentDetailsWidget(task: _task),
          BlockButtonWidget(
              text: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Hire & Pay Now".tr,
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
                Get.toNamed(Routes.CONFIRMATION, arguments: _task);
              }).paddingSymmetric(vertical: 10, horizontal: 20),
        ],
      ),
    );
  }
}
