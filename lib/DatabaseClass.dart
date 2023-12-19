import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class myDatabase {
  Database? mydatabase;

  Future<Database?> checkdata() async {
    if (mydatabase == null) {
      mydatabase = await creating();
      return mydatabase;
    } else {
      return mydatabase;
    }
  }

  int Version = 1;
  String DBname = 'businesscards.db';

  creating() async {
    String databasepath = await getDatabasesPath();
    String mypath = join(databasepath, DBname);
    Database mydb =
        await openDatabase(mypath, version: Version, onCreate: (db, version) {
      db.execute('''CREATE TABLE IF NOT EXISTS 'FILE1'(
      'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      'NAME' TEXT NOT NULL,
      'COMPANY' TEXT NOT NULL,
      'EMAIL' TEXT NOT NULL,
      'PHONE' TEXT NOT NULL)''');
    });
    return mydb;
  }

  isexist() async {
    String databasepath = await getDatabasesPath();
    String mypath = join(databasepath, DBname);
    await databaseExists(mypath) ? print("it exists") : print("not exist");
  }

  reseting() async {
    String databasepath = await getDatabasesPath();
    String mypath = join(databasepath, 'businesscards.db');
    await deleteDatabase(mypath);
  }

  reading(sql) async {
    Database? somevar = await checkdata();
    var myesponse = somevar!.rawQuery(sql);
    return myesponse;
  }

  write(sql) async {
    Database? somevar = await checkdata();
    var myesponse = somevar!.rawInsert(sql);
    return myesponse;
  }

  update(sql) async {
    Database? somevar = await checkdata();
    var myesponse = somevar!.rawUpdate(sql);
    return myesponse;
  }

  delete(sql) async {
    Database? somevar = await checkdata();
    var myesponse = somevar!.rawDelete(sql);
    return myesponse;
  }
}
