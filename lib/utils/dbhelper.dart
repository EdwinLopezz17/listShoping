import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper{
  final int version = 1;

  Database? db;

  Future<Database> openDb() async{
    if(db == null){
      db = await openDatabase(join(await getDatabasesPath(),
      'shopping.db'),
      onCreate: (database, version){
        database.execute('CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');
        database.execute('CREATE TABLE items(id INTEGER PRIMARY KEY, idList INTEGER,'
            ' name TEXT, quantity TEXT, note TEXT), FOREIGN KEY(idList) REFERENCES lists(id)');
      }, version: version);
    }
    return db!;
  }

  Future testDB() async{
    db=await openDb();
    
    await db!.execute('INSET INTO lists VALUES(0, "Fruits", 1)');
    await db!.execute('INSET INTO items VALUES(1, "Apples", "5 Kgs", "they must be green")');

    List list = await db!.rawQuery('SELECT * FROM lists');
    List items = await db!.rawQuery('SELECT * FROM items');
    
    print(list[0]);
    print(items[0]);
  }
}

