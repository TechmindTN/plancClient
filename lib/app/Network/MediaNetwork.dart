import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/Media.dart';
import 'package:path/path.dart';

class MediaNetwork {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference interventiosRef =
      FirebaseFirestore.instance.collection('Intervention');

  Future<List<Media>> getMediaListByProvider(String id) async {
    try {
      print('media here');

      // List<Image> iml = [];
      // List<File> filel = [];
      List<Media> mediaList = [];
      print('media here');
      QuerySnapshot snapshot =
          await interventiosRef.doc(id).collection('Media').get();
      // var list = snapshot.docs.map((e) => e.data()).tofire().toList();
      print('media here');
      snapshot.docs.forEach((element) {
        Media med = Media.fromFire(element);
        med.id = element.id;
        mediaList.add(med);
        print(element);
      });
      // snapshot.docs.forEach((element) async {
      //   filel.add(File(element.path));
      //   iml.add(filel.last);
      // });
      return mediaList;
    } catch (e) {
      print("media test");
      print(e);
    }
  }

  deleteMedia(String id, String providerId) {
    try {
      interventiosRef.doc(providerId).collection("Media").doc(id).delete();
    } catch (e) {
      print("error delete media" + e);
    }
  }

  addMedia(List<Map<String, dynamic>> data, id) {
    print('liistststst ' + data.toString());
    print('idddddddddd' + id);
    data.forEach((element) {
      interventiosRef
          .doc(id)
          .collection('Media')
          .add(element)
          .then((value) => print('Media Added'))
          .catchError((e) {
        print('can not add media');
      });
    });
  }
}
