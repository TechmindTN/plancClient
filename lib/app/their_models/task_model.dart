import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Bill.dart';
import '../models/Client.dart';
import '../models/Payment.dart';
import '../models/Provider.dart';
import 'address_model.dart';
import 'e_service_model.dart';
import 'parents/model.dart';
import 'payment_method_model.dart';
import 'user_model.dart';

class Task extends Model {
  String id;
  Timestamp dateTime;
  String description;
  String status;
  // String progress;
  // double total;
  // double tax;
  // double rate;
  Client client;
  ServiceProvider eService;
  Address address;
  Bill bill;

  Task(
      {this.id,
      this.dateTime,
      this.description,
      this.status,
      // this.progress,
      // this.total,
      // this.tax,
      // this.rate,
      this.client,
      this.eService,
      this.address,
      this.bill});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateTime = json['creation_date'];
    ;
    description = json['description'];
    status = json['states'];
    // progress = json['progress'];
    // total = json['total']?.toDouble();
    // rate = json['rate']?.toDouble();
    // tax = json['tax']?.toDouble();
    client = json['client'] != null ? Client.fromFire(json['client']) : null;
    bill = json['bill'] != null ? Bill.fromFire(json['bill']) : null;
    eService = json['e_service'] != null
        ? ServiceProvider.fromFire(json['e_service'])
        : null;
    address =
        json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['date_time'] = this.dateTime;
    data['description'] = this.description;
    data['status'] = this.status;
    // data['progress'] = this.progress;
    // data['total'] = this.total;
    // data['tax'] = this.tax;
    // data['rate'] = this.rate;
    if (this.client != null) {
      data['user'] = this.client.tofire();
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.eService != null) {
      data['e_service'] = this.eService.tofire();
    }
    return data;
  }
}
