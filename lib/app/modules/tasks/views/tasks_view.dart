import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/notifications_button_widget.dart';
import '../controllers/tasks_controller.dart';
import '../widgets/tasks_carousel_widget.dart';
import '../widgets/tasks_list_widget.dart';

class TasksView extends GetView<TasksController> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Bookings".tr,
            style: Get.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.sort, color: Get.theme.hintColor),
            onPressed: () => {Scaffold.of(context).openDrawer()},
          ),
          actions: [NotificationsButtonWidget()],
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.symmetric(horizontal: 15),
            unselectedLabelColor: Get.theme.accentColor,
            labelColor: Get.theme.primaryColor,
            labelStyle: Get.textTheme.bodyText1,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.theme.accentColor),
            tabs: [
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Get.theme.accentColor.withOpacity(0.2)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Pending".tr,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Get.theme.accentColor.withOpacity(0.2)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Ongoing".tr,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Get.theme.accentColor.withOpacity(0.2)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("Completed".tr,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.fade),
                  ),
                ),
              ),
            ],
            onTap: (index) async {
              switch (index) {
                case 0:
                  await controller.getPendingTasks();
                  break;
                case 1:
                  await controller.getOngoingTasks();
                  break;
                case 2:
                  await controller.getCompletedTasks();
              }
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: TabBarView(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  await controller.bookings.refresh();
                },
                child: SingleChildScrollView(
                  child: TasksCarouselWidget(),
                ),
              ),
              RefreshIndicator(
                onRefresh: () async {
                  await controller.OngoingTasks.refresh();
                },
                child: TasksListWidget(tasks: controller.OngoingTasks),
              ),
              RefreshIndicator(
                onRefresh: () async {
                  await controller.CompletedTasks.refresh();
                },
                child: TasksListWidget(tasks: controller.CompletedTasks),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
