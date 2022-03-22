import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Branch {
  String id;
   String branch_name;
   Map<String, dynamic> open_days;
   String address;
   String city;
   String country;
   String state;
   int zip_code;
   GeoPoint location;
   Map<String, dynamic> social_media;
   int phone;
   bool is_main;
  Branch(
      { this.branch_name,
       this.open_days,
       this.address,
       this.city,
       this.country,
       this.state,
       this.zip_code,
       this.location,
       this.social_media,
       this.phone,
       this.is_main,
      this.id,
});

Map<String, dynamic> tofire() => {
        'branch_name': branch_name,
        'open_days': open_days,
        'address': address,
        'city': city,
        'country': country,
        'state':state,
        'zip_code':zip_code,
         'phone': phone,
        'is_main': is_main,
        'social_media':social_media,
      };


  Branch.fromFire(fire)
      : branch_name = fire['branch_name'],
        open_days = fire['open_days'],
        address = fire['address'],
        city = fire['city'],
        country = fire['country'],
        state = fire['state'],
        zip_code = fire['zip_code'],
        // location = fire['location'],
        social_media = fire['social_media'],
        phone = fire['phone'],
        is_main = fire['is_main'],
        id = null;



        printBranch(){
        
  print(this.id);
  print(this.branch_name);
  this.open_days.forEach((key, value) {
    print(key+" : "+value);
   });
   print(this.address);
   print(this.city);
   print(this.country);
   print(this.state);
   print(this.zip_code);
   print(this.location.latitude.toString()+" : "+this.location.longitude.toString());
   this.social_media.forEach((key, value) {
     print(key+' : '+value);
   });
   print(this.phone);
   print(this.is_main);
   
        }
}
