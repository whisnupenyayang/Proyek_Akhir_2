import 'package:get/get.dart';

import 'package:markopi/models/JenisTahapBudidaya_Model.dart';
import 'package:markopi/providers/Budidaya_Provider.dart';
import 'package:markopi/models/Budidaya_Model.dart';

class BudidayaController extends GetxController {
  var budidayaList = <Budidaya>[].obs;
  var jenisTahapBudidayaList = <JenisTahapBudidaya>[].obs;
  var jenisTahapBudidayaDetail = JenisTahapBudidaya.empty().obs;

  final budidayaProvider = BudidayaProvider();

  @override
  void onClose() {
    budidayaList.clear();
    jenisTahapBudidayaList.clear();
    // Membersihkan list saat controller dihancurkan
    super.onClose();
  }

  Future<void> fetchBudidaya(String jenis_kopi) async {
    print(jenis_kopi);

    final response = await budidayaProvider.getTipeBudidaya(jenis_kopi);
    if (response.statusCode == 200) {
      final List<dynamic> json = response.body;
      print(response.body);
      budidayaList.value = json.map((item) => Budidaya.fromJson(item)).toList();
    } else {
      print('ajdosjodkaldksldjakdsos');
    }
  }

  Future<void> fetchJenisTahapBudidaya(int id) async {
    final response = await budidayaProvider.getJenisTahapBudidaya(id);
    if (response.statusCode == 200) {
      final List<dynamic> json = response.body;
      print(response.body);
      jenisTahapBudidayaList.value =
          json.map((item) => JenisTahapBudidaya.fromJson(item)).toList();
    } else {
      print('ajdosjodkaldksldjakdsos');
    }
  }

  Future<void> fetchJenisTahapBudidayaDetail(int id) async {
    final response = await budidayaProvider.getJenisTahapBudidayaDetail(id);
    if (response.statusCode == 200) {
      final json = response.body;
      print(json);
      jenisTahapBudidayaDetail.value = JenisTahapBudidaya.fromJson(json);
    } else {
      print('Gagal fetch detail jenis tahap budidaya');
    }
  }
}
