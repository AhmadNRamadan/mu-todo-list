import 'package:flutter/material.dart';
import 'package:mu_todo_list/models/todo.dart';
import 'package:mu_todo_list/screens/add_todo_screen.dart';
import 'package:mu_todo_list/services/todo_service.dart';
import 'package:mu_todo_list/utils/colors.dart';
import 'package:mu_todo_list/widgets/customed_appbar.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> todos = [];
  final TodoService _ts = TodoService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomedAppBar(title: "Todo Screen"),
      body: FutureBuilder(
        future: _ts.getTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ||
              (snapshot.data as List<Todo>).isEmpty) {
            return Center(
              child: Text(
                'No todos found.',
                style: TextStyle(color: HColor.primary, fontSize: 20),
              ),
            );
          } else {
            todos = snapshot.data as List<Todo>;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                  trailing: IconButton(
                    icon: Icon(
                      todo.isCompleted
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                    ),
                    onPressed: () async {
                      todo.isCompleted = !todo.isCompleted;
                      await _ts.updateTodo(todo);
                      setState(() {});
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HColor.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
