import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markopi/routes/app_page.dart';
import 'package:markopi/service/User_Storage.dart';
import 'package:markopi/view/component/MyBottomNavigation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await initializeDateFormatting();

  Hive.registerAdapter(UserModelAdapter());
  await Hive.openBox<UserModel>('user');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyBottomNavigationBar(), // Gunakan MyBottomNavigationBar di sini
      getPages: AppPages.pages,
    );
  }
}
