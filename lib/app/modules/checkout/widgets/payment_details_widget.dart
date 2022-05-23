/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/Provider.dart';
import '../../../their_models/task_model.dart';

class PaymentDetailsWidget extends StatelessWidget {
  const PaymentDetailsWidget({
    Key key,
    @required ServiceProvider task,
  })  : _task = task,
        super(key: key);

  final ServiceProvider _task;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      // decoration: Ui.getBoxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: CachedNetworkImage(
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  imageUrl: _task.profile_photo,
                  placeholder: (context, url) => Image.asset(
                    'assets/img/loading.gif',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 80,
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error_outline),
                ),
              ),
              // if (_task.eService.eProvider.available)
              //   Container(
              //     width: 80,
              //     child: Text("Available".tr,
              //         maxLines: 1,
              //         style: Get.textTheme.bodyText2.merge(
              //           TextStyle(
              //               color: Colors.green, height: 1.4, fontSize: 10),
              //         ),
              //         softWrap: false,
              //         textAlign: TextAlign.center,
              //         overflow: TextOverflow.fade),
              //     decoration: BoxDecoration(
              //       color: Colors.green.withOpacity(0.2),
              //       borderRadius: BorderRadius.only(
              //           bottomRight: Radius.circular(10),
              //           bottomLeft: Radius.circular(10)),
              //     ),
              //     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              //   ),
              // if (!_task.eService.eProvider.available)
              //   Container(
              //     width: 80,
              //     child: Text("Offline".tr,
              //         maxLines: 1,
              //         style: Get.textTheme.bodyText2.merge(
              //           TextStyle(
              //               color: Colors.grey, height: 1.4, fontSize: 10),
              //         ),
              //         softWrap: false,
              //         textAlign: TextAlign.center,
              //         overflow: TextOverflow.fade),
              //     decoration: BoxDecoration(
              //       color: Colors.grey.withOpacity(0.2),
              //       borderRadius: BorderRadius.only(
              //           bottomRight: Radius.circular(10),
              //           bottomLeft: Radius.circular(10)),
              //     ),
              //     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              //   ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Wrap(
              runSpacing: 10,
              alignment: WrapAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      _task.name ?? '',
                      style: Get.textTheme.bodyText2,
                      maxLines: 3,
                      // textAlign: TextAlign.end,
                    ),
                  ],
                ),
                Divider(height: 8, thickness: 1),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text("Service Payment".tr),
                //     Ui.getPrice(_task.eService.pr,
                //         style: Get.textTheme.subtitle2),
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text("Tax".tr),
                //     Ui.getPrice(_task.eService.minPrice,
                //         style: Get.textTheme.subtitle2),
                //   ],
                // ),
                // Divider(height: 8, thickness: 1),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text("Total".tr),
                //     Ui.getPrice(_task.eService.minPrice,
                //         style: Get.textTheme.headline6),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
