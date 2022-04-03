import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/task_model.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../routes/app_pages.dart';
import '../controllers/tasks_controller.dart';

class TasksListWidget extends StatelessWidget {
  final controller = Get.find<TasksController>();
  final List<Task> tasks;

  TasksListWidget({Key key, List<Task> this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        primary: true,
        shrinkWrap: false,
        itemCount: tasks.length,
        itemBuilder: ((_, index) {
          var _task = tasks.elementAt(index);
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: Ui.getBoxDecoration(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: CachedNetworkImage(
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    imageUrl: _task.eService?.profile_photo,
                    placeholder: (context, url) => Image.asset(
                      'assets/img/loading.gif',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 70,
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error_outline),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Wrap(
                    runSpacing: 10,
                    alignment: WrapAlignment.end,
                    children: <Widget>[
                      Row(
                        children: [
                          Text(
                            _task.eService?.name ?? '',
                            style: Get.textTheme.bodyText2,
                            maxLines: 3,
                            // textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                      Divider(height: 8, thickness: 1),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Your Review".tr,
                              style: Get.textTheme.bodyText1,
                            ),
                          ),
                          // Wrap(
                          //   spacing: 0,
                          //   children: Ui.getStarsList(
                          //       (_task.rate != null) ? _task.rate : 0.0),
                          // ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Time".tr,
                              style: Get.textTheme.bodyText1,
                            ),
                          ),
                          Text(
                            '${_task.dateTime}',
                            style: Get.textTheme.caption,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Total Price".tr,
                              style: Get.textTheme.bodyText1,
                            ),
                          ),
                          Ui.getPrice(_task.bill.total_price,
                              style: Get.textTheme.headline6),
                        ],
                      ),
                      Wrap(
                        spacing: 10,
                        children: [
                          MaterialButton(
                            elevation: 0,
                            onPressed: () {
                              Get.toNamed(Routes.RATING, arguments: _task);
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.accentColor.withOpacity(0.1),
                            child: Text("Rating".tr,
                                style: Get.textTheme.subtitle1),
                          ),
                          MaterialButton(
                            elevation: 0,
                            onPressed: () {},
                            shape: StadiumBorder(),
                            color: Get.theme.accentColor.withOpacity(0.1),
                            child: Text("Re-Booking".tr,
                                style: Get.textTheme.subtitle1),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      );
    });
  }
}
