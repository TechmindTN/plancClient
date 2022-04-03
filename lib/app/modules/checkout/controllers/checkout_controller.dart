import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/payment_method_model.dart';

import '../../../Network/PaymentNetwork.dart';
import '../../../models/Payment.dart';

class CheckoutController extends GetxController {
  PaymentNetwork _paymentNetwork = PaymentNetwork();
  final RxList<Payment> paymentsList = <Payment>[].obs;

  Rx<Payment> selectedPaymentMethod = new Payment().obs;

  @override
  void onInit() async {
    await loadPaymentMethodsList();
    selectedPaymentMethod.value = paymentsList.value.first;
    super.onInit();
  }

  Future loadPaymentMethodsList() async {
    paymentsList.value = await _paymentNetwork.getPaymentList();
    update();
  }

  void selectPaymentMethod(Payment paymentMethod) {
    selectedPaymentMethod.value = paymentMethod;
  }

  TextStyle getTitleTheme(Payment paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.textTheme.bodyText2
          .merge(TextStyle(color: Get.theme.primaryColorDark));
    }
    return Get.textTheme.bodyText2;
  }

  TextStyle getSubTitleTheme(Payment paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.textTheme.caption
          .merge(TextStyle(color: Get.theme.primaryColorDark));
    }
    return Get.textTheme.caption;
  }

  Color getColor(Payment paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.theme.accentColor;
    }
    return null;
  }
}
