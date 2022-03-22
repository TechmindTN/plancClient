import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_services/app/models/Payment.dart';


class Bill{
   String id;
   Payment payment;
  final double service_fee;
  final double workforce_fee;
  final double study_fee;
  final double discount;
  final Timestamp date;
  final String state;
  final double total_price;
  List<Map<String,dynamic>> materials;

  Bill({ this.id, this.payment,  this.service_fee,  this.workforce_fee,  this.study_fee,  this.discount,  this.date,  this.state,  this.total_price});
  
  
  Bill.fromFire(fire)
    : service_fee=fire['service_fee'].toDouble(),
    workforce_fee=fire['workforce_fee'].toDouble(),
    study_fee=fire['study_fee'].toDouble(),
    discount=fire['discount'].toDouble(),
    date=fire['date'],
    state=fire['state'],
    total_price=fire['total_price'].toDouble(),
    id=null;


    printBill(){
     
  print(this.id);
  
  this.payment.printPayment();
  print(this.service_fee);
  print(this.workforce_fee);
  print(this.study_fee);
  print(this.discount);
  print(this.date);
  print(this.state);
  print(this.total_price);
  // print(materials!.length);
  Future.delayed(Duration(seconds: 2),
  () {
    materials.forEach((element) {
    element.forEach((key, value) {
      print(key+' : '+value.toString());

    });
   });
  }
  );
    }
}