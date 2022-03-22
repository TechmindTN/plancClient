import 'package:home_services/app/their_models/faq_model.dart';

import 'parents/model.dart';

class FaqCategory extends Model {
  String id;
  String name;
  List<Faq> faqs;

  FaqCategory({this.id, this.name, this.faqs});

  FaqCategory.fromJson(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'] != null ? jsonMap['name'].toString() : '';
      faqs = jsonMap['faqs'] != null ? List.from(jsonMap['faqs']).map((element) => Faq.fromJSON(element)).toList() : null;
    } catch (e) {
      id = '';
      name = '';
      faqs = [];
      print(e);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
