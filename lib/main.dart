import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:metamelon/Controller/Dependency_Injection.dart';

import 'ListOfData.dart';

void  main() async {
  runApp(MyApp());
  DependencyInjection.init();
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AllData(),
    );
  }
}