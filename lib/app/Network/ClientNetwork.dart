import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:home_services/app/Network/UserNetwork.dart';
import 'package:home_services/app/models/Client.dart';
import 'package:home_services/app/models/User.dart';

class ClientNetwork {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference clientsRef =
      FirebaseFirestore.instance.collection('Client');
  UserNetwork userServices = UserNetwork();

  Future<List<Client>> getClientsList() async {
    int index = 0;
    List<Client> clients = [];

    QuerySnapshot snapshot = await clientsRef.get();
    var list = snapshot.docs.map((e) => e.data()).toList();
    snapshot.docs.forEach((element) async {
      Client client = Client.fromFire(element);
      clients.add(client);
      clients[index].id = element.id;

      //get user
      DocumentReference dr = element['user'];
      User user = User(
          id: dr.id,
          creation_date: Timestamp.now(),
          email: '',
          last_login: Timestamp.now(),
          password: '',
          username: '');
      user = await userServices.getUserById(user.id ?? '');
      clients[index].user = user;

      index++;

      print(client.user.email);
    });

    return clients;
  }

  getClientRef(String id) {
    DocumentReference ref = clientsRef.doc(id);
    return ref;
  }

  Future<Client> getClientById(String id) async {
    Client client;
    DocumentSnapshot snapshot = await clientsRef.doc(id).get();
    client = Client.fromFire(snapshot.data());
    client.id = snapshot.id;

    //get user
    DocumentReference dr = snapshot['user'];
    User user = User(
        id: dr.id,
        creation_date: Timestamp.now(),
        email: '',
        last_login: Timestamp.now(),
        password: '',
        username: '');

    user = await userServices.getUserById(user.id ?? '');
    print(user);
    client.user = user;
    // client.user = user;

    return client;
  }

  void updateFcmToken(String id, String token) async {
    await clientsRef.doc(id).update({"fcmToken": token});
  }
}
