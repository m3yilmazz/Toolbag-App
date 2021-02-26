import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'ToDoListItemModel.dart';
import 'ToDoListTitleModel.dart';

/// Buradaki database fonksiyonlarinin nasil kullanilacagina dair yapilan kullanimlar
/// https://www.tutorialspoint.com/flutter/flutter_database_concepts.htm
/// ve
/// https://github.com/RobertBrunhage/Youtube-Tutorials/tree/master/sqflite_crud
/// reposundan kimisi direkt olarak alinmis kimisi de projeye uygun olacak bicimde sekillendirilmistir.

class ToDoListManager {
  static const String ToDoListTitlesTableName = "ToDoListTitles";
  static const String ToDoListItemsTableName = "ToDoListItems";
  static Database _database;

  ToDoListManager() {
    database;
  }

  Future<Database> get database async {
    if(_database != null)
      return _database;
    _database = await initializeDatabase();
    return _database;
  }

  initializeDatabase() async {
    String databasePath = await getDatabasesPath();
    String fullDatabasePath = join(databasePath, "ToDoListTitles.db");
    return await openDatabase(
      fullDatabasePath,
      version: 1,
      onCreate: _onCreate
    );
  }

  void _onCreate(Database db, int version) async {
    try {
      await db.execute("CREATE TABLE "
          + ToDoListTitlesTableName
          + " (id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, isCompleted INTEGER)"
      );
    } catch (e){print(e.toString());}

    try {
      await db.execute("CREATE TABLE "
          + ToDoListItemsTableName
          + " (id INTEGER PRIMARY KEY AUTOINCREMENT, titleId INTEGER,"
          + " itemName STRING, isCompleted INTEGER)"
      );
    }catch(e){print(e.toString());}
  }

  static Future<void> insertToDoListTitle(ToDoListTitleModel toDoListTitle) async {
    final Database database = await _database;
    await database.insert(
      ToDoListTitlesTableName,
      toDoListTitle.toDoListTitleToMap(),
    );
  }

  static Future<void> insertToDoListItem(ToDoListItemModel toDoListItem) async {
    final Database database = await _database;
    await database.insert(
      ToDoListItemsTableName,
      toDoListItem.toDoListItemToMap()
    );
  }

  static Future<List<ToDoListTitleModel>> getAllToDoListTitles() async {
    final Database database = await _database;
    final List<Map<String, dynamic>> maps = await database.query(ToDoListTitlesTableName);
    List<ToDoListTitleModel> tempList = List();

    maps.forEach((element) {
      tempList.add(ToDoListTitleModel.fromJson(element));
    });
    return tempList;
  }

  static Future<List<ToDoListItemModel>> getToDoListItemsByTitleId(int titleId) async {
    Database database = await _database;
    List<Map<String, dynamic>> maps =
    await database.query(
        ToDoListItemsTableName,
        where: "titleId = ?",
        whereArgs: [titleId],
    );

    List<ToDoListItemModel> tempList = new List<ToDoListItemModel>();
    for(Map element in maps){
      tempList.add(ToDoListItemModel.fromJson(element));
    }
    return tempList;
  }

  static Future<void> deleteToDoListTitle(int id) async{
    final Database database = await _database;
    await database.delete(ToDoListTitlesTableName, where: "id = ?", whereArgs: [id]);
  }

  static Future<void> deleteToDoListItem(int id) async{
    final Database database = await _database;
    await database.delete(ToDoListItemsTableName, where: "id = ?", whereArgs: [id]);
  }

  static Future<void> deleteToDoListItemByTitleId(int titleId) async{
    final Database database = await _database;
    await database.delete(ToDoListItemsTableName, where: "titleId = ?", whereArgs: [titleId]);
  }

  static Future<void> deleteAllToDoListItemsByTitleId(int titleId) async{
    final Database database = await _database;
    List<Map<String, dynamic>> maps =
    await database.query(
      ToDoListItemsTableName,
      where: "titleId = ?",
      whereArgs: [titleId],
    );

    List<ToDoListItemModel> tempList = new List<ToDoListItemModel>();
    for(Map element in maps){
      tempList.add(ToDoListItemModel.fromJson(element));
    }

    tempList.forEach((element) async {
      await database.delete(ToDoListItemsTableName, where: "titleId = ?", whereArgs: [element.titleId]);
    });
  }

  static Future<void> updateToDoListTitle(ToDoListTitleModel toDoListTitleModel) async{
    final Database database = await _database;
    await database.update(
        ToDoListTitlesTableName,
        toDoListTitleModel.toDoListTitleToMap(),
        where: "id = ?",
        whereArgs: [toDoListTitleModel.id]
    );
  }

  static Future<void> updateToDoListItem(ToDoListItemModel toDoListItemModel) async{
    final Database database = await _database;
    await database.update(
        ToDoListItemsTableName,
        toDoListItemModel.toDoListItemToMap(),
        where: "id = ?",
        whereArgs: [toDoListItemModel.id]
    );
  }
}