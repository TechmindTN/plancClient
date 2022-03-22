import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/payment_method_model.dart';

class CheckoutController extends GetxController {
  List<PaymentMethod> paymentsList;
  List<PaymentMethod> cashList;
  List<PaymentMethod> walletList;
  Rx<PaymentMethod> selectedPaymentMethod =
      new PaymentMethod("id", "name", "description", "route", "logo").obs;

  @override
  void onInit() async {
    await loadPaymentMethodsList();
    selectedPaymentMethod.value =
        this.paymentsList.firstWhere((element) => element.isDefault);
    super.onInit();
  }

  Future loadPaymentMethodsList() async {
    this.paymentsList = [
      new PaymentMethod(
          "visa_card",
          "Visa Card".tr,
          "Click to pay with your Visa card",
          "/Checkout",
          "assets/img/visacard.png",
          isDefault: true),
      new PaymentMethod(
          "mastercard",
          "MasterCard".tr,
          "Click to pay with your Mastercard",
          "/Checkout",
          "assets/img/mastercard.png"),
      new PaymentMethod(
          "razorpay",
          "Razorpay".tr,
          "Click to pay with Razorpay gateway",
          "/RazorPay",
          "assets/img/razorpay.png"),
      new PaymentMethod(
          "paypal",
          "Paypal".tr,
          "Click to pay with your PayPal account".tr,
          "/PayPal",
          "assets/img/paypal.png"),
    ];
    this.cashList = [
      new PaymentMethod("cod", "Cash".tr, "Click to pay cash".tr, "/Cash",
          "assets/img/cash.png"),
    ];
    this.walletList = [
      new PaymentMethod(
          "wallet",
          "Wallet",
          "Pay using your wallet in the app".tr,
          "/Wallet",
          "assets/img/wallet.png"),
    ];
  }

  void selectPaymentMethod(PaymentMethod paymentMethod) {
    selectedPaymentMethod.value = paymentMethod;
  }

  TextStyle getTitleTheme(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.textTheme.bodyText2
          .merge(TextStyle(color: Get.theme.primaryColor));
    }
    return Get.textTheme.bodyText2;
  }

  TextStyle getSubTitleTheme(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.textTheme.caption
          .merge(TextStyle(color: Get.theme.primaryColor));
    }
    return Get.textTheme.caption;
  }

  Color getColor(PaymentMethod paymentMethod) {
    if (paymentMethod == selectedPaymentMethod.value) {
      return Get.theme.accentColor;
    }
    return null;
  }
}
