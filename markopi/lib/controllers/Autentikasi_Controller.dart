import 'package:get/get.dart';
import 'package:markopi/models/register_request.dart';
import 'package:markopi/providers/Autentikasi_Providers.dart';
import 'package:markopi/routes/route_name.dart';
import 'package:markopi/service/User_Storage.dart';
import 'package:markopi/service/User_Storage_Service.dart';
import 'package:markopi/service/token_storage.dart';

class AutentikasiController extends GetxController {
  var token = RxnString();
  var namaLengkap = ''.obs;
  var sukses = false.obs;

  final autentikasiProvider = AutentikasiProvider();
  final userStorage = UserStorage();
  var idUser = 0.obs;
  var role = ''.obs;

  final userService = UserStorage();

  Future<void> login(String username, String password) async {
    final response = await autentikasiProvider.login(username, password);

    if (response.statusCode == 200) {
      final body = response.body;

      if (body['success'] == true) {
        await TokenStorage.saveToken(body['token']);

        // print(body['user']);
        sukses.value = true;

        final UserModel user = UserModel.fromJson(body['user']);
        await userService.openBox();
        await userService.saveUser(user);

        Get.offAllNamed(RouteName.beranda);
      } else {
        Get.snackbar('Error', body['message'] ?? 'Login gagal');
      }
    } else {
      Get.snackbar('Error', 'Terjadi kesalahan server');
    }
  }

  Future<void> logout() async {
    final String? token = await TokenStorage.getToken();
    final box = await userStorage.openBox();
    if (token == null) {
      Get.snackbar("gagal", "Anda Belum Login");
      return;
    }
    final response = await autentikasiProvider.logout(token);

    if (response.statusCode == 200) {
      await userStorage.deleteUser();
      await TokenStorage.clearToken();
      sukses.value = true;
    }
  }

  Future<void> register(RegisterRequest request) async {
    final response = await autentikasiProvider.register(request);
    if (response.body['success'] == true) {
      Get.snackbar(
          'Berhasil Daftar', response.body['message'] ?? 'Daftar berhasil');
      Get.toNamed(RouteName.login);
    } else {
      Get.snackbar('Gagal Daftar', response.body['message'] ?? 'Daftar gagal');
    }
  }
}
