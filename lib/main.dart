import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'home_page.dart';

void main() async{

  await Hive.initFlutter();

  await Hive.openBox("habit_db");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Привычки',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.green).copyWith(background: Colors.white),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}



