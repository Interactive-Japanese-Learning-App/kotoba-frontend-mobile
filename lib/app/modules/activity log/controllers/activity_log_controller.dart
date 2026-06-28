import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/services/api_service.dart';

class ActivityLogController extends GetxController {
  final activities = <dynamic>[].obs;
  final isLoading = false.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadActivities();
  }

  @override
  void onReady() {
    super.onReady();
    loadActivities();
  }

  Future<void> loadActivities() async {
    try {
      isLoading.value = true;

      final userId = box.read('userId');

      print("USER ID = $userId");

      final result = await ApiService.getActivities(userId: userId.toString());

      print("===== ACTIVITY RESULT =====");
      print(result);

      print("===== ACTIVITY DATA =====");
      print(result["data"]);

      if (result["success"] == true) {
        activities.assignAll(result["data"]);
      }
    } catch (e) {
      print("ACTIVITY ERROR = $e");
    } finally {
      isLoading.value = false;
    }
  }
}
