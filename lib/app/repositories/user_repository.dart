import 'package:dio/dio.dart';
import 'package:home_services/app/models/User.dart';

import '../their_models/address_model.dart';
import '../providers/mock_provider.dart';

class UserRepository {
  MockApiClient _apiClient;

  UserRepository() {
    this._apiClient = MockApiClient(httpClient: Dio());
  }

  Future<List<User>> getAll() {
    return _apiClient.getAllUsers();
  }

  Future<User> login() {
    return _apiClient.getLogin();
  }

  Future<List<Address>> getAddresses() {
    return _apiClient.getAddresses();
  }

  // getId(id) {
  //   return apiClient.getId(id);
  // }
  //
  // delete(id) {
  //   return apiClient.delete(id);
  // }
  //
  // edit(obj) {
  //   return apiClient.edit(obj);
  // }
  //
  // add(obj) {
  //   return apiClient.add(obj);
  // }
}
