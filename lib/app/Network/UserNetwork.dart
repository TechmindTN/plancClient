import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_services/app/Network/RoleNetwork.dart';
import 'package:home_services/app/models/Role.dart';

import '../models/Chat.dart';
import '../models/Client.dart';
import '../models/Message.dart';
import '../models/Notification.dart';
import '../models/User.dart';
import 'MessageNetwork.dart';

class UserNetwork {
  static DocumentReference dr;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference usersRef = FirebaseFirestore.instance.collection('User');
  CollectionReference rolesRef = FirebaseFirestore.instance.collection('Role');
  CollectionReference clientRef =
      FirebaseFirestore.instance.collection('Client');
  RoleNetwork roleServices = RoleNetwork();
  MessageNetwork _messageNetwork = MessageNetwork();

  getClientRoleByName(String name) async {
    Role r;
    QuerySnapshot q =
        await rolesRef.where('name', isEqualTo: name).limit(1).get();
    r = Role.fromFire(q.docs.first.data());
    r.id = q.docs.first.id;
    return r;
  }

  getRoleRef(String id) {
    return firestore.doc('Role/' + id);
  }

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
    // DocumentReference dr = snapshot['role'];
    // Role role = Role(name: '', id: dr.id);
    // role = await roleServices.getRoleById(role.id ?? '');
    // user.role = role;

    return user;
  }

  Future<Client> getClientByUserRef(DocumentReference dr) async {
    Client c = new Client();
    try {
      print('document :' + dr.toString());
      QuerySnapshot snapshot =
          await clientRef.where('user', isEqualTo: dr).limit(1).get();
      c = Client.fromFire(snapshot.docs.first.data());
      c.id = snapshot.docs.first.id;
      print(c.first_name);
      return c;
    } catch (e) {}
  }

  Future<User> getUserByEmailPassword(String email, String password) async {
    User user;
    bool ok;
    try {
      QuerySnapshot snapshot = await usersRef
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      print(snapshot.size);
      if (snapshot.size == 0) return null;
      user = User.fromFire(snapshot.docs.first.data());
      user.id = snapshot.docs.first.id;
      //get user role
      DocumentReference dr = snapshot.docs.first['role'];
      Role role = Role(name: '', id: dr.id);
      role = await roleServices.getRoleById(role.id ?? '');
      user.role = role;
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
    data['creation_date'] = Timestamp.now();
    Role r = await getClientRoleByName("Client");
    DocumentReference rf = await getRoleRef(r.id);
    data['role'] = rf;
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

  Future<DocumentReference> addClient(c, DocumentReference d) async {
    var data = c.tofire();
    print('Docum' + d.toString());
    data["user"] = d;
    print(data);
    DocumentReference added = await clientRef.add(data);
    print('Client added :' + added.id);
    return added;
  }

  Future<List<User>> getUsersByRole(String role_name) async {
    List<User> users = [];
    User user;
    var id;
    await roleServices.getRoleIdByName(role_name).then((val) => id = val);
    var ref = roleServices.getRoleRef(id);
    QuerySnapshot q = await usersRef.where('role', isEqualTo: ref).get();
    q.docs.forEach((element) {
      user = User.fromFire(element.data());
      user.id = element.id;
      users.add(user);
    });

    return users;
  }

  Future<List<Notification>> getNotifications(String id) async {
    List<Notification> notifs = [];
    Notification notif;
    QuerySnapshot q = await usersRef.doc(id).collection('Notification').get();
    print("notif length " + q.docs.length.toString());
    q.docs.forEach((element) {
      print('data notif ' + element.data().toString());
      notif = Notification.fromFire(element.data());
      notif.id = element.id;
      notifs.add(notif);
      print('notif here ' + notif.toString());
    });

    return notifs;
  }

  void RegisterNotification(String id, data) async {
    await usersRef.doc(id).collection('Notification').add(data);
    print("notification registered !");
  }

  Future<List<Chat>> getUserChats(String id) async {
    List<Chat> ChatList = [];
    var ref = getUserRef(id);
    QuerySnapshot q = await usersRef.doc(id).collection('Chat').get();
    q.docs.forEach((element) async {
      Chat c = Chat();
      c.id = element.id;
      var user = await getUserById(element.data()['user'].id);
      Stream<List<Message>> list = _messageNetwork.getChatMessages(c.id, id);
      c.user = (user);
      c.conversation = list as List<Message>;
      ChatList.add(c);
    });
  }
}
