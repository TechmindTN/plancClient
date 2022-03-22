import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/style.dart';
import 'package:get/get.dart';

import '../app/services/settings_service.dart';

class Ui {
  static GetBar SuccessSnackBar({String title = 'Success', String message}) {
    Get.log("[$title] $message");
    return GetBar(
      titleText: Text(title.tr, style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor))),
      messageText: Text(message, style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(20),
      backgroundColor: Get.theme.accentColor,
      icon: Icon(Icons.check_circle_outline, size: 32, color: Get.theme.primaryColor),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      dismissDirection: SnackDismissDirection.HORIZONTAL,
      duration: Duration(seconds: 5),
    );
  }

  static GetBar ErrorSnackBar({String title = 'Error', String message}) {
    Get.log("[$title] $message", isError: true);
    return GetBar(
      titleText: Text(title.tr, style: Get.textTheme.headline6.merge(TextStyle(color: Get.theme.primaryColor))),
      messageText: Text(message, style: Get.textTheme.caption.merge(TextStyle(color: Get.theme.primaryColor))),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(20),
      backgroundColor: Colors.redAccent,
      icon: Icon(Icons.remove_circle_outline, size: 32, color: Get.theme.primaryColor),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: Duration(seconds: 5),
    );
  }

  static Color parseColor(String hexCode, {double opacity}) {
    try {
      return Color(int.parse(hexCode.replaceAll("#", "0xFF"))).withOpacity(opacity ?? 1);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity ?? 1);
    }
  }

  static List<Icon> getStarsList(double rate, {double size = 18}) {
    var list = <Icon>[];
    list = List.generate(rate.floor(), (index) {
      return Icon(Icons.star, size: size, color: Color(0xFFFFB24D));
    });
    if (rate - rate.floor() > 0) {
      list.add(Icon(Icons.star_half, size: size, color: Color(0xFFFFB24D)));
    }
    list.addAll(List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
      return Icon(Icons.star_border, size: size, color: Color(0xFFFFB24D));
    }));
    return list;
  }

  static Widget getPrice(double myPrice, {TextStyle style, String zeroPlaceholder = '-', String unit}) {
    var _setting = Get.find<SettingsService>();
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize + 2));
    }
    try {
      if (myPrice == 0) {
        return Text('-', style: style ?? Get.textTheme.subtitle2);
      }
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text: _setting.setting.value.currencyRight != null && _setting.setting.value?.currencyRight == false
            ? TextSpan(
                text: _setting.setting.value?.defaultCurrency,
                style: getPriceStyle(style),
                children: <TextSpan>[
                  TextSpan(text: myPrice.toStringAsFixed(_setting.setting.value?.defaultCurrencyDecimalDigits) ?? '', style: style ?? Get.textTheme.subtitle2),
                  if (unit != null) TextSpan(text: " " + unit + " ", style: getPriceStyle(style)),
                ],
              )
            : TextSpan(
                text: myPrice.toStringAsFixed(_setting.setting.value?.defaultCurrencyDecimalDigits) ?? '',
                style: style ?? Get.textTheme.subtitle2,
                children: <TextSpan>[
                  TextSpan(text: _setting.setting.value?.defaultCurrency, style: getPriceStyle(style)),
                  if (unit != null) TextSpan(text: " " + unit + " ", style: getPriceStyle(style)),
                ],
              ),
      );
    } catch (e) {
      return Text('');
    }
  }

  static TextStyle getPriceStyle(TextStyle style) {
    if (style == null) {
      return Get.textTheme.subtitle2.merge(
        TextStyle(fontWeight: FontWeight.w400, fontSize: Get.textTheme.subtitle2.fontSize - 6),
      );
    } else {
      return style.merge(TextStyle(fontWeight: FontWeight.w400, fontSize: style.fontSize - 6));
    }
  }

  static BoxDecoration getBoxDecoration({Color color, double radius, Border border, Gradient gradient}) {
    return BoxDecoration(
      color: color ?? Get.theme.primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
      boxShadow: [
        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
      ],
      border: border ?? Border.all(color: Get.theme.focusColor.withOpacity(0.05)),
      gradient: gradient,
    );
  }

  static InputDecoration getInputDecoration({String hintText = '', IconData iconData, Widget suffixIcon}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: Get.textTheme.caption,
      prefixIcon: iconData != null ? Icon(iconData, color: Get.theme.focusColor).marginOnly(right: 14) : SizedBox(),
      prefixIconConstraints: iconData != null ? BoxConstraints.expand(width: 38, height: 38) : BoxConstraints.expand(width: 0, height: 0),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: EdgeInsets.all(0),
      border: OutlineInputBorder(borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
      suffixIcon: suffixIcon,
    );
  }

  static Html applyHtml(String html, {TextStyle style}) {
    return Html(
      data: html ?? '',
      customRender: {
        "p": (RenderContext context, Widget child, attributes, _) {
          return Text(
            _.text,
            style: Get.textTheme.bodyText1.merge(TextStyle(fontSize: 11)),
          );
        },
      },
      style: {
        "*": Style(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(0),
          color: Get.theme.hintColor,
          fontSize: FontSize(16.0),
          display: Display.INLINE_BLOCK,
          width: Get.width,
        ),
        "h4,h5,h6": Style(
          fontSize: FontSize(16.0),
        ),
        "h1,h2,h3": Style(
          fontSize: FontSize(18.0),
        ),
        "br": Style(
          height: 0,
        ),
      },
    );
  }
}
