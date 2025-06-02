import 'package:flutter/material.dart';
import 'package:mu_todo_list/models/todo.dart';
import 'package:mu_todo_list/screens/add_todo_screen.dart';
import 'package:mu_todo_list/screens/update_todo_screen.dart';
import 'package:mu_todo_list/services/todo_service.dart';
import 'package:mu_todo_list/utils/colors.dart';
import 'package:mu_todo_list/widgets/customed_appbar.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<Todo> _todos = [];
  final TodoService _ts = TodoService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ts
          .getTodos()
          .then((todos) {
            setState(() {
              _todos = todos;
            });
          })
          .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error fetching todos: $error')),
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomedAppBar(title: "Todo Screen"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(
                'Your Todos (2 taps for complete):',
                style: TextStyle(
                  fontSize: 17,
                  color: HColor.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListView.builder(
                itemCount: _todos.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index >= _todos.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (_todos.isEmpty) {
                    return Center(
                      child: Text(
                        'No categories available',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }
                  final todo = _todos[index];
                  return GestureDetector(
                    onDoubleTap: () {
                      todo.isCompleted = todo.isCompleted == 1 ? 0 : 1;
                      _ts.updateTodo(todo).then((_) {
                        setState(() {
                          _todos[index] = todo;
                        });
                      });
                    },

                    onTap: () async {
                      var updatedTodo = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return UpdateTodoScreen(todo: todo);
                          },
                        ),
                      );
                      if (updatedTodo != null) {
                        setState(() {
                          _todos[index] = updatedTodo;
                        });
                      }
                    },
                    child: Card(
                      elevation: 5,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 60,
                              decoration: BoxDecoration(
                                color:
                                    todo.isCompleted == 1
                                        ? HColor.secondary
                                        : HColor.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    todo.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: HColor.primary,
                                    ),
                                  ),

                                  const SizedBox(height: 6),
                                  Text(
                                    todo.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[800],
                                    ),
                                  ),

                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        todo.todoDate,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 13,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            todo.isCompleted == 1
                                                ? Icons.check_circle
                                                : Icons.radio_button_unchecked,
                                            color:
                                                todo.isCompleted == 1
                                                    ? Colors.green
                                                    : Colors.grey,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            todo.isCompleted == 1
                                                ? 'Completed'
                                                : 'Pending',
                                            style: TextStyle(
                                              color:
                                                  todo.isCompleted == 1
                                                      ? Colors.green
                                                      : Colors.grey[700],
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: HColor.primary,
        onPressed: () async {
          var todo = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoScreen()),
          );
          if (todo != null) {
            setState(() {
              _todos.add(todo);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: HColor.primary,
                content: Text(
                  'Todo added successfully!',
                  style: TextStyle(color: HColor.secondary),
                ),
              ),
            );
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
