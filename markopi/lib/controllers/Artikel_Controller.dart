import 'package:get/get.dart';
import 'package:markopi/providers/Artikel_Providers.dart';
import '../models/Artikel_Model.dart';

class ArtikelController extends GetxController {
  var artikel = <Artikel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final artikelProvider = ArtikelProvider();

  @override
  void onInit() {
    fetchArtikel();
    super.onInit();
  }

  Future<void> fetchArtikel() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = await artikelProvider.fetchArtikels(); // Panggil method baru di provider
      artikel.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
