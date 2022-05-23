import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/Bill.dart';
import '../controllers/tasks_controller.dart';
import 'task_row_widget.dart';

class BillWidget extends StatelessWidget {
  final controller = Get.find<TasksController>();
  final Bill bill;
  double sum = 0.0;
  BillWidget({Key key, Bill this.bill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    for (var j in bill.materials) {
      sum = sum + double.parse(j['total_price'].toString());
    }
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          TaskRowWidget(
              value: '${bill.date.toDate().year}' +
                  '-' +
                  '${bill.date.toDate().month}' +
                  '-' +
                  '${bill.date.toDate().day}' +
                  '  ' +
                  '${bill.date.toDate().hour}' +
                  ':' +
                  '${bill.date.toDate().minute}',
              description: "Time".tr,
              hasDivider: true),
          TaskRowWidget(
              description: "Payment Method".tr,
              value: bill.payment?.name ?? ' Non indiqué ',
              hasDivider: true),
          bill.materials != null && bill.materials.isNotEmpty
              ? Column(children: [
                  TaskRowWidget(description: "Materials".tr),
                  SizedBox(height: 10),
                  Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      defaultColumnWidth: FixedColumnWidth(70.0),
                      border: TableBorder.symmetric(
                          inside: BorderSide(width: 0.5, color: Colors.blue),
                          outside: BorderSide(width: 0.7)),
                      children: [
                        TableRow(children: [
                          Column(children: [
                            Text('Name'.tr,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w900))
                          ]),
                          Column(children: [
                            Text('Unit Price'.tr,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w900))
                          ]),
                          Column(children: [
                            Text('Quantity'.tr,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w900))
                          ]),
                          Column(children: [
                            Text('Total Price'.tr,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w900))
                          ]),
                        ]),
                        for (var i in bill.materials)
                          TableRow(
                            children: [
                              Column(children: [Text(i['material'].name)]),
                              Column(children: [
                                Text(i['material'].price.toString())
                              ]),
                              Column(
                                  children: [Text(i['quantity'].toString())]),
                              Column(children: [
                                Text(i['total_price'].toString())
                              ]),
                            ],
                          ),
                        TableRow(
                          children: [
                            Column(children: []),
                            Column(children: []),
                            Column(children: []),
                            Column(children: [Text(sum.toString())]),
                          ],
                        ),
                      ]),
                  Divider(thickness: 1, height: 40),
                ])
              : SizedBox(),
          TaskRowWidget(
              description: "Study fee".tr,
              value: bill.study_fee.toString() + ' TND',
              hasDivider: true),
          TaskRowWidget(
              description: "Service fee".tr,
              value: bill.service_fee.toString() + ' TND',
              hasDivider: true),
          TaskRowWidget(
              description: "Workforce fee".tr,
              value: bill.workforce_fee.toString() + ' TND',
              hasDivider: true),
          TaskRowWidget(
              description: "Discount".tr,
              value: bill.discount.toString() + ' TND',
              hasDivider: true),
          TaskRowWidget(
              description: "Total price".tr,
              value: bill.total_price.toString() + ' TND',
              hasDivider: true),
        ]));
  }
}
