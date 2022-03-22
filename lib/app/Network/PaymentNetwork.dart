import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Payment.dart';

class PaymentNetwork {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference paymentRef =
      FirebaseFirestore.instance.collection('Payment');

  Future<List<Payment>> getPaymentList() async {
    List<Payment> payments = [];

    QuerySnapshot snapshot = await paymentRef.get();
    var list = snapshot.docs.map((e) => e.data()).toList();
    snapshot.docs.forEach((element) async {
      Payment payment = Payment.fromFire(element);

      payment.id = element.id;
      payments.add(payment);
      // print(payment.name);
    });
    return payments;
  }

   Future<Payment> getPaymentById(String id) async {
    Payment payment=Payment(name: '', type: '',id: id);
    DocumentSnapshot snapshot = await paymentRef.doc(payment.id).get();
    payment = Payment.fromFire(snapshot.data());
        payment.id=snapshot.id;

    return payment;
  }

  addPayment(data){
    paymentRef.add(data).then((value) => print('Payment Added')).catchError((e){
      print('Can\'t Add Payment');
    });
  }
}
