import 'package:dio/dio.dart';

import '../their_models/notification_model.dart';
import '../providers/mock_provider.dart';

class NotificationRepository {
  MockApiClient _apiClient;

  NotificationRepository() {
    this._apiClient = MockApiClient(httpClient: Dio());
  }

  Future<List<Notification>> getAll() {
    return _apiClient.getNotifications();
  }
}
