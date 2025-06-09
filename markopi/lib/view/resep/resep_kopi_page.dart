import 'package:flutter/material.dart';
import 'package:markopi/service/resep_service.dart';
import 'package:markopi/models/resep.dart';
import 'dart:io'; // Tambahan untuk menangani error koneksi

class ResepKopiPage extends StatefulWidget {
  const ResepKopiPage({super.key});

  @override
  State<ResepKopiPage> createState() => _ResepKopiPageState();
}

class _ResepKopiPageState extends State<ResepKopiPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Resep> _allReseps = [];
  List<Resep> _filteredReseps = [];

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
      final reseps = await ResepService.getAllReseps();
      if (reseps != null && mounted) {
        setState(() {
          _allReseps = reseps;
          _filteredReseps = reseps;  // Set initial filtered list
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
    List<Resep> tempList = List.from(_allReseps);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      tempList = tempList.where((resep) {
        return resep.namaResep.toLowerCase().contains(_searchQuery) ||
               resep.deskripsiResep.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    setState(() {
      _filteredReseps = tempList;
    });
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
          hintText: 'Cari resep kopi...',
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
              Icons.local_cafe_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Resep "${_searchController.text}" tidak ditemukan'
                  : 'Tidak ada data resep kopi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Kami akan memperbarui daftar resep segera',
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
        title: const Text('Resep Kopi'),
        centerTitle: true, // Menempatkan teks di tengah
        backgroundColor: const Color(0xFF2196F3), // Mengubah warna app bar menjadi biru
        foregroundColor: Colors.white, // Warna teks putih
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 8),
          Expanded(
            child: _allReseps.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _filteredReseps.isEmpty
                    ? _buildNoDataMessage()
                    : RefreshIndicator(
                        onRefresh: () => _loadInitialData(),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12), // Mengurangi padding pada list
                          itemCount: _filteredReseps.length,
                          itemBuilder: (context, index) {
                            final resep = _filteredReseps[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  // Navigasi ke halaman detail resep
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      resep.gambarResep.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: Image.network(
                                                resep.gambarResep,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) {
                                                  return const Icon(Icons.broken_image,
                                                      size: 40, color: Colors.grey);
                                                },
                                              ),
                                            )
                                          : const Icon(Icons.image_not_supported,
                                              size: 100, color: Colors.grey),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                style: const TextStyle(
                                                    fontSize: 17, color: Colors.black),
                                                children: [
                                                  const TextSpan(
                                                    text: 'Nama Resep: ',
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  TextSpan(text: resep.namaResep),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            RichText(
                                              text: TextSpan(
                                                style: const TextStyle(
                                                    fontSize: 15, color: Colors.black87),
                                                children: [
                                                  const TextSpan(
                                                    text: 'Deskripsi Resep: ',
                                                    style: TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text: resep.deskripsiResep.length > 50
                                                        ? resep.deskripsiResep.substring(0, 50) + '...'
                                                        : resep.deskripsiResep,
                                                  ),
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
