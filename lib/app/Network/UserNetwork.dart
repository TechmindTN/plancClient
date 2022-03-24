import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_services/app/Network/RoleNetwork.dart';
import 'package:home_services/app/models/Role.dart';

import '../models/Client.dart';
import '../models/User.dart';

class UserNetwork {
  static DocumentReference dr;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference usersRef = FirebaseFirestore.instance.collection('User');
  CollectionReference clientRef =
      FirebaseFirestore.instance.collection('Client');
  RoleNetwork roleServices = RoleNetwork();

  Future<List<User>> getUsersList() async {
    List<User> users = [];

    QuerySnapshot snapshot = await usersRef.get();
    var list = snapshot.docs.map((e) => e.data()).toList();

    snapshot.docs.forEach((element) async {
      User user = User.fromFire(element);

      user.id = element.id;

      //get user role
      DocumentReference dr = element['role'];
      Role role = Role(name: '', id: dr.id);
      role = await roleServices.getRoleById(role.id ?? '');
      user.role = role;

      users.add(user);
    });
    return users;
  }

  getUserRef(String id) {
    DocumentReference ref = firestore.doc('User/' + id);
    return ref;
  }

  Future<User> getUserById(String id) async {
    User user;
    DocumentSnapshot snapshot = await usersRef.doc(id).get();
    user = User.fromFire(snapshot.data());
    user.id = snapshot.id;

    //get user role
    DocumentReference dr = snapshot['role'];
    Role role = Role(name: '', id: dr.id);
    role = await roleServices.getRoleById(role.id ?? '');
    user.role = role;

    return user;
  }

  getUserByEmailPassword(String email, String password) async {
    User user;
    bool ok;
    try {
      QuerySnapshot snapshot = await usersRef
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      print(snapshot.size);
      user = User.fromFire(snapshot.docs.first.data());
      user.id = snapshot.docs.first.id;
      //get user role
      // DocumentReference dr = snapshot.docs.first['role'];
      // Role role = Role(name: '', id: dr.id);
      // role = await roleServices.getRoleById(role.id ?? '');
      // user.role = role;
      print(user.printUser());
      return user;
    } catch (e) {
      // print('User doesn\'t exist');
      return null;
    }
  }

  Future<DocumentReference> addUser(User u) async {
    // var added=await usersRef.add(data).then((value) { print('User Added: '+value.id);
    var data = u.tofire();
    DocumentReference added = await usersRef.add(data);
    print('User Added: ' + added.id);
    print(added);

    dr = added;
    return added;
    // }).catchError((e)=>print('Can\'t add user'));

    // final document=usersRef.doc();
    // print(document.id);
    // await
  }

  Future<DocumentReference> addClient(Client c, DocumentReference d) async {
    var data = c.tofire();
    data["user"] = d;
    print(data);
    DocumentReference added = await clientRef.add(data);
    print('Client added :' + added.id);
    return added;
  }
}
