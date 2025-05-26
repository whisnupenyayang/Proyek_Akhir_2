import 'package:flutter/material.dart';
import 'package:markopi/service/User_Storage.dart';
import 'package:markopi/service/User_Storage_Service.dart';
import './MyAppBar.dart';
import './MyBody.dart';

import 'package:hive_flutter/hive_flutter.dart';

class Beranda extends StatelessWidget {
  final userStorage = UserStorage();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Box<UserModel>>(
      future: userStorage.openBox(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }


        final user = userStorage.getUser();
        print(user);

        return Scaffold(
          backgroundColor: const Color(0xFFF4F4F4),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 12),
              child: MyAppBar(),
            ),
          ),
          body: BerandaBody(),
        );
      },
      );
  }
}
