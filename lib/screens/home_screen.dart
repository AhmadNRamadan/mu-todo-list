import 'package:flutter/material.dart';
import 'package:mu_todo_list/widgets/customed_appbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomedAppBar(title: "Home Screen"),
      body: Center(child: Text('Welcome to the Home Screen!')),
    );
  }
}
