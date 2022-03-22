/*
 * Copyright (c) 2020 .
 */

import 'parents/media_list_model.dart';
import 'review_model.dart';

class EProvider extends MediaListModel {
  String about;
  String address;
  bool available;
  String experience;
  String name;
  String phone;
  double rate;
  List<Review> reviews;
  int totalReviews;
  bool verified;
  int tasksInProgress;

  EProvider({this.about, this.address, this.available, this.experience, this.name, this.phone, this.rate, this.reviews, this.totalReviews, this.verified, this.tasksInProgress});

  EProvider.fromJson(Map<String, dynamic> json) {
    about = json['about'];
    address = json['address'];
    available = json['available'];
    experience = json['experience'];
    name = json['name'];
    phone = json['phone'];
    rate = json['rate']?.toDouble();
    if (json['reviews'] != null) {
      reviews = <Review>[];
      json['reviews'].forEach((v) {
        reviews.add(Review.fromJson(v));
      });
    }
    totalReviews = json['total_reviews'];
    verified = json['verified'];
    tasksInProgress = json['tasks_in_progress'];
    super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['about'] = this.about;
    data['address'] = this.address;
    data['available'] = this.available;
    data['experience'] = this.experience;
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['rate'] = this.rate;
    if (this.reviews != null) {
      data['reviews'] = this.reviews.map((v) => v.toJson()).toList();
    }
    data['total_reviews'] = this.totalReviews;
    data['verified'] = this.verified;
    data['tasks_in_progress'] = this.tasksInProgress;
    return data;
  }
}
