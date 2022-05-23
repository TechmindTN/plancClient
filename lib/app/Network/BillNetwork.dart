import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_services/app/Network/MaterialNetwork.dart';
import 'package:home_services/app/Network/PaymentNetwork.dart';
import 'package:home_services/app/models/Material.dart';
import 'package:home_services/app/models/Payment.dart';

// import '../models/Enums/PaymentEnum.dart';
import '../models/Bill.dart';

class BillNetwork {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference billsRef = FirebaseFirestore.instance.collection('Bill');
  PaymentNetwork paymentServices = PaymentNetwork();
  MaterialNetwork materialServices = MaterialNetwork();

  Future<List<Bill>> getBillsList() async {
    List<Bill> bills = [];

    QuerySnapshot snapshot = await billsRef.get();
    // var list = snapshot.docs.map((e) => e.data()).toList();

    snapshot.docs.forEach((element) async {
      Bill bill = Bill.fromFire(element);
      bill.id = element.id;

      //get bill materials
      bill.materials = [];
      List<dynamic> list = element['materials'];
      list.forEach((value) async {
        Material material =
            await materialServices.getMaterialById(value['material'].id);
        Map<String, dynamic> matMap = {
          "material": material,
          "exist": value['exist'],
          "quantity": value['quantity'],
          "total_price": value['total_price'],
        };
        bill.materials.add(matMap);
      });

      //get bill payment
      DocumentReference dr = element['payment'];
      Payment payment = Payment(name: '', id: dr.id, type: '');
      payment = await paymentServices.getPaymentById(payment.id);
      bill.payment = payment;

      bills.add(bill);
    });
    Future.delayed(Duration(seconds: 2), () {
      print(bills.length);
    });
    return bills;
  }

  Future<Bill> getBillById(String id) async {
    Bill bill;
    DocumentSnapshot snapshot = await billsRef.doc(id).get();
    bill = Bill.fromFire(snapshot.data());
    bill.id = snapshot.id;

    //get materials
    bill.materials = [];
    if (snapshot.data().containsKey('materials') &&
        snapshot['materials'] != null) {
      List<dynamic> list = snapshot['materials'];
      list.forEach((value) async {
        Material material =
            await materialServices.getMaterialById(value['material'].id);
        Map<String, dynamic> matMap = {
          "material": material,
          "exist": value['exist'],
          "quantity": value['quantity'],
          "total_price": value['total_price'],
        };
        bill.materials.add(matMap);
      });
    } else {
      QuerySnapshot matsnaps =
          await billsRef.doc(id).collection('Material').get();
      matsnaps.docs.forEach((element) async {
        Material material = await materialServices
            .getMaterialById(element.data()['material'].id);
        Material mat = Material.fromFire(element.data());
        mat.id = element.id;
        Map<String, dynamic> matMap = {
          "material": material,
          "quantity": element.data()['count'],
          "total_price": element.data()['price'],
        };
        bill.materials.add(matMap);
      });
    }
    //get bill payment
    if (snapshot.data().containsKey('payment') && snapshot['payment'] != null) {
      DocumentReference dr = snapshot['payment'];
      Payment payment = await paymentServices.getPaymentById(dr.id);
      bill.payment = payment;
    }
    // Payment payment = Payment(name: '', id: dr.id);

    return bill;
  }
}
