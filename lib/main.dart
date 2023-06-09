import 'package:flutter/material.dart';
import 'homepage.dart';
import 'hive_db.dart';

void main() async {
  await HiveDB.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp( 
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}