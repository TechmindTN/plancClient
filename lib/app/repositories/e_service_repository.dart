import 'package:dio/dio.dart';

import '../their_models/e_service_model.dart';
import '../their_models/review_model.dart';
import '../providers/mock_provider.dart';

class EServiceRepository {
  MockApiClient _apiClient;

  EServiceRepository() {
    this._apiClient = MockApiClient(httpClient: Dio());
  }
  Future<List<EService>> getAll() {
    return _apiClient.getAllEServices();
  }

  Future<List<EService>> getAllWithPagination({int page}) {
    return _apiClient.getAllEServicesWithPagination(page);
  }

  Future<List<EService>> getFavorites() {
    return _apiClient.getFavoritesEServices();
  }

  Future<List<EService>> getRecommended() {
    return _apiClient.getRecommendedEServices();
  }

  Future<List<EService>> getFeatured() {
    return _apiClient.getFeaturedEServices();
  }

  Future<List<EService>> getPopular() {
    return _apiClient.getPopularEServices();
  }

  Future<List<EService>> getMostRated() {
    return _apiClient.getMostRatedEServices();
  }

  Future<List<EService>> getAvailable() {
    return _apiClient.getAvailableEServices();
  }

  Future<EService> get(String id) {
    return _apiClient.getEService(id);
  }

  Future<List<Review>> getReviews(String eServiceId) {
    return _apiClient.getEServiceReviews(eServiceId);
  }
}
