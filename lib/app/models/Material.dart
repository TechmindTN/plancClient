class Material {
  String id;
  final String name;
  final String supplier;
  final double price;
  final String description;
  final List<dynamic> media;

  Material(
      {this.id,
       this.name,
       this.supplier,
       this.price,
       this.description,
       this.media});

  Material.fromFire(fire)
      : name = fire['name'],
        supplier = fire['supplier'],
        price = fire['price'].toDouble(),
        description = fire['description'],
        media = fire['media'],
        id = null;

  printMaterial() {
    print(this.id);
    print(this.name);
    print(this.supplier);
    print(this.price);
    print(this.description);
    this.media.forEach((element) {
      print(element);
    });

    Map<String, dynamic> tofire() => {
        'name': name,
        'supplier': supplier,
        'price': price,
        'description': description,
        'media': media,
        
      };
  }
}
