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

  CategoryNetwork categoryServices = CategoryNetwork();
  ServiceProviderNetwork providerServices = ServiceProviderNetwork();

  Future<DocumentReference> addIntervention(data) async {
    var d = await InterventionsRef.add(data);
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
    print(intervention.description);
    return intervention;
  }

  Future<void> updateIntervention(String id) async {
    await InterventionsRef.doc(id).update({"states": "ongoing"});
  }
}
