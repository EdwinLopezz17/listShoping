import 'package:shopinglist/models/ListItems.dart';
import 'package:shopinglist/models/ShoppingList.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DbHelper{
  final int version = 1;

  Database? db;

  Future<Database> openDb() async{
    if (db == null){
      db = await openDatabase(join(await getDatabasesPath(),
          'shopping.db'),
          onCreate: (database, version){
            database.execute('CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)');
            database.execute('CREATE TABLE items(id INTEGER PRIMARY KEY, idList INTEGER,'
                'name TEXT, quantity TEXT, note TEXT, FOREIGN KEY(idList) REFERENCES lists(id))');
          }, version: version);
    }
    return db!;
  }




  Future testDB() async{
    db=await openDb();

    await db!.execute('INSERT INTO lists VALUES(0, "Fruits", 1)');
    await db!.execute('INSERT INTO lists VALUES(1, "Impresoras", 3)');
    await db!.execute('INSERT INTO items VALUES(0,0, "Monitor", "5 units", "De plaza vea")');

    List list = await db!.rawQuery('SELECT * FROM lists');
    List items = await db!.rawQuery('SELECT * FROM items');

    print(list[0]);
    print(list[1]);
    print(items[0]);
  }

  Future<int>insertList(ShoppingList list) async{
    int id = await this.db!.insert(
    'lists',list.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<int>insertItem(ListItems item) async{
    int id = await this.db!.insert(
        'items',item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<List<ShoppingList>> getLists()async{
    final List<Map<String, dynamic>> maps = await db!.query('lists');

    return List.generate(maps.length, (i){
      return ShoppingList(
          maps[i]['id'],
          maps[i] ['name'],
          maps[i]['priority'],
      );}
    );

  }
}

