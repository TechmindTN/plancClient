import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/task_model.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../global_widgets/circular_loading_widget.dart';
import '../controllers/tasks_controller.dart';
import 'task_row_widget.dart';

class TasksCarouselWidget extends StatelessWidget {
  final controller = Get.find<TasksController>();
  final List<Task> tasks;
  final selectedTask = Task().obs;

  TasksCarouselWidget({Key key, List<Task> this.tasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 230,
            child: Obx(() {
              if (tasks.isEmpty) {
                return CircularLoadingWidget(height: 190);
              }
              selectedTask.value = tasks.first;
              return ListView.builder(
                  padding: EdgeInsets.only(bottom: 10),
                  primary: false,
                  shrinkWrap: false,
                  scrollDirection: Axis.horizontal,
                  itemCount: tasks.length,
                  itemBuilder: (_, index) {
                    var _service = tasks.elementAt(index).eService;
                    var _task = tasks.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        selectedTask.value = _task;
                      },
                      child: Container(
                        width: 200,
                        margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0, top: 20, bottom: 10),
                        // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                          ],
                        ),
                        child: Column(
                          //alignment: AlignmentDirectional.topStart,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              child: CachedNetworkImage(
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                imageUrl: _service.firstMediaUrl,
                                placeholder: (context, url) => Image.asset(
                                  'assets/img/loading.gif',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 100,
                                ),
                                errorWidget: (context, url, error) => Icon(Icons.error_outline),
                              ),
                            ),
                            Obx(
                              () => AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                // height: 45,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: selectedTask.value == _task ? Get.theme.accentColor : Get.theme.primaryColor,
                                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                ),
                                child: Wrap(
                                  direction: Axis.vertical,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  runAlignment: WrapAlignment.start,
                                  children: [
                                    Text(
                                      _service.title,
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.fade,
                                      style: Get.textTheme.bodyText2.merge(TextStyle(color: selectedTask.value == _task ? Get.theme.primaryColor : Get.theme.hintColor)),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '${DateFormat.yMMMMd().format(selectedTask.value.dateTime)}',
                                      style: Get.textTheme.caption.merge(TextStyle(color: selectedTask.value == _task ? Get.theme.primaryColor : Get.theme.focusColor)),
                                    ),
                                    Text(
                                      'At ${DateFormat('HH:mm').format(selectedTask.value.dateTime)}',
                                      style: Get.textTheme.caption.merge(TextStyle(color: selectedTask.value == _task ? Get.theme.primaryColor : Get.theme.focusColor)),
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
            })),
        Obx(() {
          if (!selectedTask.value.hasData) {
            return CircularLoadingWidget(height: 300);
          }
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              color: Get.theme.primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
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
                        imageUrl: selectedTask.value.eService.firstMediaThumb,
                        placeholder: (context, url) => Image.asset(
                          'assets/img/loading.gif',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 70,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error_outline),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Wrap(
                        spacing: 5,
                        direction: Axis.vertical,
                        children: [
                          Text(
                            selectedTask.value.eService?.title ?? '',
                            style: Get.textTheme.bodyText2,
                            maxLines: 3,
                            // textAlign: TextAlign.end,
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 12, left: 12, top: 6, bottom: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: Get.theme.focusColor.withOpacity(0.1),
                            ),
                            child: Text(
                              selectedTask.value.progress.tr,
                              style: TextStyle(color: Get.theme.hintColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 1, height: 40),
                TaskRowWidget(
                    description: "Time".tr,
                    child: Wrap(
                      direction: Axis.vertical,
                      crossAxisAlignment: WrapCrossAlignment.end,
                      runAlignment: WrapAlignment.end,
                      children: [
                        Text(
                          '${DateFormat.yMMMMd().format(selectedTask.value.dateTime)}',
                        ),
                        Text('At ${DateFormat('HH:mm').format(selectedTask.value.dateTime)}'),
                      ],
                    ),
                    hasDivider: true),
                TaskRowWidget(description: "Payment Method".tr, value: selectedTask.value.paymentMethod.name, hasDivider: true),
                TaskRowWidget(
                  description: "Tax Amount".tr,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Ui.getPrice(selectedTask.value.tax, style: Get.textTheme.bodyText2),
                  ),
                ),
                TaskRowWidget(
                  description: "Total Amount".tr,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Ui.getPrice(selectedTask.value.total, style: Get.textTheme.headline6),
                  ),
                  hasDivider: true,
                ),
                TaskRowWidget(description: "Address".tr, value: selectedTask.value.address.address, hasDivider: true),
                TaskRowWidget(description: "Description".tr, value: selectedTask.value.description),
              ],
            ),
          );
        })
      ],
    );
  }
}
