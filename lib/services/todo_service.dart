import 'package:mu_todo_list/database/repo.dart';
import 'package:mu_todo_list/models/todo.dart';

class TodoService {
  final Repository _repository;
  TodoService() : _repository = Repository(); 

  Future<void> storeTodo(Todo todo) async {
    final db = await _repository.getDatabase();
    await db.insert('todos', todo.toMap());
  } 

  Future<void> updateTodo(Todo todo) async {
    final db = await _repository.getDatabase();
    await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }
  
  Future<List<Todo>> getTodos() async {
    final db = await _repository.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('todos');
    final List<Todo> todos = List.generate(maps.length, (i) {
      return Todo.fromMap(maps[i]);
    });
    return todos;
  } 

  Future<void> deleteTodo(String id) async {
    final db = await _repository.getDatabase();
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  } 
}