import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Role.dart';

class RoleNetwork{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference rolesRef = FirebaseFirestore.instance.collection('Role');


  Future<Role> getRoleById(String id) async {
    Role role;

    DocumentSnapshot snapshot = await rolesRef.doc(id).get();
    role = Role.fromFire(snapshot.data());
    role.id = snapshot.id;
    print(role.name);

    return role;
  }
getAllRoles() async {
  List<Role> roles = [];

    QuerySnapshot snapshot = await rolesRef.get();
    var list = snapshot.docs.map((e) => e.data()).toList();
    Future.delayed(Duration(seconds: 2),(){
          print(snapshot.size);

    });
    snapshot.docs.forEach((element) async {
      Role role = Role.fromFire(element);

      role.id = element.id;
      roles.add(role);
      print('object');
      print(role.name);
    });
    return roles;
}
  getRoleRef(String id)  {
    DocumentReference ref= firestore.doc('Role/'+ id);
    return ref;
  }

}