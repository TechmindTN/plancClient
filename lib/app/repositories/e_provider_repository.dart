import 'package:dio/dio.dart';
import 'package:home_services/app/their_models/e_provider_model.dart';
import 'package:home_services/app/their_models/e_service_model.dart';
import 'package:home_services/app/their_models/review_model.dart';


import '../providers/mock_provider.dart';

class EProviderRepository {
  MockApiClient _apiClient;

  EProviderRepository() {
    this._apiClient = MockApiClient(httpClient: Dio());
  }

  Future<EProvider> get(String eProviderId) {
    return _apiClient.getEProvider(eProviderId);
  }

  Future<List<Review>> getReviews(String eProviderId) {
    return _apiClient.getEProviderReviews(eProviderId);
  }

  Future<List<EService>> getEServicesWithPagination(String eProviderId, {int page}) {
    return _apiClient.getEProviderEServicesWithPagination(eProviderId, page);
  }

  Future<List<EService>> getPopularEServices(String eProviderId) {
    return _apiClient.getEProviderPopularEServices(eProviderId);
  }

  Future<List<EService>> getMostRatedEServices(String eProviderId) {
    return _apiClient.getEProviderMostRatedEServices(eProviderId);
  }

  Future<List<EService>> getAvailableEServices(String eProviderId) {
    return _apiClient.getEProviderAvailableEServices(eProviderId);
  }

  Future<List<EService>> getFeaturedEServices(String eProviderId) {
    return _apiClient.getEProviderFeaturedEServices(eProviderId);
  }
}
