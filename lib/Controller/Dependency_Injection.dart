
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'Network_Controller.dart';

class DependencyInjection {
  static void init() {
     Get.put<NetworkController>(NetworkController(),permanent: true);
  }
}

