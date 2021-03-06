import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get/get.dart';
import 'package:home_services/app/models/Category.dart';
import 'package:home_services/app/models/User.dart';
import 'package:home_services/app/their_models/e_provider_model.dart';
import 'package:home_services/app/their_models/e_service_model.dart';
import 'package:home_services/app/their_models/faq_category_model.dart';
import 'package:home_services/app/their_models/notification_model.dart';
import 'package:home_services/app/their_models/review_model.dart';
import 'package:home_services/app/their_models/setting_model.dart';
import 'package:home_services/app/their_models/slide_model.dart';
import 'package:home_services/app/their_models/task_model.dart';
import 'package:meta/meta.dart';
import '../their_models/address_model.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../services/global_service.dart';

class MockApiClient {
  final _globalService = Get.find<GlobalService>();

  String get baseUrl => _globalService.global.value.mockBaseUrl;

  final Dio httpClient;
  final Options _options =
      buildCacheOptions(Duration(days: 3), forceRefresh: true);

  MockApiClient({@required this.httpClient}) {
    httpClient.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
  }

  Future<List<User>> getAllUsers() async {
    var response =
        await httpClient.get(baseUrl + "users/all.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<User>((obj) => User.fromFire(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Slide>> getHomeSlider() async {
    final String response =
        await rootBundle.loadString('assets/banner_headers.json');
    final data = await json.decode(response);
    if (data != null) {
      return data['results'].map<Slide>((obj) => Slide.fromJson(obj)).toList();
    }
  }

  Future<User> getLogin() async {
    var response =
        await httpClient.get(baseUrl + "users/user.json", options: _options);
    if (response.statusCode == 200) {
      return User.fromFire(response.data['data']);
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Address>> getAddresses() async {
    var response = await httpClient.get(baseUrl + "users/addresses.json",
        options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<Address>((obj) => Address.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getRecommendedEServices() async {
    var response = await httpClient.get(baseUrl + "services/recommended.json",
        options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getAllEServices() async {
    var response =
        await httpClient.get(baseUrl + "services/all.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getAllEServicesWithPagination(int page) async {
    var response = await httpClient
        .get(baseUrl + "services/all_page_$page.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getFavoritesEServices() async {
    var response = await httpClient.get(baseUrl + "services/favorites.json",
        options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<EService> getEService(String id) async {
    var response =
        await httpClient.get(baseUrl + "services/all.json", options: _options);
    if (response.statusCode == 200) {
      List<EService> _list = response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
      return _list.firstWhere((element) => element.id == id,
          orElse: () => new EService());
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<EProvider> getEProvider(String eProviderId) async {
    var response = await httpClient.get(baseUrl + "providers/eprovider.json",
        options: _options);
    if (response.statusCode == 200) {
      return EProvider.fromJson(response.data['data']);
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Review>> getEProviderReviews(String eProviderId) async {
    var response = await httpClient.get(baseUrl + "providers/reviews.json",
        options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<Review>((obj) => Review.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getEProviderFeaturedEServices(
      String eProviderId) async {
    var response = await httpClient.get(baseUrl + "services/featured.json",
        options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  // getEProviderMostRatedEServices
  Future<List<EService>> getEProviderPopularEServices(
      String eProviderId) async {
    var response = await httpClient.get(baseUrl + "services/popular.json",
        options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getEProviderAvailableEServices(
      String eProviderId) async {
    var response =
        await httpClient.get(baseUrl + "services/all.json", options: _options);
    if (response.statusCode == 200) {
      List<EService> _services = response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
      _services = _services.where((_service) {
        return _service.eProvider.available;
      }).toList();
      return _services;
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getEProviderMostRatedEServices(
      String eProviderId) async {
    var response =
        await httpClient.get(baseUrl + "services/all.json", options: _options);
    if (response.statusCode == 200) {
      List<EService> _services = response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
      _services.sort((s1, s2) {
        return s2.rate.compareTo(s1.rate);
      });
      return _services;
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getEProviderEServicesWithPagination(
      String eProviderId, int page) async {
    var response = await httpClient
        .get(baseUrl + "services/all_page_$page.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Review>> getEServiceReviews(String eServiceId) async {
    var response = await httpClient.get(baseUrl + "services/reviews.json",
        options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<Review>((obj) => Review.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getFeaturedEServices() async {
    var response = await httpClient.get(baseUrl + "services/featured.json",
        options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getPopularEServices() async {
    var response = await httpClient.get(baseUrl + "services/popular.json",
        options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getMostRatedEServices() async {
    var response =
        await httpClient.get(baseUrl + "services/all.json", options: _options);
    if (response.statusCode == 200) {
      List<EService> _services = response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
      _services.sort((s1, s2) {
        return s2.rate.compareTo(s1.rate);
      });
      return _services;
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<EService>> getAvailableEServices() async {
    var response =
        await httpClient.get(baseUrl + "services/all.json", options: _options);
    if (response.statusCode == 200) {
      List<EService> _services = response.data['data']
          .map<EService>((obj) => EService.fromJson(obj))
          .toList();
      _services = _services.where((_service) {
        return _service.eProvider.available;
      }).toList();
      return _services;
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Category>> getAllCategories() async {
    var response = await httpClient.get(baseUrl + "categories/all2.json",
        options: _options);
    List<String> names = [
      'Construction',
      'Installation',
      'Platre & Isolation',
      'Peinture, Mur & Sol',
      'Portes & Fenetre',
      'Destruction',
    ];
    List<String> icons = [
      'assets/img/helmet.png',
      'assets/img/tools.png',
      'assets/img/plastering.png',
      'assets/img/paint-roller.png',
      'assets/img/double-door.png',
      'assets/img/hammer.png',
    ];
    int index = 0;
    if (response.statusCode == 200) {
      List<Category> categories = response.data['results']
          .map<Category>((obj) => Category.fromFire(obj))
          .toList();
      categories.forEach((element) {
        // element.icon=icons[index];
        element.name = names[index];
        // element.media=Media()icons[index];

        index++;
      });
      return categories;
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Category>> getAllWithSubCategories() async {
    var response = await httpClient
        .get(baseUrl + "categories/subcategories.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['results']
          .map<Category>((obj) => Category.fromFire(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Category>> getFeaturedCategories() async {
    var response = await httpClient.get(baseUrl + "categories/featured.json",
        options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<Category>((obj) => Category.fromFire(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Task>> getTasks() async {
    var response =
        await httpClient.get(baseUrl + "tasks/all.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<Task>((obj) => Task.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<Notification>> getNotifications() async {
    var response = await httpClient.get(baseUrl + "notifications/all.json",
        options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<Notification>((obj) => Notification.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  Future<List<FaqCategory>> getCategoriesWithFaqs() async {
    var response =
        await httpClient.get(baseUrl + "help/faqs.json", options: _options);
    if (response.statusCode == 200) {
      return response.data['data']
          .map<FaqCategory>((obj) => FaqCategory.fromJson(obj))
          .toList();
    } else {
      throw new Exception(response.statusMessage);
    }
  }

  var Json = {
    "app_name": "Home Services",
    "enable_stripe": "1",
    "default_tax": "10",
    "default_currency": "\$",
    "fcm_key":
        "AAAA50743pk:APA91bEuEa3X8VW3T-XURhSLKzDyxJcRayUOp3qLdDVEvzZjF5zuyRjeepZfMruW88RlBtU28Fnnz6IZrMH3muRtjr6KnH8BUQQ2ql_eHgOS0J-ymXiu0NUfAqL3ENSCIoGo-IJ_iygv",
    "enable_paypal": "1",
    "default_theme": "light",
    "main_color": "#00B6BF",
    "main_dark_color": "#00B6BF",
    "second_color": "#08143a",
    "second_dark_color": "#ccccdd",
    "accent_color": "#8C9DA8",
    "accent_dark_color": "#9999aa",
    "scaffold_dark_color": "#2c2c2c",
    "scaffold_color": "#fafafa",
    "google_maps_key": "AIzaSyAxveCxiiKdjldpw8BwjtaKAJ5HUgwySYc",
    "mobile_language": "fr_FR",
    "app_version": "1.0.0",
    "enable_version": "1",
    "currency_right": "0",
    "default_currency_decimal_digits": "2",
    "enable_razorpay": "1",
    "home_section_1": "search",
    "home_section_2": "slider",
    "home_section_3": "top_markets_heading",
    "home_section_4": "top_markets",
    "home_section_5": "trending_week_heading",
    "home_section_6": "trending_week",
    "home_section_7": "categories_heading",
    "home_section_8": "categories",
    "home_section_9": "popular_heading",
    "home_section_10": "popular",
    "home_section_11": "recent_reviews_heading",
    "home_section_12": "recent_reviews"
  };
  Future<Setting> getSettings() async {
    return Setting.fromJson(Json);
  }
}
