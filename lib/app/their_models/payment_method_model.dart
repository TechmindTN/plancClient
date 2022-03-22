import 'parents/model.dart';

class PaymentMethod extends Model {
  String id;
  String name;
  String description;
  String logo;
  String route;
  bool isDefault;

  PaymentMethod(this.id, this.name, this.description, this.route, this.logo, {this.isDefault = false});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
