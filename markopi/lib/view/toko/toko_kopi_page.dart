import 'package:flutter/material.dart';
import 'package:markopi/service/toko_service.dart';
import 'package:markopi/models/toko.dart';
import 'package:url_launcher/url_launcher.dart';

class TokoKopiPage extends StatefulWidget {
  const TokoKopiPage({super.key});

  @override
  State<TokoKopiPage> createState() => _TokoKopiPageState();
}

class _TokoKopiPageState extends State<TokoKopiPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Toko> _allTokos = [];
  List<Toko> _filteredTokos = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final tokos = await TokoService.getAllTokos();
      if (tokos != null && mounted) {
        setState(() {
          _allTokos = tokos;
          _filteredTokos = tokos;  // Set initial filtered list
        });
      }
    } catch (e) {
      print('Error loading initial data: $e');
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (_searchQuery != query) {
      setState(() {
        _searchQuery = query;
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    List<Toko> tempList = List.from(_allTokos);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      tempList = tempList.where((toko) {
        return toko.namaToko.toLowerCase().contains(_searchQuery) ||
               toko.lokasi.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    setState(() {
      _filteredTokos = tempList;
    });
  }

  Future<void> _launchMapsUrl(String locationUrl) async {
    final url = 'https://www.google.com/maps?q=${Uri.encodeComponent(locationUrl)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Fungsi baru untuk membuka Google Maps dengan koordinat
  Future<void> _launchMapsWithCoordinates(Toko toko) async {
    final url = 'https://www.google.com/maps?q=${toko.latitude},${toko.longitude}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Fallback ke lokasi string jika koordinat gagal
      _launchMapsUrl(toko.lokasi);
    }
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(12),  // Mengurangi margin untuk kompak
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari toko kopi...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildNoDataMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_mall_directory_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty 
                  ? 'Toko "${_searchController.text}" belum tersedia di aplikasi kami'
                  : 'Tidak ada data toko',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Kami akan memperbarui list toko segera',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Toko Kopi'),
        centerTitle: true,
        backgroundColor: const Color(0xFF2196F3), // Mengubah warna app bar menjadi biru
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 8),
          Expanded(
            child: _allTokos.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _filteredTokos.isEmpty
                    ? _buildNoDataMessage()
                    : RefreshIndicator(
                        onRefresh: () => _loadInitialData(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),  // Mengurangi padding pada list
                          itemCount: _filteredTokos.length,
                          itemBuilder: (context, index) {
                            final toko = _filteredTokos[index];

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8),  // Mengurangi margin
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  // Gunakan koordinat jika tersedia, fallback ke lokasi string
                                  if (toko.latitude != 0.0 && toko.longitude != 0.0) {
                                    _launchMapsWithCoordinates(toko);
                                  } else {
                                    _launchMapsUrl(toko.lokasi);
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12),  // Mengurangi padding di dalam card
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      toko.fotoToko.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.network(
                                                toko.fotoToko,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return Container(
                                                    width: 120,
                                                    height: 120,
                                                    color: Colors.grey[300],
                                                    child: const Center(
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          Icon(Icons.wifi_off, size: 40, color: Colors.grey),
                                                          SizedBox(height: 5),
                                                          Text(
                                                            'Gagal memuat\ngambar',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(fontSize: 12, color: Colors.grey),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : const Icon(
                                              Icons.store,
                                              size: 100,
                                              color: Colors.grey,
                                            ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black,
                                                ),
                                                children: [
                                                  const TextSpan(
                                                    text: 'Nama Toko: ',
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  TextSpan(text: toko.namaToko),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            RichText(
                                              text: TextSpan(
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black87,
                                                ),
                                                children: [
                                                  const TextSpan(
                                                    text: 'Jam Operasional: ',
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  TextSpan(text: toko.jamOperasional),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
