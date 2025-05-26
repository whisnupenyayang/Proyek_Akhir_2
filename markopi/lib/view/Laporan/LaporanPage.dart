import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/models/laporan_kebun.dart';
import 'package:markopi/service/laporan_service.dart';
import 'package:intl/intl.dart';
import 'package:markopi/view/Laporan/income_expance.dart';
import 'package:markopi/view/Laporan/tambah_kebun.dart';
import 'package:markopi/view/Laporan/detail_laporan_kebun.dart';

class LaporanPage extends StatefulWidget {
  const LaporanPage({Key? key}) : super(key: key);

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  late Future<LaporanResponse> _laporanFuture;

  @override
  void initState() {
    super.initState();
    _laporanFuture = LaporanService.getAllLaporans();
  }

  String formatCurrency(num value) {
    final formatter =
        NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Laporan Kebun'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _laporanFuture = LaporanService.getAllLaporans();
                });
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      body: FutureBuilder<LaporanResponse>(
        future: _laporanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.laporan.isEmpty) {
            return const Center(child: Text('Tidak ada data laporan.'));
          }

          final laporanData = snapshot.data!;
          final laporans = laporanData.laporan;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Total Pendapatan',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatCurrency(laporans.fold(0,
                              (total, item) => total + item.totalPendapatan)),
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...laporans.map((laporan) {
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  laporan.namaKebun ?? '',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                GestureDetector(
                                  onTap: () => Get.to(
                                    () => LaporanDetailPage(
                                      idKebun: laporan.id,
                                      title: laporan.namaKebun,
                                    ),
                                  ),
                                  child: Row(
                                    spacing: 2,
                                    children: [
                                      Text(
                                        'Detail',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue.shade700,
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right_rounded,
                                        color: Colors.blue.shade700,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              laporan.lokasi,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Hasil Produktivitas'),
                                Text(
                                  formatCurrency(laporan.hasilProduktifitas),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total pendapatan'),
                                Text(formatCurrency(laporan.totalPendapatan)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total pengeluaran'),
                                Text(formatCurrency(laporan.totalPengeluaran)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () => Get.to(() => TambahKebunPage()),
        child: Text("Tambah data kebun", style: TextStyle(color: Colors.white),),
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue.shade600)),
      ),
    );
  }
}
