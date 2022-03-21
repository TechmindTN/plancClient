class Category {
   String id;
   String name;
   Category parent;
  //  List<Category>? categories;

  Category({ this.id,  this.name, this.parent});

  Category.fromFire(fire)
    : 
    name=fire['name'],
    id=null;
    // parent=fire['parent'];

  printCategory(){
    print(this.id);
    print(this.name);
    print(this.parent);
  }
}
