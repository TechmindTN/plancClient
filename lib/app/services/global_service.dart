import 'package:get/get.dart';
import 'package:home_services/app/their_models/global_model.dart';

import '../../common/helper.dart';

class GlobalService extends GetxService {
  final global = Global().obs;

  Future<GlobalService> init() async {
    var response = await Helper.getJsonFile('config/global.json');
    global.value = Global.fromJson(response);
    return this;
  }

  String get baseUrl => global.value.mockBaseUrl;
}
