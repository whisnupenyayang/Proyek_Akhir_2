import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key); // Gunakan Key? dan null safety

  final String url = 'http://172.27.80.89:8000/api/budayas';

  Future getBudayas() async{
    var response = await http.get(Uri.parse(url));
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    getBudayas();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'), // Pakai const karena Text tidak berubah
      ),
      body: Container()
    );
  }
}
