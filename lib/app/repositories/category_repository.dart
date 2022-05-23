import 'package:dio/dio.dart';
import 'package:home_services/app/models/Category.dart';

import '../providers/mock_provider.dart';

class CategoryRepository {
  MockApiClient _apiClient;

  CategoryRepository() {
    this._apiClient = MockApiClient(httpClient: Dio());
  }

  Future<List<Category>> getAll() {
    // List<Category> categories
    return _apiClient.getAllCategories();
  }

  Future<List<Category>> getAllWithSubCategories() {
    return _apiClient.getAllWithSubCategories();
  }

  Future<List<Category>> getFeatured() {
    return _apiClient.getFeaturedCategories();
  }
}
