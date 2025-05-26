import 'package:get/get.dart';
import 'package:markopi/controllers/forgot_password.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ForgotPasswordController());
  }
}
