import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database _database;

Future<Database> databaseInstance(String dbName) async {
  if(_database != null){
    return _database;
  }

  String path = join(await getDatabasesPath(), dbName);
  _database = await openDatabase(path, version: 1, onCreate: (db, _) async {
    await db.transaction((txn) async {

    });
  });
}
