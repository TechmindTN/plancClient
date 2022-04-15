import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/e_service_model.dart';
import 'package:home_services/app/their_models/task_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../../Network/InterventionNetwork.dart';
import '../../../Network/MediaNetwork.dart';
import '../../../models/Category.dart';
import '../../../models/Client.dart';
import '../../../models/Intervention.dart';
import '../../../models/Media.dart';
import '../../../models/Provider.dart';
import '../../../services/auth_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../home/controllers/home_controller.dart';

class BookEServiceController extends GetxController {
  InterventionNetwork _interventionNetwork = InterventionNetwork();
  MediaNetwork _mediaNetwork = MediaNetwork();

  final scheduled = false.obs;
  final Rx<Intervention> intervention = Intervention().obs;
  List<String> catnames = <String>[].obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  File file;
  List<File> filelist = [];
  Client currentclient = Get.find<AuthController>().currentProfile;
  String description = '';
  String title;
  String address;

  GeoPoint location;
  Rx<Timestamp> d = Timestamp.now().obs;
  List<Category> categlist = <Category>[].obs;
  RxString selectedCategory = ''.obs;
  RxList<Image> imlist = <Image>[].obs;
  ServiceProvider service = ServiceProvider();
  @override
  void onInit() {
    file = File('');
    location = currentclient.location;
    address = currentclient.home_address;
    intervention.value.datetime = d.value;
    categlist = Get.find<HomeController>().categories.value;
    categlist.forEach((element) {
      catnames.add(element.name);
    });
    selectedCategory.value = categlist.first.name;
    service = (Get.arguments as ServiceProvider);
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
    Media media = Media();
    intervention.value = Intervention(
      creation_date: Timestamp.now(),
      address: address,
      location: location,
      title: title,
      datetime: d.value,
      description: description,
      bill: null,
      price: null,
      states: 'en cours',
    );

    var data = intervention.value.tofire();
    data["client"] = firestore.doc('Client/' + currentclient.id);

    if (service != null) {
      data["provider"] = firestore.doc('Provider/' + service.id);
    } else {
      intervention.value.provider = null;
    }
    var cat;
    categlist.forEach((element) {
      if (element.name == selectedCategory.value) {
        cat = element.id;
      }
    });
    data["category"] = firestore.doc('Category/' + cat);

    print('data ' + data.toString());
    await _interventionNetwork.addIntervention(data).then((val) => {
          filelist.forEach((element) async {
            await uploadFile(element).then((value) {
              media = Media(type: 'image', url: value);
              _mediaNetwork.addoneMedia(media.tofire(), val.id);
              print('media foreach ' + media.tofire().toString());
            });
          }),
        });
    // Future.delayed(const Duration(seconds: 5),
    //     addmediatointervention(intervention_id, medlist));

    Get.find<HomeController>().onInit();
  }

  changeImage() async {
    final ImagePicker _picker = ImagePicker();

    final List<XFile> pickedimage = await _picker.pickMultiImage();
    pickedimage.forEach((element) {
      file = File('');
      file = File(element.path);
      filelist.add(file);
      imlist.value.add(Image.file(file));
      update();
    });

    //       storeimage=Container(
    //         height: 150,
    //         child: Image(
    //   image: FileImage(im,

    //   ),
    // ),
    //       );
    //print(storeimage);
  }

  Future<String> uploadFile(f) async {
    final filename = basename(f.path);
    final destination = "/Interventions/$filename";
    // FirebaseStorage storage = FirebaseStorage.instance;
    // Reference refimage = storage.ref().child("/stores_main/$filename");
    final ref = FirebaseStorage.instance.ref(destination);
    UploadTask uploadtask = ref.putFile(f);
    // TaskSnapshot dowurl = await (await uploadtask.whenComplete(() {}));
    final snapshot = await uploadtask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    //var url = dowurl.toString();
    print(urlDownload);
    return urlDownload;
  }
}
