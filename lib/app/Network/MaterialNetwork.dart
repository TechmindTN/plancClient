import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Material.dart';

class MaterialNetwork{

   FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference materialRef =
      FirebaseFirestore.instance.collection('Material');

  Future<List<Material>> getMaterialList() async {
    List<Material> materials = [];

    QuerySnapshot snapshot = await materialRef.get();
    var list = snapshot.docs.map((e) => e.data()).toList();
    snapshot.docs.forEach((element) async {
      Material material = Material.fromFire(element);

      material.id = element.id;
      materials.add(material);
      // print(material.name);
    });
    return materials;
  }

   Future<Material> getMaterialById(String id) async {
    Material material;
    DocumentSnapshot snapshot = await materialRef.doc(id).get();
    material = Material.fromFire(snapshot.data());
    material.id = snapshot.id;
    return material;
  }

  addMaterial(data){
    materialRef.add(data).then((value) => print('Material Added')).catchError((e){print('can not add material');}   );
  }
}