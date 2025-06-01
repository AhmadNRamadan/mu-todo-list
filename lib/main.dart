import 'package:flutter/material.dart';
import 'package:mu_todo_list/screens/categories_screen.dart';
import 'package:mu_todo_list/screens/todo_screen.dart';
import 'package:mu_todo_list/screens/welcome_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: TodoScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
