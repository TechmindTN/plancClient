import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_services/app/models/Provider.dart';

import '../models/Branch.dart';

class BranchNetwork {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference providersRef =
      FirebaseFirestore.instance.collection('Provider');
  
  Future<List<Branch>> getBranchListByProvider(String id) async {
    List<Branch> branches = [];

    QuerySnapshot snapshot =
        await providersRef.doc(id).collection('Branch').get();
    var list = snapshot.docs.map((e) => e.data()).toList();

    list.forEach((element) {
      print(element);
    });
    snapshot.docs.forEach((element) async {
      Branch branch = Branch.fromFire(element);

      branch.id = element.id;

      branches.add(branch);
    });
    return branches;
  }

  Future<Branch> getBranchById(
      { String id,  String providerId}) async {
    Branch branch;
    DocumentSnapshot snapshot =
        await providersRef.doc(providerId).collection('Branch').doc(id).get();
    branch = Branch.fromFire(snapshot.data());
    branch.id = snapshot.id;

    //get branch serviceProvider
    DocumentReference dr = snapshot['provider'];
    ServiceProvider serviceProvider = ServiceProvider(
        name: '',
        id: dr.id,
        description: '',
        media: [],
        profile_photo: '',
        website: '');


    return branch;
  }



  addBranch(branch,String id){
      Map<String,dynamic> mapdata=branch.tofire();
      providersRef.doc(id).collection('Branch').add(mapdata).then((value) => print('added branch'));
  }
}
