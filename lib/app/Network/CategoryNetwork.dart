import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Category.dart';

class CategoryNetwork {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference categoryRef =
      FirebaseFirestore.instance.collection('Category');

  Future<List<Category>> getCategoriesByProvider(String id) async {
    List<Category> categories = [];
    Category category;
    bool parentExist = false;

    // do{
    //   parentExist=false;
    //   DocumentSnapshot snapshot = await categoryRef.doc(id).get();
    // category = Category.fromFire(snapshot.data());
    // category.id = snapshot.id;
    // // category.parent=snapshot['parent'];
    // categories.add(category);
    // if(snapshot['parent']!=null){
    //   parentExist=true;
    //   id=snapshot['parent'].id;
    // }
    // // print(category.name);
    // }
    // while(parentExist);
    // print(categories.length);
    for (int i = 0; i < 7; i++) {
      parentExist = false;
      DocumentSnapshot snapshot = await categoryRef.doc(id).get();
      category = Category.fromFire(snapshot.data());
      category.id = snapshot.id;
      // category.parent=snapshot['parent'];
      categories.add(category);
      // print(categories.length);

      if (snapshot['parent'] != null) {
        // parentExist=true;
        id = snapshot['parent'].id;
      } else {
        return categories;
      }
      // return  categories;
    }
  }

  // return category;
  Future<List<Category>> getCategoryList() async {
    List<Category> categories = List();
    Category category;
    QuerySnapshot snapshot = await categoryRef.get();
    snapshot.docs.forEach((element) {
      category = Category.fromFire(element.data());
      category.id = element.id;
      categories.add(category);
    });

    return categories;
  }

  Future<Category> getCategoryById(String id) async {
    Category category;
    DocumentSnapshot snapshot = await categoryRef.doc(id).get();
    category = Category.fromFire(snapshot.data());
    category.id = snapshot.id;

    return category;
  }

  getCategoryRef(String id) {
    DocumentReference ref = categoryRef.doc('Category/' + id);
    return ref;
  }
}
