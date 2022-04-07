import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:home_services/app/models/Bill.dart';
import 'package:home_services/app/models/Category.dart';
import 'package:home_services/app/models/Client.dart';
import 'package:home_services/app/models/Provider.dart';

class Intervention {
  String id;
  Client client;
  ServiceProvider provider;
  Bill bill;
  Category category;
  final String title;
  final String description;
  final double price;
  List<dynamic> media;
  final Timestamp creation_date;
  final String state;
  final GeoPoint location;
  final String country;
  final String city;
  final String states;
  final int zip_code;
  final String address;
  Timestamp datetime;

  Intervention(
      {this.id,
      this.client,
      this.provider,
      this.bill,
      this.category,
      this.title,
      this.description,
      this.price,
      this.media,
      this.creation_date,
      this.state,
      this.location,
      this.country,
      this.city,
      this.states,
      this.zip_code,
      this.address,
      this.datetime});

  Intervention.fromFire(fire)
      : title = fire['title'],
        description = fire['description'],
        price = fire['price'],
        creation_date = fire['creation_date'],
        city = fire['city'],
        states = fire['states'],
        zip_code = fire['zip_code'],
        location = fire['location'],
        address = fire['address'],
        country = fire['country'],
        state = fire['state'],
        id = null,
        datetime = fire['date_time'];
  // provider = fire['provider'],
  // category = fire['category'],
  // client = fire['client'];

  Map<String, dynamic> tofire() => {
        'client': client,
        'title': title,
        'bill': bill,
        'category': category,
        'country': country,
        'zip_code': zip_code,
        'states': states,
        'state': state,
        'date_time': datetime,
        'location': location,
        'address': address,
        'creation_date': creation_date,
        'city': city,
        'provider': provider,
        'description': description,
        'price': price
      };

  printIntervention() {
    print(this.id);
    print(this.title);
    print(this.description);
    print(this.price);
    print(this.creation_date);
    print(this.state);
    // print(this.location.latitude.toString() +
    //     " : " +
    //     this.location.longitude.toString());
    print(this.country);
    print(this.city);
    print(this.states);
    print(this.zip_code);
    print(this.address);
    print(this.datetime);
    // this.provider.printProvider();
    // this.category.printCategory();
    // this.client.printClient();
    // this.bill.printBill();
  }
}
