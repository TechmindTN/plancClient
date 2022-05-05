import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/notifications_button_widget.dart';
import '../../../models/Intervention.dart';
import '../../../routes/app_pages.dart';
import '../controllers/tasks_controller.dart';
import '../widgets/task_row_widget.dart';

class InfoView extends GetView<TasksController> {
  final Intervention _task;
  InfoView(this._task);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text('Informations supplémentaires'),
      )),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(children: [
          TaskRowWidget(
            description: 'description',
            value: _task.description,
            hasDivider: true,
          ),
          TaskRowWidget(
              value: '${_task.creation_date.toDate().year}' +
                  '-' +
                  '${_task.creation_date.toDate().month}' +
                  '-' +
                  '${_task.creation_date.toDate().day}' +
                  '  ' +
                  '${_task.creation_date.toDate().hour}' +
                  ':' +
                  '${_task.creation_date.toDate().minute}',
              description: "Date de demande".tr,
              hasDivider: true),
          TaskRowWidget(
            description: 'Catégorie'.tr,
            value: _task.category.name,
            hasDivider: true,
          ),
          TaskRowWidget(
            description: 'Suppliers'.tr,
            value: _task.provider.name,
            hasDivider: true,
          ),
          TaskRowWidget(
            description: 'Payment Method'.tr,
            value: _task.bill.payment?.name ?? 'Non indiqué ',
            hasDivider: true,
          ),
          Row(
            children: [
              Text('Media ', style: Get.textTheme.bodyText1),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _task.media.isNotEmpty && _task.media != null
              ? Row(children: [
                  for (var i in _task.media)
                    InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                    insetPadding: EdgeInsets.all(0),
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      color:
                                          Colors.transparent.withOpacity(0.3),
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      child: Image.network(
                                        i.url,
                                        // scale: 20,

                                        fit: BoxFit.fill,
                                        // width: MediaQuery.of(context).size.width*0.9,
                                        // height: MediaQuery.of(context).size.height*0.8,

                                        // scale: 0.1,
                                      ),
                                    ));
                              });
                          //Get.toNamed(Routes.CATEGORY, arguments: _category);
                        },
                        child: Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsetsDirectional.only(
                                end: 20, start: 20, top: 10, bottom: 10),
                            child: Stack(
                                alignment: AlignmentDirectional.topStart,
                                children: [
                                  ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      child: Image.network(
                                        i.url,
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ))
                                ])))
                ])
              : SizedBox(),
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
                    style: ButtonStyle(alignment: Alignment.bottomRight),
                    onPressed: () {
                      Get.toNamed(Routes.BILL, arguments: _task.bill);
                    },
                    child: Text(
                      'Voir facture',
                      textAlign: TextAlign.end,
                    )))
          ]),
        ]),
      ),
    );
  }
}
