import 'package:flutter/material.dart';

class FormPengajuanPage extends StatefulWidget {
  @override
  _FormPengajuanPageState createState() => _FormPengajuanPageState();
}

class _FormPengajuanPageState extends State<FormPengajuanPage> {
  final _jenisKopiController = TextEditingController();
  final _jenisBijiController = TextEditingController();
  final _banyakKopiController = TextEditingController();

  @override
  void initState (){
    super.initState();
    
  }


  @override
  void dispose() {
    _jenisKopiController.dispose();
    _jenisBijiController.dispose();
    _banyakKopiController.dispose();
    super.dispose();
  }

  void _submitForm() {
    final jenisKopi = _jenisKopiController.text;
    final jenisBiji = _jenisBijiController.text;
    final banyakKopi = _banyakKopiController.text;

    // Tambahkan logika kirim ke backend atau validasi di sini
    print('Jenis Kopi: $jenisKopi');
    print('Jenis Biji: $jenisBiji');
    print('Banyak Kopi: $banyakKopi');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Form Jual Kopi"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lengkapi Data",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 2, color: Colors.black26)],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _jenisKopiController,
              decoration: InputDecoration(
                labelText: "Jenis Kopi",
                hintText: "Isi jenis kopi",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _jenisBijiController,
              decoration: InputDecoration(
                labelText: "Jenis Biji",
                hintText: "Isi jenis biji kopi (gabah/green bean)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _banyakKopiController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Banyak Kopi/Kg",
                hintText: "Isi banyak kopi",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Kirim"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
