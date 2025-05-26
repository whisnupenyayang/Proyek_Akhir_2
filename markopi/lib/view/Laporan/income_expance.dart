import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:markopi/controllers/income_controller.dart';
import 'package:markopi/view/Laporan/add_pendapatan.dart';

class IncomeExpensePage extends StatefulWidget {
  final String kebunId;
  final String namaKebun;
  final String bulan;

  const IncomeExpensePage({
    super.key,
    required this.kebunId,
    required this.namaKebun,
    required this.bulan,
  });

  @override
  State<IncomeExpensePage> createState() => _IncomeExpensePageState();
}

class _IncomeExpensePageState extends State<IncomeExpensePage> {
  final controller = Get.put(IncomeController());
  RxString selectedTab = 'pendapatan'.obs;

  @override
  void initState() {
    super.initState();
    controller.fetchData(widget.kebunId, widget.bulan);
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
        title: Text(widget.namaKebun, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.blue.shade500,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final isPendapatan = selectedTab.value == 'pendapatan';
        final dataList = isPendapatan
            ? controller.pendapatanList
            : controller.pengeluaranList;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Toggle Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildToggleButton("Pendapatan", 'pendapatan'),
                  const SizedBox(width: 8),
                  _buildToggleButton("Pengeluaran", 'pengeluaran'),
                ],
              ),
              const SizedBox(height: 16),
              // List
              Expanded(
                child: dataList.isEmpty
                    ? Center(
                        child: Text(
                            "Tidak ada data ${isPendapatan ? 'pendapatan' : 'pengeluaran'}"))
                    : ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          final item = dataList[index];
                          return _buildCard(item, isPendapatan);
                        },
                      ),
              )
            ],
          ),
        );
      }),
      floatingActionButton: ElevatedButton(
          style:
              ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600),
          onPressed: () {
            Get.to(IncomeExpenseForm(kebun_id: widget.kebunId));
          },
          child: const Text(
            "Tambah data",
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  Widget _buildToggleButton(String label, String value) {
    return Obx(() {
      final isSelected = selectedTab.value == value;
      return ElevatedButton(
        onPressed: () => selectedTab.value = value,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
          foregroundColor: isSelected ? Colors.white : Colors.black,
        ),
        child: Text(label),
      );
    });
  }

  Widget _buildCard(Map item, bool isPendapatan) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isPendapatan
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hasil Produktivitas",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildDetail("Jenis Kopi", item["jenis_kopi"]),
                  _buildDetail("Tempat Penjualan", item["tempat_penjualan"]),
                  _buildDetail("Tanggal Penjualan", item["tanggal_penjualan"]),
                  _buildDetail("Banyak Kopi", "${item["berat_kg"]} Kg"),
                  _buildDetail("Harga Kopi/Kg",
                      "${formatCurrency(item["harga_per_kg"])}"),
                  _buildDetail("Total Pendapatan",
                      "${formatCurrency(item["total_pendapatan"])}"),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Detail Pengeluaran",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildDetail("Jenis Pengeluaran", item["deskripsi_biaya"]),
                  _buildDetail("Tanggal", item["tanggal"]),
                  _buildDetail("Jumlah", "${formatCurrency(item["nominal"])}"),
                ],
              ),
      ),
    );
  }

  Widget _buildDetail(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value ?? "-"),
        ],
      ),
    );
  }
}
