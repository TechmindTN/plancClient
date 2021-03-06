import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../common/ui.dart';
import '../../../global_widgets/circular_loading_widget.dart';
import '../../../models/Intervention.dart';
import '../../../routes/app_pages.dart';
import '../controllers/tasks_controller.dart';
import '../views/bill_view.dart';
import 'task_row_widget.dart';

class TasksCarouselWidget extends StatelessWidget {
  final controller = Get.find<TasksController>();
  String _enteredMessage = '';

  TasksCarouselWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.selectedTask = Intervention().obs;
    return Column(
      children: [
        Container(
            height: 230,
            // child: StreamBuilder(
            //     stream: controller.bookings,

            //     // itemCount: val.bookings.length,
            //     builder: (BuildContext context, AsyncSnapshot snapshot) {
            //       if (snapshot.connectionState == ConnectionState.waiting) {
            //         return const Center(child: CircularProgressIndicator());
            //       } else if (snapshot.connectionState == ConnectionState.done) {
            //         if (snapshot.hasData) {
            child: Obx(() {
              if (controller.bookings.length == 0) {
                controller
                    .getPendingTasks()
                    .then((value) => Future.delayed(Duration(seconds: 2), () {
                          controller.bookings.refresh();
                        }));
                return Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                    padding: EdgeInsets.only(bottom: 10),
                    primary: false,
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.bookings.length,
                    itemBuilder: (_, index) {
                      var _service =
                          controller.bookings.elementAt(index).provider;
                      var _task = controller.bookings.elementAt(index);
                      if (index == 0) {
                        controller.selectedTask.value =
                            controller.bookings.first;
                      }
                      controller.update();
                      return GestureDetector(
                        onTap: () {
                          controller.selectedTask.value = _task;
                          controller.update();
                        },
                        child: Container(
                          width: 200,
                          margin: EdgeInsetsDirectional.only(
                              end: 20,
                              start: index == 0 ? 20 : 0,
                              top: 20,
                              bottom: 10),
                          // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Get.theme.focusColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5)),
                            ],
                          ),
                          child: Column(
                            //alignment: AlignmentDirectional.topStart,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                child: CachedNetworkImage(
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  imageUrl: _service?.profile_photo ??
                                      'https://previews.123rf.com/images/chekman/chekman1911/chekman191100489/133662631-vector-service-icon-isolated-black-web-service-icon-in-flat-design-service-concept.jpg',
                                  placeholder: (context, url) => Image.asset(
                                    'assets/img/loading.gif',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 100,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error_outline),
                                ),
                              ),
                              Obx(
                                () => AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  // height: 45,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: controller.selectedTask == _task
                                        ? Get.theme.accentColor
                                        : Get.theme.primaryColor,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                  ),
                                  child: Wrap(
                                    direction: Axis.vertical,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    runAlignment: WrapAlignment.start,
                                    children: [
                                      Text(
                                        _service?.name ?? 'Service',
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        style: Get.textTheme.bodyText2.merge(
                                            TextStyle(
                                                color:
                                                    controller.selectedTask ==
                                                            _task
                                                        ? Get.theme.primaryColor
                                                        : Get.theme.hintColor)),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '${_task.datetime.toDate().year}' +
                                            ' - ' +
                                            '${_task.datetime.toDate().month}' +
                                            ' - ' +
                                            '${_task.datetime.toDate().day}',
                                        style: Get.textTheme.caption.merge(
                                            TextStyle(
                                                color: controller
                                                            .selectedTask ==
                                                        _task
                                                    ? Get.theme.primaryColor
                                                    : Get.theme.focusColor)),
                                      ),
                                      Text(
                                        'At ${_task.datetime.toDate().hour}' +
                                            ':' +
                                            '${_task.datetime.toDate().minute}',
                                        style: Get.textTheme.caption.merge(
                                            TextStyle(
                                                color: controller
                                                            .selectedTask ==
                                                        _task
                                                    ? Get.theme.primaryColor
                                                    : Get.theme.focusColor)),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    });
              }
            })),
        GetBuilder<TasksController>(
            init: TasksController(),
            builder: (val) {
              if (val.selectedTask.value.datetime.isNull) {
                return Container(height: 300);
              } else {
                val.update();
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                              imageUrl: val.selectedTask.value.provider
                                      ?.profile_photo ??
                                  'https://previews.123rf.com/images/chekman/chekman1911/chekman191100489/133662631-vector-service-icon-isolated-black-web-service-icon-in-flat-design-service-concept.jpg',
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
                              spacing: 5,
                              direction: Axis.vertical,
                              children: [
                                Text(
                                  val.selectedTask.value.provider?.name ??
                                      'Service',
                                  style: Get.textTheme.bodyText2,
                                  maxLines: 3,
                                  // textAlign: TextAlign.end,
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                      right: 12, left: 12, top: 6, bottom: 6),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color:
                                        Get.theme.focusColor.withOpacity(0.1),
                                  ),
                                  // child: Text(
                                  //   val.selectedTask.progress.tr,
                                  //   style: TextStyle(color: Get.theme.hintColor),
                                  // ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(thickness: 1, height: 40),
                      TaskRowWidget(
                          value: val.selectedTask.value.datetime.toString(),
                          description: "Time".tr,
                          child: Wrap(
                            direction: Axis.vertical,
                            crossAxisAlignment: WrapCrossAlignment.end,
                            runAlignment: WrapAlignment.end,
                            children: [
                              Text(
                                '${val.selectedTask.value.datetime.toDate().year}' +
                                    ' - ' +
                                    '${val.selectedTask.value.datetime.toDate().month}' +
                                    ' - ' +
                                    '${val.selectedTask.value.datetime.toDate().day}',
                              ),
                              Text(
                                'At ${val.selectedTask.value.datetime.toDate().hour}' +
                                    ':' +
                                    '${val.selectedTask.value.datetime.toDate().minute}',
                              )
                            ],
                          ),
                          hasDivider: true),
                      // TaskRowWidget(
                      //     description: "Payment Method".tr,
                      //     value: val.selectedTask.bill.payment.name,
                      //     hasDivider: true),
                      // TaskRowWidget(
                      //   description: "Tax Amount".tr,
                      //   child: Align(
                      //     alignment: Alignment.centerRight,
                      //     child: Ui.getPrice(val.selectedTask.tax,
                      //         style: Get.textTheme.bodyText2),
                      //   ),
                      // ),
                      // TaskRowWidget(
                      //   description: "Total Amount".tr,
                      //   child: Align(
                      //     alignment: Alignment.centerRight,
                      //     // child: Ui.getPrice(val.selectedTask.bill.total_price,
                      //     //     style: Get.textTheme.headline6),
                      //   ),
                      //   hasDivider: true,
                      // ),
                      TaskRowWidget(
                          description: "Address".tr,
                          value: val.selectedTask.value.address,
                          hasDivider: true),
                      TaskRowWidget(
                          description: "Description".tr,
                          value: val.selectedTask.value.description,
                          hasDivider: true),
                      TaskRowWidget(
                        description: "Status".tr,
                        value: val.selectedTask.value.states.tr,
                        hasDivider: true,
                      ),
                      val.selectedTask.value.bill != null
                          ? Column(children: [
                              TaskRowWidget(
                                description: "Total price",
                                value: val.selectedTask.value.bill.total_price
                                        .toString() +
                                    ' tnd',
                                hasDivider: true,
                              ),
                              Row(children: [
                                Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Bill'.tr,
                                      style: Get.textTheme.bodyText1,
                                    )),
                                Expanded(
                                    flex: 2,
                                    child: TextButton(
                                        style: ButtonStyle(
                                            alignment: Alignment.bottomRight),
                                        onPressed: () {
                                          Get.toNamed(Routes.BILL,
                                              arguments:
                                                  val.selectedTask.value.bill);
                                        },
                                        child: Text(
                                          'View Bill'.tr,
                                          textAlign: TextAlign.end,
                                        )))
                              ]),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: ElevatedButton(
                                    onPressed: () async {
                                      val.selectedTask.value.states = 'ongoing';
                                      val.OngoingTasks.add(
                                          val.selectedTask.value);

                                      val.update();
                                      await val.updateFireintervention(
                                          val.selectedTask.value.id,
                                          1,
                                          val.selectedTask.value.provider);
                                      DefaultTabController.of(context)
                                          .animateTo(1);
                                    },
                                    child: Text('Accept'),
                                  )),
                                  Expanded(
                                      child: ElevatedButton(
                                    onPressed: () async {
                                      val.selectedTask.value.states = 'refused';
                                      val.CompletedTasks.add(
                                          val.selectedTask.value);
                                      val.update();
                                      await val.updateFireintervention(
                                          val.selectedTask.value.id,
                                          2,
                                          val.selectedTask.value.provider);

                                      val.update();
                                      val.bookings.refresh();
                                      DefaultTabController.of(context)
                                          .animateTo(2);

                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Container(
                                                  height: 150,
                                                  width: 100,
                                                  child: Column(children: [
                                                    Text(
                                                        'Dites-nous pourquoi vous avez r??fus?? cette facture ?'
                                                            .tr),
                                                    TextField(
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0)),
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'Send a message',
                                                        border:
                                                            InputBorder.none,
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      onChanged: (value) {
                                                        _enteredMessage = value;
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Intervention')
                                                            .doc(val
                                                                .selectedTask
                                                                .value
                                                                .id)
                                                            .update({
                                                          'refuse_purpose':
                                                              _enteredMessage
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Send'.tr),
                                                    ),
                                                  ])),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            );
                                          });
                                    },
                                    child: Text('Decline'),
                                  ))
                                ],
                              )
                            ])
                          : SizedBox()
                    ],
                  ),
                );
              }
            })
      ],
    );
  }
}
