/*
 * Copyright (c) 2020 .
 */
import 'parents/model.dart';
import 'user_model.dart';

class Review extends Model {
  String id;
  double rate;
  String review;
  String datetime;
  User user;

  Review({this.id, this.rate, this.review, this.datetime, this.user});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rate = json['rate']?.toDouble();
    review = json['review'];
    datetime = json['datetime'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['rate'] = this.rate;
    data['review'] = this.review;
    data['datetime'] = this.datetime;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}
