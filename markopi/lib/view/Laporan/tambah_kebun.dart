import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/controllers/tambah_kebun.dart';

class TambahKebunPage extends StatelessWidget {
  TambahKebunPage({super.key});

  final TambahKebunController controller = Get.put(TambahKebunController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kebun')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: controller.namaKebun,
                decoration: const InputDecoration(labelText: 'Nama Kebun'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: controller.lokasi,
                decoration: const InputDecoration(labelText: 'Lokasi'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: controller.luasKebun,
                decoration: const InputDecoration(labelText: 'Luas Kebun (ha)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Wajib diisi';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2696D6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                      foregroundColor: Colors.white,
                    ),
                    onPressed:
                        controller.loading.value ? null : controller.submitForm,
                    child: controller.loading.value
                        ? const CircularProgressIndicator()
                        : const Text('Simpan'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
