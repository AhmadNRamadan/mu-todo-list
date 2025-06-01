import 'package:uuid/uuid.dart';

class Category {
  final String id;
  final String name;

  Category({id, required this.name}) : id = id ?? Uuid().v4();

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(id: map['id'] as String, name: map['name'] as String);
  }
}
