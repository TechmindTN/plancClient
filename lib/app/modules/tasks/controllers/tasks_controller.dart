import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:home_services/app/their_models/e_service_model.dart';
import 'package:home_services/app/their_models/task_model.dart';

import '../../../../common/ui.dart';

import '../../../Network/ClientNetwork.dart';
import '../../../Network/InterventionNetwork.dart';
import '../../../models/Category.dart';
import '../../../models/Client.dart';
import '../../../models/Intervention.dart';
import '../../../models/Provider.dart';
import '../../../repositories/task_repository.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../home/controllers/home_controller.dart';

class TasksController extends GetxController {
  TaskRepository _taskRepository;
  InterventionNetwork interventionNetwork = InterventionNetwork();
  RxList<Intervention> bookings = <Intervention>[].obs;
  var completedTasks = <Task>[].obs;
  var archivedTasks = <Task>[].obs;
  var client = Client().obs;
  ClientNetwork _clientNetwork = ClientNetwork();
  Rx<Intervention> selectedTask = Intervention().obs;
  // Rx<Client> client = Client().obs;
  // ClientNetwork _clientNetwork = ClientNetwork();
  // final selectedOngoingTask = Task().obs;
  // final selectedCompletedTask = Task().obs;
  // final selectedArchivedTask = Task().obs;
  RxList<Intervention> OngoingTasks = <Intervention>[].obs;
  RxList<Intervention> CompletedTasks = <Intervention>[].obs;

  @override
  void onInit() async {
    await refreshTasks();
    super.onInit();
  }

  Future refreshTasks({bool showMessage = false}) async {
    await getPendingTasks();
    await getOngoingTasks();
    await getCompletedTasks();

    if (showMessage) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Task page refreshed successfully".tr));
    }
  }

  Future getPendingTasks({bool showMessage = false}) async {
    // QuerySnapshot snaps = await _interventionNetwork.InterventionsRef.get();
    // Intervention i;
    // snaps.docs.forEach((element) async {
    //   print(element.data()['provider']);
    //   ServiceProvider s = await getProviderbyRef(element.data()['provider']);
    //   Category c = await getCategorybyRef(element.data()['category']);
    //   Client cl = await getClientbyRef(element.data()['client']);
    //   i = Intervention.fromFire(element.data());
    //   i.client = cl;
    //   i.category = c;
    //   i.provider = s;
    //   i.printIntervention();
    // _interventionNetwork
    //   bookings.value.add(i);
    // });
    bookings.clear();
    for (var i = 0; i < Get.find<HomeController>().interventions.length; i++) {
      if (Get.find<HomeController>().interventions.value[i].states ==
          "pending") {
        bookings.value.add(Get.find<HomeController>().interventions.value[i]);
      }
    }
    if (showMessage) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Task page refreshed successfully".tr));
    }
    //selectedOngoingTask.value = ongoingTasks.isNotEmpty ? ongoingTasks.first : new Task();
  }

  // getProviderbyRef(DocumentReference dr) async {
  //   ServiceProvider sp;
  //   print('provider id ' + dr.id);
  //   DocumentSnapshot q = await _interventionNetwork.providers.doc(dr.id).get();
  //   sp = ServiceProvider.fromFire(q.data());
  //   return sp;
  // }

  // getCategorybyRef(DocumentReference dr) async {
  //   print('cat id ' + dr.id);
  //   Category c;
  //   DocumentSnapshot q = await _interventionNetwork.categories.doc(dr.id).get();
  //   c = Category.fromFire(q.data());
  //   return c;
  // }

  // getClientbyRef(DocumentReference dr) async {
  //   Client c;
  //   print('client id ' + dr.id);

  //   DocumentSnapshot q = await _interventionNetwork.clients.doc(dr.id).get();
  //   c = Client.fromFire(q.data());
  //   return c;
  // }

  getOngoingTasks({bool showMessage = false}) {
    OngoingTasks.clear();
    for (var i = 0; i < Get.find<HomeController>().interventions.length; i++) {
      if (Get.find<HomeController>().interventions.value[i].states ==
          "ongoing") {
        OngoingTasks.value
            .add(Get.find<HomeController>().interventions.value[i]);
      }
    }
    if (showMessage) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Task page refreshed successfully".tr));
    }
    //selectedCompletedTask.value = completedTasks.isNotEmpty ? completedTasks.first : new Task();
  }

  Future<void> getCompletedTasks({bool showMessage = false}) async {
    CompletedTasks.clear();

    for (var i = 0; i < Get.find<HomeController>().interventions.length; i++) {
      if (Get.find<HomeController>().interventions.value[i].states ==
              "completed" ||
          Get.find<HomeController>().interventions.value[i].states ==
              "refused") {
        CompletedTasks.add(Get.find<HomeController>().interventions.value[i]);
      }
    }

    if (showMessage) {
      Get.showSnackbar(
          Ui.SuccessSnackBar(message: "Task page refreshed successfully".tr));
    }
    //selectedArchivedTask.value = archivedTasks.isNotEmpty ? archivedTasks.first : new Task();
  }

  updateFireintervention(String id, int number, ServiceProvider prov) async {
    await interventionNetwork.updateIntervention(id, number, prov);
  }
}
