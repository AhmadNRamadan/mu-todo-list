import 'package:uuid/uuid.dart';

class Todo {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String todoDate;
   int isCompleted;

  Todo({
   id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.todoDate, 
    this.isCompleted = 0,
  }): id = id ?? Uuid().v4();

  // Factory constructor to create a Todo from a map
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      isCompleted: map['isCompleted'] as int, 
      categoryId: map['categoryId'] as String,
      todoDate: map['todoDate'] as String,
    );
  }

  // Method to convert a Todo to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'categoryId': categoryId,
      'todoDate': todoDate,
    };
  }
}
