import 'package:get/get.dart';
import 'package:markopi/controllers/Budidaya_Controller.dart';

class BudidayaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BudidayaController());
  }
}
