import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_services/app/models/Branch.dart';
import 'package:home_services/app/models/Category.dart';
import 'package:home_services/app/models/User.dart';

class ServiceProvider {
  String id;
  String name;
  String description;
  String website;
  List<dynamic> media;
  String profile_photo;
  User user;
  List<Category> categories;
  Map<String, dynamic> open_days;
  String address;
  String city;
  String country;
  String state;
  int zip_code;
  GeoPoint location;
  Map<String, dynamic> social_media;
  int phone;
  double rate;

  ServiceProvider({
    this.id,
    this.name,
    this.description,
    this.website,
    this.media,
    this.profile_photo,
    this.user,
    this.categories,
  });

  Map<String, dynamic> tofire() => {
        'name': name,
        'description': description,
        'website': website,
        'media': media,
        'profile_photo': profile_photo,
      };

  ServiceProvider.fromFire(fire)
      : name = fire['name'],
        description = fire['description'],
        website = fire['website'],
        media = null,
        id = null,
        profile_photo = fire['profile_photo'],
        address = fire['address'],
        // city = fire['city'],
        // country = fire['country'],
        // state = fire['state'],
        // zip_code = fire['zip_code'],
        location = fire['location'],
        social_media = fire['social_media'],
        phone = fire['phone'],
        rate = double.parse(fire['rate'].toString());

  printProvider() {
    print(this.id);
    print(this.name);
    print(this.description);
    print(this.website);
    this.media.forEach((element) {
      print(element);
    });
    print(this.profile_photo);
    Future.delayed(Duration(seconds: 2), () {
      this.user.printUser();
      this.categories.forEach((element) {
        element.printCategory();
      });
    });
  }
}
