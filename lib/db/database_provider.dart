import 'package:CWCFlutter/model/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  static const String TABLE_FOOD = "food";
  static const String COLUMN_ID = "id";
  static const String COLUMN_DATE = "name";
  static const String COLUMN_AMOUNT = "calories";
  static const String COLUMN_VEGAN = "isVegan";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called");

    if (_database != null) {
      return _database;
    }

    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'foodDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating food table");

        await database.execute(
          "CREATE TABLE $TABLE_FOOD ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_DATE TEXT,"
          "$COLUMN_AMOUNT TEXT,"
          "$COLUMN_VEGAN INTEGER"
          ")",
        );
      },
    );
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;

    var foods = await db
        .query(TABLE_FOOD, columns: [COLUMN_ID, COLUMN_DATE, COLUMN_AMOUNT, COLUMN_VEGAN]);

    List<Contact> foodList = List<Contact>();

    foods.forEach((currentFood) {
      Contact food = Contact.fromMap(currentFood);

      foodList.add(food);
    });

    return foodList;
  }

  Future<Contact> insert(Contact food) async {
    final db = await database;
    food.id = await db.insert(TABLE_FOOD, food.toMap());
    return food;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      TABLE_FOOD,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Contact food) async {
    final db = await database;

    return await db.update(
      TABLE_FOOD,
      food.toMap(),
      where: "id = ?",
      whereArgs: [food.id],
    );
  }
}
