class Payment {
  String id;
  final String name;
  final String type;
  final String icon;
  Payment({this.id, this.name, this.type, this.icon});

  Payment.fromFire(fire)
      : name = fire['name'],
        type = fire['type'],
        icon = fire['icon'],
        id = null;

  printPayment() {
    print(this.id);
    print(this.name);
    print(this.type);
  }

  Map<String, dynamic> tofire() => {
        'name': name,
        'type': type,
        'icon': icon,
      };
}
