import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_services/app/models/User.dart';

class Client {
   String id;
  final String first_name;
  final String last_name;
  final int age;
  final String gender;
  final String home_address;
  final String city;
  final String country;
  final String state;
  final int zip_code;
  final GeoPoint location;
  final Map<String,dynamic> social_media;
  final int phone;
  final String profile_photo;
   User user;
  Client(
    { this.first_name, 
     this.last_name, 
     this.age, 
     this.gender, 
     this.home_address, 
     this.city, 
     this.country, 
     this.state, 
     this.zip_code, 
     this.location, 
     this.social_media, 
     this.phone, 
     this.profile_photo,
     this.id,
     this.user}
    );

    Client.fromFire(fire):
    first_name=fire['first_name'],
    last_name=fire['last_name'],
    age=fire['age'],
    country=fire['country'],
    city=fire['city'],
    state=fire['state'],
    zip_code=fire['zip_code'],
    location=fire['location'],
    home_address=fire['home_address'],
    phone=fire['phone'],
    profile_photo=fire['profile_photo'],
    id=null,
    gender=fire['gender'],
    social_media=fire['social_media'];

 
    printClient(){
   print(this.id);
      print(this.first_name);
   print(this.last_name);
   print(this.age);
   print(this.gender);
   print(this.home_address);
   print(this.city);
   print(this.country);
   print(this.state);
   print(this.zip_code);
   print(this.location.latitude.toString()+' : '+this.location.longitude.toString());
   print(this.phone);
   print(this.profile_photo);
   this.social_media..forEach((key, value) {
     print(key+' : '+value.toString());
   });
this.user.printUser();   

    }

}