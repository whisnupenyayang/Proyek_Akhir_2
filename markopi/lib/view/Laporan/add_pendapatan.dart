import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';  // Import untuk FilteringTextInputFormatter
import 'package:markopi/controllers/income_controller.dart';
import 'package:markopi/controllers/Pengepul_Controller.dart'; // Import pengepul controller

class IncomeExpenseForm extends StatefulWidget {
  final String kebun_id;

  const IncomeExpenseForm({
    super.key,
    required this.kebun_id,
  });

  @override
  _IncomeExpenseFormState createState() => _IncomeExpenseFormState();
}

class _IncomeExpenseFormState extends State<IncomeExpenseForm> {
  bool isPendapatan = true;

  // Pendapatan Controllers
  final TextEditingController jenisKopiController = TextEditingController();
  final TextEditingController tempatJualController = TextEditingController();
  final TextEditingController tanggalPanenController = TextEditingController();
  final TextEditingController banyakKopiController = TextEditingController();
  final TextEditingController hargaKopiController = TextEditingController();

  // Pengeluaran Controllers
  final TextEditingController jenisPengeluaranController = TextEditingController();
  final TextEditingController jumlahPengeluaranController = TextEditingController();
  final TextEditingController tanggalPengeluaranController = TextEditingController();

  // Dropdown Kopi
  String? selectedJenisKopi;
  bool isJenisKopiLainnya = false;

  // Dropdown Tempat Jual
  bool isTempatJualLainnya = false;

  // Controller pengepul
  final PengepulController pengepulC = Get.put(PengepulController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah ${isPendapatan ? 'Pendapatan' : 'Pengeluaran'}',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
                  if (tanggalPanenController.text.isEmpty) {
                    Get.snackbar("Peringatan", "Tanggal Panen wajib diisi");
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
                    tanggal: tanggalPanenController.text,
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
                  Get.snackbar("Success", "Data berhasil Ditambahkan");
                } else {
                  Get.snackbar("Error", "Periksa data kembali");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Simpan ${isPendapatan ? 'Data' : 'Pengeluaran'}',
                style: TextStyle(color: Colors.white), // Set color to white for button text
              ),
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
      _buildDropdownJenisKopi(),
      if (isJenisKopiLainnya) _buildTextField(jenisKopiController, 'Jenis Kopi Lainnya', 'Isi jenis kopi lainnya'),
      _buildDropdownTempatJual(),
      if (isTempatJualLainnya) _buildTextField(tempatJualController, 'Tempat Penjualan Lainnya', 'Isi nama toko lainnya'),
      _buildDateField(),
      _buildNumberInputField(banyakKopiController, 'Banyak Kopi', 'Isi banyak kopi dalam kg'),
      _buildNumberInputField(hargaKopiController, 'Harga Kopi Per Kg', 'Isi harga kopi'),
    ];
  }

  List<Widget> _buildPengeluaranForm() {
    return [
      _buildTextField(jenisPengeluaranController, 'Deskripsi Pengeluaran', 'Isi deskripsi pengeluaran'),
      _buildNumberInputField(jumlahPengeluaranController, 'Jumlah Pengeluaran', 'Isi jumlah pengeluaran'),
    ];
  }

  Widget _buildDropdownJenisKopi() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: selectedJenisKopi,
        decoration: InputDecoration(
          labelText: 'Jenis Kopi',
          border: OutlineInputBorder(),
        ),
        items: ['Arabika', 'Robusta', 'Lainnya'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedJenisKopi = value;
            isJenisKopiLainnya = value == 'Lainnya';
            if (!isJenisKopiLainnya && value != null) {
              jenisKopiController.text = value;
            } else {
              jenisKopiController.clear();
            }
          });
        },
      ),
    );
  }

  Widget _buildDropdownTempatJual() {
    return Obx(() {
      final pengepulList = pengepulC.pengepul;

      if (pengepulList.isEmpty) {
        return const Center(
          child: Text("Tidak ada data pengepul", style: TextStyle(fontSize: 16)),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: DropdownButtonFormField<String>(
          value: tempatJualController.text.isNotEmpty ? tempatJualController.text : null,
          decoration: InputDecoration(
            labelText: 'Tempat Penjualan',
            border: OutlineInputBorder(),
          ),
          items: pengepulList.map((item) {
            return DropdownMenuItem<String>(
              value: item.nama_toko,
              child: Text(item.nama_toko),
            );
          }).toList()
          ..add(
            DropdownMenuItem<String>(
              value: 'Lainnya',
              child: Text('Lainnya'),
            ),
          ),
          onChanged: (value) {
            setState(() {
              if (value == 'Lainnya') {
                isTempatJualLainnya = true;
                tempatJualController.clear();
              } else {
                isTempatJualLainnya = false;
                tempatJualController.text = value ?? '';
              }
            });
          },
        ),
      );
    });
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

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: tanggalPanenController,
        decoration: InputDecoration(
          labelText: 'Tanggal Panen',
          hintText: 'yyyy-MM-dd',
          border: OutlineInputBorder(),
        ),
        readOnly: true, // To make it read-only so user can't type directly
        onTap: () async {
          DateTime? selectedDate = await _selectDate(context);
          if (selectedDate != null) {
            String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
            setState(() {
              tanggalPanenController.text = formattedDate;
            });
          }
        },
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2101);

    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  // This method is used for fields that should only accept numbers
  Widget _buildNumberInputField(TextEditingController controller, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number, // Only show number keyboard
        inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Allow only digits
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
