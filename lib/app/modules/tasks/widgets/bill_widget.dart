import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/Bill.dart';
import '../controllers/tasks_controller.dart';
import 'task_row_widget.dart';

class BillWidget extends StatelessWidget {
  final controller = Get.find<TasksController>();
  final Bill bill;

  BillWidget({Key key, Bill this.bill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
              value: bill.date.toDate().toString(),
              description: "Time".tr,
              hasDivider: true),
          TaskRowWidget(
              description: "Payment Method".tr,
              value: bill.payment.name,
              hasDivider: true),
          TaskRowWidget(description: "Material ".tr),
          SizedBox(height: 5),
          Table(
              defaultColumnWidth: FixedColumnWidth(100.0),
              border: TableBorder.all(
                  color: Colors.black, style: BorderStyle.solid, width: 0.5),
              children: [
                TableRow(children: [
                  Column(children: [
                    Text('Name', style: TextStyle(fontSize: 15.0))
                  ]),
                  Column(children: [
                    Text('Quantity', style: TextStyle(fontSize: 15.0))
                  ]),
                  Column(children: [
                    Text('Price', style: TextStyle(fontSize: 15.0))
                  ]),
                ]),
                for (var i in bill.materials)
                  TableRow(
                    children: [
                      Column(children: [Text(i['material'].name)]),
                      Column(children: [Text(i['quantity'].toString())]),
                      Column(children: [Text(i['total_price'].toString())]),
                    ],
                  ),
              ]),
          Divider(thickness: 1, height: 40),
          TaskRowWidget(
              description: "Discount".tr,
              value: bill.discount.toString() + ' tnd',
              hasDivider: true),
          TaskRowWidget(
              description: "Service fee".tr,
              value: bill.service_fee.toString() + ' tnd',
              hasDivider: true),
          TaskRowWidget(
              description: "Study fee".tr,
              value: bill.study_fee.toString() + ' tnd',
              hasDivider: true),
        ]));
  }
}
