// ignore_for_file: file_names

import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/models/base_model.dart';

import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._();

  DatabaseHelper._();

  late Database db;

  factory DatabaseHelper() {
    return _databaseHelper;
  }
  Future<void> initDB() async {
    String path = await getDatabasesPath();
    db = await openDatabase(join(path, 'DB1119e9u707638791j49j48s.db'),
        onCreate: (database, version) async {
      await database.execute(
        """
            CREATE TABLE salesInvoiceHead (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              accid TEXT ALLOW NULL,
              clientName TEXT ALLOW NULL,
              descr TEXT ALLOW NULL,
              invoiceno TEXT ALLOW NULL,
              total REAL ALLOW NULL,
              tax REAL ALLOW NULL,
              dis1 REAL ALLOW NULL, 
              invtype TEXT ALLOW NULL,
              docdate TEXT ALLOW NULL,
               net REAL ALLOW NULL,
              sent INTEGER ALLOW NULL
            )
          """,
      );
      await database.execute("""
            CREATE TABLE salesInvoiceDtl (
              id TEXT ALLOW NULL,
              itemId TEXT ALLOW NULL,
              itemName TEXT ALLOW NULL,
              qty REAL ALLOW NULL,
              price REAL ALLOW NULL,
              discount REAL ALLOW NULL,
              tax REAL ALLOW NULL,
              disam REAL ALLOW NULL,
              disratio REAL ALLOW NULL,
              sent INTEGER ALLOW NULL
            )
          """);

      await database.execute(
        """
            CREATE TABLE ResalesInvoiceHead (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              accid TEXT ALLOW NULL,
              clientName TEXT ALLOW NULL,
              descr TEXT ALLOW NULL,
              invoiceno TEXT ALLOW NULL,
              total REAL ALLOW NULL,
              tax REAL ALLOW NULL,
              dis1 REAL ALLOW NULL, 
invtype TEXT ALLOW NULL,
docdate TEXT ALLOW NULL,
               net REAL ALLOW NULL,

              sent INTEGER ALLOW NULL
            )
          """,
      );
      await database.execute("""
            CREATE TABLE ResalesInvoiceDtl (
              id TEXT ALLOW NULL,
              itemId TEXT ALLOW NULL,
              itemName TEXT ALLOW NULL,
              qty REAL ALLOW NULL,
              price REAL ALLOW NULL,
              discount REAL ALLOW NULL,
              tax REAL ALLOW NULL,
              disam REAL ALLOW NULL,
              disratio REAL ALLOW NULL,
              sent INTEGER ALLOW NULL
            )
          """);

      await database.execute(
        """
            CREATE TABLE purInvoiceHead (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              accid TEXT ALLOW NULL,
              clientName TEXT ALLOW NULL,
              descr TEXT ALLOW NULL,
              invoiceno TEXT ALLOW NULL,
              total REAL ALLOW NULL,
              docdate TEXT ALLOW NULL,
              tax REAL ALLOW NULL,
              dis1 REAL ALLOW NULL, 
              net REAL ALLOW NULL,
              invtype TEXT ALLOW NULL,
              sent INTEGER ALLOW NULL
            )
          """,
      );

      await database.execute("""
            CREATE TABLE purInvoiceDtl (
              id TEXT ALLOW NULL,
              itemId TEXT ALLOW NULL,
              itemName TEXT ALLOW NULL,
              qty REAL ALLOW NULL,
              price REAL ALLOW NULL,
              discount REAL ALLOW NULL,
              tax REAL ALLOW NULL,
              disam REAL ALLOW NULL,
              disratio REAL ALLOW NULL,
              sent INTEGER ALLOW NULL
            )
          """);

      await database.execute("""
           CREATE TABLE orderHead (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              clientId INTEGER ALLOW NULL,
              clientName TEXT ALLOW NULL,
              notes TEXT ALLOW NULL,
              sent INTEGER ALLOW NULL

           )
        """);
      await database.execute("""
           CREATE TABLE orderDtl (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              itemId INTEGER ALLOW NULL,
              itemName TEXT ALLOW NULL,
              qty REAL ALLOW NULL,
              price REAL ALLOW NULL,
              tax REAL ALLOW NULL,
              discount REAL ALLOW NULL,
              sent INTEGER ALLOW NULL
           )
        """);
      await database.execute("""
           CREATE TABLE cashIn (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              docdate TEXT NOT NULL,
              descr TEXT NOT NULL,
              accid TEXT ALLOW NULL,
              docno TEXT ALLOW NULL,
              total REAL NOT NULL,
              sent INTEGER ALLOW NULL
           )
        """);
      await database.execute("""
           CREATE TABLE cashInDtl (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              accountid TEXT ALLOW NULL,
              amount REAL ALLOW NULL,
              discount REAL ALLOW NULL,
              descr TEXT ALLOW NULL,
              shiftid INTEGER ALLOW NULL,
              branchid INTEGER ALLOW NULL,
              docno  TEXT ALLOW NULL,
              salesmanid TEXT ALLOW NULL,
              serial REAL ALLOW NULL,
              sent INTEGER ALLOW NULL
           )
        """);

      await database.execute("""
CREATE TABLE Customers (
  id INT ALLOW NULL,
  name TEXT ALLOW NULL,
  acctype TEXT ALLOW NULL
)
""");
      await database.execute("""
CREATE TABLE items (
  itemid TEXT ALLOW NULL,
  name TEXT ALLOW NULL,
  price REAL ALLOW NULL,
  qty REAL ALLOW NULL,
  barcode TEXT ALLOW NULL,
  hasSerial REAL ALLOW NULL
)
""");
      await database.execute("""
CREATE TABLE itemsserials (
  itemid TEXT ALLOW NULL,
  name TEXT ALLOW NULL,
  serialNumber TEXT ALLOW NULL
)
""");

      await database.execute("""
CREATE TABLE serials (
  invid TEXT ALLOW NULL,
  serialNumber TEXT ALLOW NULL
)
""");
      await database.execute("""
CREATE TABLE settings (
  mobileUserId TEXT ALLOW NULL,
  cashaccId TEXT ALLOW NULL,
  coinPrice TEXT ALLOW NULL,
  invid TEXT ALLOW NULL,
  visaId TEXT ALLOW NULL,
  invoiceserial ALLOW NULL
)
""");
    }, version: 1);
  }

  Future<void> deleteSettings() async {
    await db.delete(
      'settings',
      where: "1 = 1",
      //whereArgs: [id],
    );
  }

  Future<int> insertRecord<T extends BaseModel>(
      T model, String tableName) async {
    int result = await db.insert(tableName, model.toMap());
    return result;
  }

  Future<int> insertListRecords<T extends BaseModel>(
      List<T> models, String tableName) async {
    int insertedCount = 0;

    await db.transaction((txn) async {
      for (var model in models) {
        await txn.insert(tableName, model.toMap());
        insertedCount++;
      }
    });

    return insertedCount;
  }

  Future<List<T>> getAllRecords<T extends BaseModel>(
      String tableName, T Function(Map<String, dynamic>) fromMap) async {
    final List<Map<String, dynamic>> result = await db.query(tableName);
    return result.map((map) => fromMap(map)).toList();
  }

  Future<T?> getRecordById<T extends BaseModel>(String tableName, int id,
      T Function(Map<String, dynamic>) fromMap) async {
    final List<Map<String, dynamic>> result =
        await db.query(tableName, where: 'id = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<int> updateRecord<T extends BaseModel>(
      T model, String tableName, int id) async {
    int result = await db.update(
      tableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<int> updateRecordStringId<T extends BaseModel>(
      T model, String tableName, String id) async {
    int result = await db.update(
      tableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
    return result;
  }

  Future<int> deleteRecord(String tableName, int id) async {
    int result = await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result;
  }

  Future<int?> getLatestId(String tableName) async {
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT MAX(id) as latestId FROM $tableName');

    if (result.isNotEmpty && result.first['latestId'] != null) {
      return result.first['latestId'] as int;
    }
    return null; // Return null if the table is empty or no ID exists
  }

  Future<List<T>> getRecordsById<T extends BaseModel>(String tableName,
      String id, T Function(Map<String, dynamic>) fromMap) async {
    String s =
        "select $tableName.*, ${DatabaseConstants.itemsTable}.name as itemName from $tableName inner join ${DatabaseConstants.itemsTable} on $tableName.itemId=${DatabaseConstants.itemsTable}.itemid ";
    String s1 = "where $tableName.id='$id'";

    final List<Map<String, dynamic>> result = await db.rawQuery(s + s1);

    //tableName, where: 'id = ?', whereArgs: [id]

    return result.map((map) => fromMap(map)).toList();
  }

  Future<int> deleteAllRecord(String tableName) async {
    int result = await db.delete(tableName, where: '1 = 1');

    return result;
  }
}
