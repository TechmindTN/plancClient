class Category {
  String id;
  String name;
  String icon;
  Category parent;
  //  List<Category>? categories;

  Category({this.id, this.icon, this.name, this.parent});

  Category.fromFire(fire)
      : name = fire['name'],
        icon = fire['icon'],
        id = null;
  // parent=fire['parent'];

  printCategory() {
    print(this.id);
    print(this.name);
    print(this.icon);
    print(this.parent);
  }
}
