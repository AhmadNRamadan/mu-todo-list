import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  Future<Database> getDatabase() async {
    // get the default databases location
    String dbPath = await getDatabasesPath();
    // If the database is already created, get an instance of it.
    // If it is not there, onCreate is executed
    Database db = await openDatabase(
      // to avoid errors in the database path use join method
      // the database name should always end with .db
      join(dbPath, 'expenses.db'),
      // executed only when the database is not there or when the version is incremented
      onCreate: _onCreate,
      // increment version number only when the database scheme changes: add/drop table, add/drop column, add/drop relation
      version: 1,
    );
    return db;
  }

  _onCreate(Database db, int version) async {
    // This method is called when the database is created for the first time
    await db.execute('CREATE TABLE categories(id TEXT PRIMARY KEY, name TEXT)');
    // await db.execute(
    //   'CREATE TABLE todos('
    //   'id TEXT PRIMARY KEY, '
    //   'title TEXT, '
    //   'description TEXT, '
    //   'isCompleted INTEGER, '
    //   'categoryId TEXT, '
    //   'FOREIGN KEY (categoryId) REFERENCES',
    // );
  }
}
