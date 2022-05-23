import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../their_models/slide_model.dart';
import '../providers/mock_provider.dart';

class SliderRepository {
  MockApiClient _apiClient;

  SliderRepository() {
    this._apiClient = MockApiClient(httpClient: Dio());
  }

  Future<List<Slide>> getHomeSlider() async {
    final String response =
        await rootBundle.loadString('assets/banner_headers.json');
    final data = await json.decode(response);
    if (data != null) {
      return data['results'].map<Slide>((obj) => Slide.fromJson(obj)).toList();
    }
  }
}
