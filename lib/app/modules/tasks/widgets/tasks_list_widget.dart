import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/task_model.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/Intervention.dart';
import '../../../routes/app_pages.dart';
import '../../feedback/views/rating_view.dart';
import '../controllers/tasks_controller.dart';
import '../views/informations_view.dart';
import 'task_row_widget.dart';

class TasksListWidget extends StatelessWidget {
  final controller = Get.find<TasksController>();
  final List<Intervention> tasks;

  TasksListWidget({Key key, List<Intervention> this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (tasks.length == 0) {
      return Center(
        child: Text("No Interventions yet !"),
      );
    } else {
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
                      imageUrl: _task.provider?.profile_photo,
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
                    child: InkWell(
                      child: Wrap(
                        runSpacing: 10,
                        alignment: WrapAlignment.end,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _task.provider?.name ?? '',
                                style: Get.textTheme.bodyText2,
                                maxLines: 3,
                                // textAlign: TextAlign.end,
                              ),
                              _task.states == 'refused'
                                  ? Text(
                                      'Refused'.tr,
                                      style: TextStyle(color: Colors.red),
                                    )
                                  : Text(
                                      _task.states == 'completed'
                                          ? 'Closed'.tr
                                          : '',
                                      style: TextStyle(color: Colors.green),
                                    )
                            ],
                          ),
                          Divider(height: 8, thickness: 1),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Title".tr,
                                  style: Get.textTheme.bodyText1,
                                ),
                              ),
                              Text(
                                _task.title,
                                style: Get.textTheme.bodyText1,
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
                                '${_task.datetime.toDate().year}' +
                                    '-' +
                                    '${_task.datetime.toDate().month}' +
                                    '-' +
                                    '${_task.datetime.toDate().day}' +
                                    '  ' +
                                    '${_task.datetime.toDate().hour}' +
                                    ':' +
                                    '${_task.datetime.toDate().minute}',
                                style: Get.textTheme.bodyText1,
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
                              Text(_task.bill.total_price.toString() + ' TND',
                                  style: Get.textTheme.headline6),
                            ],
                          ),

                          _task.states == "ongoing"
                              ? Row(
                                  children: [
                                    Expanded(
                                        child: ElevatedButton(
                                      onPressed: () async {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: Container(
                                                    height: 80,
                                                    width: 100,
                                                    child: Column(children: [
                                                      Text(
                                                          'Service is already finished ?'
                                                              .tr),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          controller
                                                                  .OngoingTasks
                                                              .remove(_task);
                                                          _task.states =
                                                              "completed";

                                                          controller
                                                                  .CompletedTasks
                                                              .add(_task);
                                                          await controller
                                                              .updateFireintervention(
                                                                  _task.id,
                                                                  3,
                                                                  _task
                                                                      .provider);

                                                          Navigator.pop(
                                                              context);
                                                          controller.update();
                                                          Get.toNamed(
                                                              Routes.RATING,
                                                              arguments: _task);
                                                        },
                                                        child: Text('Yes'.tr),
                                                      ),
                                                    ])),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              );
                                            });
                                      },
                                      child: Text('Confirm'.tr),
                                    )),
                                  ],
                                )
                              : SizedBox(),
                          // Wrap(
                          //   spacing: 10,
                          //   children: [
                          //     MaterialButton(
                          //       elevation: 0,
                          //       onPressed: () {
                          //         Get.toNamed(Routes.RATING, arguments: _task);
                          //       },
                          //       shape: StadiumBorder(),
                          //       color: Get.theme.accentColor.withOpacity(0.1),
                          //       child: Text("Rating".tr,
                          //           style: Get.textTheme.subtitle1),
                          //     ),
                          //     MaterialButton(
                          //       elevation: 0,
                          //       onPressed: () {},
                          //       shape: StadiumBorder(),
                          //       color: Get.theme.accentColor.withOpacity(0.1),
                          //       child: Text("Re-Booking".tr,
                          //           style: Get.textTheme.subtitle1),
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                      onTap: () {
                        Get.to(InfoView(_task));
                      },
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
}
