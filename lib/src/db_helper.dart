import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'siswa.dart';

class DBHelper {
  static late Database _db;
  static const String ID = 'id';
  static const String NAME = 'nama';
  static const String NIM = 'nim';
  static const String TABLE = 'siswa';
  static const String DB_NAME = 'siswa.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY AUTOINCREMENT, $NAME TEXT, $NIM INTEGER");
  }

  Future<Siswa> save(Siswa siswa) async {
    var dbClient = await db;
    siswa.id = await dbClient.insert(TABLE, siswa.toMap());
    return siswa;
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID : ?', whereArgs: [id]);
  }

  Future<int> update(Siswa siswa) async {
    var dbClient = await db;
    return await dbClient
        .update(TABLE, siswa.toMap(), where: '$ID : ?', whereArgs: [siswa.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
