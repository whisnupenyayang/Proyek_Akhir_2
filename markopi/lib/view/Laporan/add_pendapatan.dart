import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/income_controller.dart';
class IncomeExpenseForm extends StatefulWidget {
  @override
  final String kebun_id;

  const IncomeExpenseForm({
    super.key,
    required this.kebun_id
  });

  _IncomeExpenseFormState createState() => _IncomeExpenseFormState(

  );
}

class _IncomeExpenseFormState extends State<IncomeExpenseForm> {
  bool isPendapatan = true;

  // Pendapatan Controllers
  final TextEditingController jenisKopiController = TextEditingController();
  final TextEditingController tempatJualController = TextEditingController();
  final TextEditingController tanggalPanen = TextEditingController();
  final TextEditingController banyakKopiController = TextEditingController();
  final TextEditingController hargaKopiController = TextEditingController();

  // Pengeluaran Controllers
  final TextEditingController jenisPengeluaranController = TextEditingController();
  final TextEditingController jumlahPengeluaranController = TextEditingController();
  final TextEditingController tanggalPengeluaranController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah ${isPendapatan ? 'Pendapatan' : 'Pengeluaran'}', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () {
          Get.back();
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildToggleButtons(),
            const SizedBox(height: 24),
            Text("Lengkapi Data", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            ...isPendapatan ? _buildPendapatanForm() : _buildPengeluaranForm(),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                if (isPendapatan) {
                  if (jenisKopiController.text.isEmpty) {
                  Get.snackbar("Peringatan", "Jenis Kopi wajib diisi");
                  return;
                  }
                  if (tempatJualController.text.isEmpty) {
                  Get.snackbar("Peringatan", "Tempat Penjualan wajib diisi");
                  return;
                  }
                  if (tanggalPanen.text.isEmpty) {
                  Get.snackbar("Peringatan", "Tanggal Penjualan wajib diisi");
                  return;
                  }
                  if (banyakKopiController.text.isEmpty) {
                  Get.snackbar("Peringatan", "Banyak Kopi wajib diisi");
                  return;
                  }
                  if (hargaKopiController.text.isEmpty) {
                  Get.snackbar("Peringatan", "Harga Kopi Per Kg wajib diisi");
                  return;
                  }
                } else {
                  if (jenisPengeluaranController.text.isEmpty) {
                  Get.snackbar("Peringatan", "Jenis Pengeluaran wajib diisi");
                  return;
                  }
                  if (jumlahPengeluaranController.text.isEmpty) {
                  Get.snackbar("Peringatan", "Jumlah Pengeluaran wajib diisi");
                  return;
                  }
                }

                bool response = false;
                if (isPendapatan) {
                  response = await IncomeController.kirimPendapatan(
                  kebun_id: widget.kebun_id,
                  jenisKopi: jenisKopiController.text,
                  tempatJual: tempatJualController.text,
                  tanggal: tanggalPanen.text,
                  banyakKopi: banyakKopiController.text,
                  hargaKopi: hargaKopiController.text,
                  );
                } else {
                  response = await IncomeController.kirimPengeluaran(
                  kebun_id: widget.kebun_id,
                  jenisPengeluaran: jenisPengeluaranController.text,
                  jumlah: jumlahPengeluaranController.text,
                  );
                }

                if (response == true) {
                  Get.snackbar("Success", "Data berhasil Di Tambahkan");
                } else {
                  Get.snackbar("Error", "Periksa data kembali");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Simpan ${isPendapatan ? 'Data' : 'Pengeluaran'}'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSwitchButton("Pendapatan", true),
        SizedBox(width: 12),
        _buildSwitchButton("Pengeluaran", false),
      ],
    );
  }

  Widget _buildSwitchButton(String label, bool value) {
    bool selected = isPendapatan == value;
    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isPendapatan = value;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selected ? Colors.blue : Colors.grey[300],
          foregroundColor: selected ? Colors.white : Colors.black,
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(label),
      ),
    );
  }

  List<Widget> _buildPendapatanForm() {
    return [
      _buildTextField(jenisKopiController, 'Jenis Kopi', 'Isi jenis kopi'),
      _buildTextField(tempatJualController, 'Tempat Penjualan', 'Isi tempat jual'),
      _buildTextField(tanggalPanen, 'Tanggal Panen', 'Isi tanggal dengan format tahun-bulan-tanggal'),
      _buildTextField(banyakKopiController, 'Banyak Kopi', 'Isi banyak kopi dalam kg'),
      _buildTextField(hargaKopiController, 'Harga Kopi Per Kg', 'Isi harga kopi'),
    ];
  }

  List<Widget> _buildPengeluaranForm() {
    return [
      _buildTextField(jenisPengeluaranController, 'deskripsi Pengeluaran', 'Isi Deskripsi pengeluaran'),
      _buildTextField(jumlahPengeluaranController, 'Jumlah Pengeluaran', 'Isi jumlah Pengeluaran'),
    ];
  }

  Widget _buildTextField(TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
