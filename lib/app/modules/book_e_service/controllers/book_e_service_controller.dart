import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/e_service_model.dart';
import 'package:home_services/app/their_models/task_model.dart';

import '../../../Network/InterventionNetwork.dart';
import '../../../models/Category.dart';
import '../../../models/Client.dart';
import '../../../models/Intervention.dart';
import '../../../models/Provider.dart';
import '../../../services/auth_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../home/controllers/home_controller.dart';

class BookEServiceController extends GetxController {
  InterventionNetwork _interventionNetwork = InterventionNetwork();
  final scheduled = false.obs;
  final Rx<Task> task = Task().obs;
  final Rx<Intervention> intervention = Intervention().obs;
  List<String> catnames = <String>[].obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Client currentclient = Get.find<AuthController>().currentProfile;
  String description = '';
  String title;
  String address;
  String country;
  String city;
  String state;
  int zip_code;
  Rx<Timestamp> d = Timestamp.now().obs;
  List<Category> categlist = <Category>[].obs;
  RxString selectedCategory = ''.obs;
  @override
  void onInit() {
    country = currentclient.country;
    city = currentclient.city;
    state = currentclient.state;
    zip_code = currentclient.zip_code;
    address = currentclient.home_address;
    intervention.value.datetime = d.value;
    categlist = Get.find<HomeController>().categories.value;
    categlist.forEach((element) {
      catnames.add(element.name);
    });
    selectedCategory.value = categlist.first.name;

    this.task.value = Task(
      dateTime: Timestamp.now(),
      address: Get.find<AuthService>().address.value,
      eService: (Get.arguments as ServiceProvider),
      // user: Get.find<AuthService>().user.value,
    );
    super.onInit();
  }

  void toggleScheduled(value) {
    scheduled.value = value;
  }

  TextStyle getTextTheme(bool selected) {
    if (selected) {
      return Get.textTheme.bodyText2
          .merge(TextStyle(color: Get.theme.primaryColor));
    }
    return Get.textTheme.bodyText2;
  }

  Color getColor(bool selected) {
    if (selected) {
      return Get.theme.accentColor;
    }
    return null;
  }

  Future<Null> showMyDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: d.value.toDate().add(Duration(days: 1)),
      firstDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2101),
      locale: Get.locale,
      builder: (BuildContext context, Widget child) {
        return child.paddingAll(10);
      },
    );
    if (picked != null) {
      intervention.update((val) {
        DateTime da = DateTime(picked.year, picked.month, picked.day,
            d.value.toDate().hour, d.value.toDate().minute);
        d.value = Timestamp.fromDate(da);
      });
    }
    ;
  }

  Future<Null> showMyTimePicker(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(d.value.toDate()),
      builder: (BuildContext context, Widget child) {
        return child.paddingAll(10);
      },
    );
    //print(picked);
    if (picked != null) {
      intervention.update((val) {
        DateTime da = DateTime(d.value.toDate().year, d.value.toDate().month,
                d.value.toDate().day)
            .add(Duration(minutes: picked.minute + picked.hour * 60));
        d.value = Timestamp.fromDate(da);
      });
    }
  }

  addIntervention() async {
    intervention.value = Intervention(
        creation_date: Timestamp.now(),
        city: city,
        address: address,
        country: country,
        title: title,
        datetime: d.value,
        description: description,
        zip_code: zip_code,
        state: state,
        bill: null,
        price: null,
        states: 'en cours');
    var data = intervention.value.tofire();

    data["client"] = firestore.doc('Client/' + currentclient.id);
    data["provider"] = firestore.doc('Provider/' + task.value.eService.id);
    var cat;
    categlist.forEach((element) {
      if (element.name == selectedCategory.value) {
        cat = element.id;
      }
    });
    data["category"] = firestore.doc('Category/' + cat);
    print(data);
    await _interventionNetwork
        .addIntervention(data)
        .then((value) => Get.find<HomeController>().onInit());
  }
}
