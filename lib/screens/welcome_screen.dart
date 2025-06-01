import 'package:flutter/material.dart';
import 'package:mu_todo_list/screens/todo_screen.dart';
import 'package:mu_todo_list/utils/colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            Image.asset('assets/images/mu-logo.png', width: 200, height: 200),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Mu Todo List',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your personal task manager',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: HColor.primary,
                elevation: 0,

                fixedSize: Size(MediaQuery.of(context).size.width * 0.5, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => TodoScreen()),
                );
              },
              child: Text(
                'Get Started',
                style: TextStyle(color: HColor.secondary, fontSize: 14),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
