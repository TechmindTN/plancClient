import 'package:flutter/material.dart';

import '../../common/ui.dart';
import 'parents/media_model.dart';

class Category extends MediaModel {
  String name;
  Color color;
  String icon;
  List<Category> subCategories;

  Category({this.name, this.color, this.subCategories});

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    
    color = Ui.parseColor(json['color'] != null ? json['color'].toString() : '#000000');
    if (json['subCategories'] != null && json['subCategories'] is List) {
      subCategories = <Category>[];
      json['subCategories'].forEach((v) {
        if (v is Map<String, dynamic>) subCategories.add(Category.fromJson(v));
      });
    }
    super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    if (this.media != null) {
      data['media'] = this.media.toJson();
    }
    if (this.subCategories != null) {
      data['subCategories'] = this.subCategories.map((v) => v.toJson()).toList();
    }
    data['color'] = this.color.toString();
    return data;
  }
}
