import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_services/app/Network/BillNetwork.dart';
import 'package:home_services/app/Network/CategoryNetwork.dart';
import 'package:home_services/app/Network/ClientNetwork.dart';
import 'package:home_services/app/Network/ServiceProviderNetwork.dart';
import 'package:home_services/app/Network/UserNetwork.dart';
import 'package:home_services/app/models/Bill.dart';
import 'package:home_services/app/models/Category.dart';
import 'package:home_services/app/models/Client.dart';
import 'package:home_services/app/models/Intervention.dart';

import '../models/Media.dart';
import '../models/Provider.dart';
import 'MediaNetwork.dart';
import 'NotifAPI.dart';

class InterventionNetwork {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference InterventionsRef =
      FirebaseFirestore.instance.collection('Intervention');

  CollectionReference providers =
      FirebaseFirestore.instance.collection('Provider');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('Category');
  CollectionReference clients = FirebaseFirestore.instance.collection('Client');
  UserNetwork userServices = UserNetwork();
  ClientNetwork clientServices = ClientNetwork();
  BillNetwork billServices = BillNetwork();
  MediaNetwork mediaServices = MediaNetwork();

  CategoryNetwork categoryServices = CategoryNetwork();
  ServiceProviderNetwork providerServices = ServiceProviderNetwork();

  Future<DocumentReference> addIntervention(data, ok) async {
    var d = await InterventionsRef.add(data);

    await providerServices.getProviderById(data["provider"].id).then((value) {
      Api().sendFcm(
          'Demande d\'intervention',
          'un client a demandé votre intervention !',
          'dIZuudoNSG-uQMT4pHyHLC:APA91bG1fHVW7OKseXRsNO1UTX6JNfuPHgmEnBAHrf2gKnFfwy51l3E1GBqV0Il-Af_DCdgD4zqdQlBHyYbY_MWAjYtvo3ifeZGtX-oFx0Yf9HBCNfUYcC3Jq59OPOb_9wHxhvHsP63I');
    });

    return d;
  }

  DocumentReference getClientRef(String id) {
    return firestore.doc('Client/' + id);
  }

  Future<List<Intervention>> getInterventionsList(String id) async {
    List<Intervention> interventions = [];

// if(Interventions.isNotEmpty){
//   Interventions.clear();
// }
    var ref = getClientRef(id);
    print(ref);
    QuerySnapshot snapshot =
        await InterventionsRef.where('client', isEqualTo: ref).get();
    snapshot.docs.forEach((element) async {
      print(element.data());
      DocumentReference dr = element['provider'];

      Intervention intervention = Intervention.fromFire(element);
      // interventions.add(intervention);
      intervention.id = element.id;
      // intervention.id = element.id;
      intervention.media = [];
      intervention.media =
          await mediaServices.getMediaListByIntervention(intervention.id);
      //get Branches
      if (dr != null) {
        intervention.provider = await providerServices.getProviderById(dr.id);
      } else {
        intervention.provider = null;
      }
      // get category
      dr = element['category'];
      Category category = await categoryServices.getCategoryById(dr.id);
      intervention.category = category;

      //get client
      dr = element['client'];

      Client client = await clientServices.getClientById(dr.id);
      intervention.client = client;

      //get bill
      dr = element['bill'];
      if (dr != null) {
        Bill bill = await billServices.getBillById(dr.id);
        intervention.bill = bill;
      }

      interventions.add(intervention);
    });
    print('leeen' + interventions.length.toString());
    return interventions;
  }

  Future<Intervention> getInterventionById(String id) async {
    DocumentSnapshot snapshot = await InterventionsRef.doc(id).get();

    DocumentReference dr = snapshot['provider'];

    Intervention intervention = Intervention.fromFire(snapshot);
    // interventions.add(intervention);
    intervention.id = snapshot.id;
    // intervention.id = element.id;

    //get Branches
    intervention.provider = await providerServices.getProviderById(dr.id);

    // get category
    dr = snapshot['category'];
    Category category = await categoryServices.getCategoryById(dr.id);
    intervention.category = category;

    //get client
    dr = snapshot['client'];

    Client client = await clientServices.getClientById(dr.id);
    intervention.client = client;

    //get bill
    dr = snapshot['bill'];

    Bill bill = await billServices.getBillById(dr.id);
    intervention.bill = bill;

    print('media intervention ' + intervention.media.length.toString());
    return intervention;
  }

  Future<void> updateIntervention(
      String id, int number, ServiceProvider prov) async {
    switch (number) {
      case 1:
        await InterventionsRef.doc(id).update({"states": "ongoing"});
        Api().sendFcm(
            'Facture acceptée',
            'un client a accepté la facture que vous avez suggesté !',
            prov.fcmToken);
        break;
      case 2:
        await InterventionsRef.doc(id).update({"states": "refused"});
        Api().sendFcm(
            'Facture refusée',
            'un client a refusé la facture que vous avez suggesté !',
            prov.fcmToken);

        break;
      case 3:
        await InterventionsRef.doc(id).update({"states": "completed"});
        Api().sendFcm('affaire cloturé',
            'une intervention est affirmé par le client !', prov.fcmToken);

        break;
    }
  }
}
