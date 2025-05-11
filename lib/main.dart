import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qtech_solution/view/productList_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  //Hive.registerAdapter(ProductAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qtec Product App',
      home: ProductListScreen(),

      //Changes ...................
    );
  }
}
