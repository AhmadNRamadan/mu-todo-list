import 'package:flutter/material.dart';
import 'package:mu_todo_list/utils/colors.dart';

class CustomedAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomedAppBar({required this.title, super.key});
  final String title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: TextStyle(color: HColor.secondary)),
      backgroundColor: HColor.primary,
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
