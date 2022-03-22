import 'package:dio/dio.dart';
import 'package:home_services/app/their_models/faq_category_model.dart';

import '../providers/mock_provider.dart';

class FaqRepository {
  MockApiClient _apiClient;

  FaqRepository() {
    this._apiClient = MockApiClient(httpClient: Dio());
  }

  Future<List<FaqCategory>> getCategoriesWithFaqs() {
    return _apiClient.getCategoriesWithFaqs();
  }
}
