import 'package:mu_todo_list/database/repo.dart';
import 'package:mu_todo_list/models/category.dart';

class CategoryService {
  final Repository _repository;

  CategoryService() : _repository = Repository();

  void storeCategory(Category category) async {
    final db = await _repository.getDatabase();
    await db.insert('categories', category.toMap());
  }

  Future<List<Category>> getCategories() async {
    final db = await _repository.getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('categories');
    
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  } 

  Future<void> deleteCategory(Category category) async {
    final db = await _repository.getDatabase();
    await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }
}
