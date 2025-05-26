import 'package:get/get.dart';
import 'package:markopi/models/Artikel_Model.dart';

class SearchArtikelController extends GetxController {
  var allArtikel = <Artikel>[];
  var filteredArtikel = <Artikel>[].obs;

  void setArtikel(List<Artikel> artikels) {
    allArtikel = artikels;
    filteredArtikel.value = allArtikel;
  }

  void filterArtikel(String query) {
    if (query.isEmpty) {
      filteredArtikel.value = allArtikel;
    } else {
      filteredArtikel.value = allArtikel.where((artikel) {
        final judulLower = artikel.judulArtikel.toLowerCase();
        final isiLower = artikel.isiArtikel.toLowerCase();
        final searchLower = query.toLowerCase();
        return judulLower.contains(searchLower) || isiLower.contains(searchLower);
      }).toList();
    }
  }
}
