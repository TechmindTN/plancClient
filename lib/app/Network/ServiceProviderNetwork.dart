import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:home_services/app/Network/BranchNetwork.dart';
import 'package:home_services/app/Network/CategoryNetwork.dart';
import 'package:home_services/app/Network/UserNetwork.dart';
import 'package:home_services/app/models/Category.dart';
import 'package:home_services/app/models/Provider.dart';
import 'package:home_services/app/models/User.dart';

import '../modules/home/controllers/home_controller.dart';
import 'MediaNetwork.dart';

List<ServiceProvider> futprov;

class ServiceProviderNetwork {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference providersRef =
      FirebaseFirestore.instance.collection('Provider');
  UserNetwork userServices = UserNetwork();
  CategoryNetwork categoryServices = CategoryNetwork();
  BranchNetwork branchServices = BranchNetwork();
  MediaNetwork mediaServices = MediaNetwork();

  // UserNetwork userServices = UserNetwork();

  Future<List<ServiceProvider>> getProvidersList() async {
    try {
      // int index = 0;
      List<ServiceProvider> providers = [];

// if(providers.isNotEmpty){
//   providers.clear();
// }

      QuerySnapshot snapshot = await providersRef.get();
      print('snapshot length ' + snapshot.docs.length.toString());
      // var list = snapshot.docs.map((e) => e.data()).toList();
      snapshot.docs.forEach((element) async {
        ServiceProvider serviceProvider = ServiceProvider.fromFire(element);
        // providers.add(serviceProvider);
        serviceProvider.id = element.id;
        print('element ' + serviceProvider.description);
        // serviceProvider.id = element.id;

        //get Branches
        // serviceProvider.branches =
        //     await branchServices.getBranchListByProvider(serviceProvider.id);

        // get category
        // List<dynamic> drList = element['categories'];
        // List<Category> categories = [];
        // serviceProvider.categories = categories;
        List<Category> categories = [];
        List<dynamic> drList = element['categories'];
        print('service prov name ' +
            serviceProvider.name +
            'drlist' +
            drList.toString());
        drList.forEach((element) async {
          Category category =
              await categoryServices.getCategoryById(element.id);
          categories.add(category);
        });

        // drList.forEach((value) async {
        //   Category category = Category(name: '', parent: null, id: value.id);
        //   category = await categoryServices.getCategoryById(category.id ?? '');
        //   serviceProvider.categories.add(category);
        //   print(serviceProvider.categories.first.name);
        // });

        //get media list

        serviceProvider.media =
            await mediaServices.getMediaListByProvider(serviceProvider.id);

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
        serviceProvider.user = user;
        // serviceProvider.user = user;

        serviceProvider.categories = categories;
        providers.add(serviceProvider);
        print('prov length all ' + providers.length.toString());
        print('service prov name ' +
            serviceProvider.name +
            'catlist' +
            serviceProvider.categories.toString());
        // index++;
      });
      print('providers done');
      print('providers documents length ' + providers.length.toString());
      print('providers ' + providers.toString());
      return providers;
    } catch (e) {
      print(e);
      print('can\'t get providers');
    }
  }

  addProvider(ServiceProvider serviceProvider) {
    Map<String, dynamic> mapdata = serviceProvider.tofire();
    print('our user is ' + UserNetwork.dr.id);
    mapdata['user'] = UserNetwork.dr;
    providersRef.add(mapdata).then((value) {
      print('provider added');
      // branchServices.addBranch(serviceProvider.branches.first, value.id);
    });
  }

  Future<ServiceProvider> getProviderByUserRef(DocumentReference ref) async {
    try {
      print('hello from network');

      ServiceProvider serviceProvider;
      QuerySnapshot snapshot =
          await providersRef.where('user', isEqualTo: ref).get();
      print('hello from network 2');
      // snapshot..docs.first;
      // DocumentSnapshot snapshot = await providersRef.doc(id).get();
      serviceProvider = ServiceProvider.fromFire(snapshot.docs.first.data());
      serviceProvider.id = snapshot.docs.first.id;

      //get Branches
      // serviceProvider.branches =
      //     await branchServices.getBranchListByProvider(snapshot.docs.first.id);
      print('branches done');
      // get category
      List<dynamic> drList = snapshot.docs.first['categories'];
      List<Category> categories = [];
      serviceProvider.categories = categories;
// print(drList.length);
      drList.forEach((value) async {
        List<Category> subCategories = [];
        Category category = Category(name: '', parent: null, id: value.id);
        subCategories =
            await categoryServices.getCategoriesByProvider(category.id ?? '');

        serviceProvider.categories.addAll(subCategories);
        print(serviceProvider.categories.length);
      });
      //  print(serviceProvider.categories!.length);
      serviceProvider.categories.forEach((element) {
        print(element.name);
      });
      return serviceProvider;
    } catch (e) {
      print('error in network ' + e);
    }
  }

  Future<ServiceProvider> getProviderById(String id) async {
    ServiceProvider serviceProvider;
    DocumentSnapshot snapshot = await providersRef.doc(id).get();
    serviceProvider = ServiceProvider.fromFire(snapshot.data());
    serviceProvider.id = snapshot.id;

    // get category
    List<dynamic> drList = snapshot['categories'];
    List<Category> categories = [];
    serviceProvider.categories = categories;
// print(drList.length);
    drList.forEach((value) async {
      List<Category> subCategories = [];
      Category category = Category(name: '', parent: null, id: value.id);
      subCategories =
          await categoryServices.getCategoriesByProvider(category.id ?? '');

      serviceProvider.categories.addAll(subCategories);
      print(serviceProvider.categories.length);
    });
    //  print(serviceProvider.categories!.length);
    serviceProvider.categories.forEach((element) {
      print(element.name);
    });

    //get Branches
    // serviceProvider.branches =
    //     await branchServices.getBranchListByProvider(serviceProvider.id);

    //get user
    DocumentReference dr = snapshot['user'];
    User user = User(
        id: dr.id,
        creation_date: Timestamp.now(),
        email: '',
        last_login: Timestamp.now(),
        password: '',
        username: '');

    user = await userServices.getUserById(user.id);
    serviceProvider.user = user;
    // serviceProvider.user = user;

    serviceProvider.categories = categories;

    return serviceProvider;
  }

  Future<List<ServiceProvider>> getProvidersByCategory(
      List<ServiceProvider> list, DocumentReference dr) {
    List<ServiceProvider> category_providers;
    list.forEach((element) {
      if (element.categories.contains(dr)) {
        category_providers.add(element);
      }
    });
  }
}
