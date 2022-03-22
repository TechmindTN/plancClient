import 'category_model.dart';
import 'e_provider_model.dart';
import 'parents/media_list_model.dart';

class EService extends MediaListModel {
  String title;
  String description;
  double minPrice;
  double maxPrice;
  String pricing;
  double rate;
  int totalReviews;
  double duration;
  List<Category> categories;
  List<Category> subCategories;
  EProvider eProvider;
  EProvider eCompany;

  EService(
      {this.title,
      this.description,
      this.minPrice,
      this.maxPrice,
      this.pricing,
      this.rate,
      this.totalReviews,
      this.duration,
      this.categories,
      this.subCategories,
      this.eProvider,
      this.eCompany});

  EService.fromJson(Map<String, dynamic> json) {
    try {
      title = json['title'];
      description = json['description'];
      minPrice = json['min_price']?.toDouble();
      maxPrice = json['max_price']?.toDouble();
      pricing = json['pricing'];
      rate = json['rate']?.toDouble();
      totalReviews = json['total_reviews'];
      duration = json['duration']?.toDouble();
      if (json['categories'] != null) {
        categories = <Category>[];
        json['categories'].forEach((v) {
          categories.add(Category.fromJson(v));
        });
      }
      if (json['sub_categories'] != null) {
        subCategories = <Category>[];
        json['sub_categories'].forEach((v) {
          subCategories.add(Category.fromJson(v));
        });
      }
      eProvider = json['e_provider'] != null ? EProvider.fromJson(json['e_provider']) : null;
      eCompany = json['e_company'] != null ? EProvider.fromJson(json['e_company']) : null;
      super.fromJson(json);
    } catch (e) {
      print(e);
      print(json['id']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['min_price'] = this.minPrice;
    data['max_price'] = this.maxPrice;
    data['pricing'] = this.pricing;
    data['rate'] = this.rate;
    data['total_reviews'] = this.totalReviews;
    data['duration'] = this.duration;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.subCategories != null) {
      data['sub_categories'] = this.subCategories.map((v) => v.toJson()).toList();
    }
    if (this.media != null) {
      data['media'] = this.media.map((v) => v.toJson()).toList();
    }
    if (this.eProvider != null) {
      data['e_provider'] = this.eProvider.toJson();
    }
    if (this.eCompany != null) {
      data['e_company'] = this.eCompany.toJson();
    }
    return data;
  }

  @override
  bool get hasData {
    return id != null && title != null && description != null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is EService &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description &&
          rate == other.rate &&
          eProvider == other.eProvider &&
          eCompany == other.eCompany;

  @override
  int get hashCode => super.hashCode ^ title.hashCode ^ description.hashCode ^ rate.hashCode ^ eProvider.hashCode ^ eCompany.hashCode;
}
