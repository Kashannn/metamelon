import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class NetworkController extends GetxController {
  final Connectivity connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    connectivity.onConnectivityChanged.listen((result) {
      updateConnectivityStatus(result);
    });
  }

  void updateConnectivityStatus(ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      Get.rawSnackbar(
        title: 'No Internet Connection',
        message: 'Please check your internet connection',
        duration: Duration(seconds: 3),
      );
    }
    else if (result == ConnectivityResult.mobile) {
      Get.rawSnackbar(
        title: 'Mobile Data',
        message: 'You are using mobile data',
        duration: Duration(seconds: 3),
      );
    }
    else if (result == ConnectivityResult.wifi) {
      Get.rawSnackbar(
        title: 'Wi-Fi',
        message: 'You are using Wi-Fi',
        duration: Duration(seconds: 3),
      );
    }
  }
}
