import 'address_model.dart';
import 'e_service_model.dart';
import 'parents/model.dart';
import 'payment_method_model.dart';
import 'user_model.dart';

class Task extends Model {
  String id;
  DateTime dateTime;
  String description;
  String status;
  String progress;
  double total;
  double tax;
  double rate;
  User user;
  EService eService;
  Address address;
  PaymentMethod paymentMethod;

  Task({this.id, this.dateTime, this.description, this.status, this.progress, this.total, this.tax, this.rate, this.user, this.eService, this.address, this.paymentMethod});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateTime = DateTime.parse(json['date_time']);
    ;
    description = json['description'];
    status = json['status'];
    progress = json['progress'];
    total = json['total']?.toDouble();
    rate = json['rate']?.toDouble();
    tax = json['tax']?.toDouble();
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    paymentMethod = json['payment_method'] != null ? PaymentMethod.fromJson(json['payment_method']) : null;
    eService = json['e_service'] != null ? EService.fromJson(json['e_service']) : null;
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['date_time'] = this.dateTime;
    data['description'] = this.description;
    data['status'] = this.status;
    data['progress'] = this.progress;
    data['total'] = this.total;
    data['tax'] = this.tax;
    data['rate'] = this.rate;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.address != null) {
      data['address'] = this.address.toJson();
    }
    if (this.eService != null) {
      data['e_service'] = this.eService.toJson();
    }
    return data;
  }
}
