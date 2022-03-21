import 'package:dio/dio.dart';

import '../their_models/task_model.dart';
import '../providers/mock_provider.dart';

class TaskRepository {
  MockApiClient _apiClient;

  TaskRepository() {
    this._apiClient = MockApiClient(httpClient: Dio());
  }

  Future<List<Task>> getOngoingTasks() {
    return _apiClient.getTasks();
  }

  Future<List<Task>> getCompletedTasks() {
    return _apiClient.getTasks();
  }

  Future<List<Task>> getArchivedTasks() {
    return _apiClient.getTasks();
  }
}
