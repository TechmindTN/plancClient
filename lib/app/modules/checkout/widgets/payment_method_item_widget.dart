/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/payment_method_model.dart';
import '../../../../common/ui.dart';
import '../../../models/Payment.dart';
import '../controllers/checkout_controller.dart';

class PaymentMethodItemWidget extends GetWidget<CheckoutController> {
  PaymentMethodItemWidget({
    @required Payment paymentMethod,
  }) : _paymentMethod = paymentMethod;

  final Payment _paymentMethod;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Theme(
          data: ThemeData(
            toggleableActiveColor: Get.theme.primaryColorDark,
          ),
          child: RadioListTile(
            value: _paymentMethod,
            groupValue: controller.selectedPaymentMethod.value,
            onChanged: (value) {
              controller.selectPaymentMethod(value);
            },
            title: Text(_paymentMethod.name,
                    style: controller.getTitleTheme(_paymentMethod))
                .paddingOnly(bottom: 5),
            subtitle: Text(_paymentMethod.type,
                style: controller.getSubTitleTheme(_paymentMethod)),
            secondary: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                image: DecorationImage(
                    image: NetworkImage(_paymentMethod.icon), fit: BoxFit.fill),
              ),
            ),
          ),
        ),
      );
    });
  }
}
