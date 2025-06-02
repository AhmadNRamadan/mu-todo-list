import 'package:flutter/material.dart';
import 'package:mu_todo_list/screens/categories_screen.dart';
import 'package:mu_todo_list/screens/todo_screen.dart';
import 'package:mu_todo_list/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [TodoScreen(key: HColor.todoKey), CategoriesScreen()],
        onPageChanged: (value) {
          setState(() {
            _currentPage = value;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: HColor.primary,
        backgroundColor: HColor.secondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Todo'),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
        ],
        currentIndex: _currentPage,
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
          _pageController.jumpToPage(index);
        },
      ),
    );
  }
}
