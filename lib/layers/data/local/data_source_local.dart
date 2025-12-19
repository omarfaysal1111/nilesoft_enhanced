// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/base_model.dart';

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
    db = await openDatabase(
      join(path, 'NileSoftv10.db'),
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
              invtime TEXT ALLOW NULL,
              disam REAL ALLOW NULLL,
              disratio REAL ALLOW NULL,
              dis1 REAL ALLOW NULL, 
              mobile_uuid TEXT ALLOW NULL,
              invtype TEXT ALLOW NULL,
              docdate TEXT ALLOW NULL,
              net REAL ALLOW NULL,
              sent INTEGER ALLOW NULL,
              docno TEXT ALLOW NULL,
              longitude REAL ALLOW NULL,
              latitude REAL ALLOW NULL
            )
          """,
        );
        await database.execute("""
            CREATE TABLE salesInvoiceDtl (
              innerid INTEGER PRIMARY KEY AUTOINCREMENT, 
              id TEXT ALLOW NULL,
              itemId TEXT ALLOW NULL,
              itemName TEXT ALLOW NULL,
              qty REAL ALLOW NULL,
              price REAL ALLOW NULL,
              discount REAL ALLOW NULL,
              tax REAL ALLOW NULL,
              disam REAL ALLOW NULL,
              disratio REAL ALLOW NULL,
              sent INTEGER ALLOW NULL,
              unitid TEXT ALLOW NULL,
              unitname TEXT ALLOW NULL,
              factor REAL ALLOW NULL,
              serial INTEGER ALLOW NULL
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
              invtime TEXT ALLOW NULL,
               mobile_uuid TEXT ALLOW NULL,
              tax REAL ALLOW NULL,
              disam REAL ALLOW NULLL,
              disratio REAL ALLOW NULL,
              dis1 REAL ALLOW NULL, 
              invtype TEXT ALLOW NULL,
              docdate TEXT ALLOW NULL,
               net REAL ALLOW NULL,
              sent INTEGER ALLOW NULL,
              docno TEXT ALLOW NULL,
              longitude REAL ALLOW NULL,
              latitude REAL ALLOW NULL
            )
          """,
        );
        await database.execute(
          """
            CREATE TABLE areas (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT ALLOW NULL
            )
          """,
        );
        await database.execute(
          """
            CREATE TABLE cities (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT ALLOW NULL
            )
          """,
        );
        await database.execute(
          """
            CREATE TABLE govs (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              name TEXT ALLOW NULL
            )
          """,
        );
        await database.execute("""
            CREATE TABLE ResalesInvoiceDtl (
              innerid INTEGER PRIMARY KEY AUTOINCREMENT, 
              id TEXT ALLOW NULL,
              itemId TEXT ALLOW NULL,
              itemName TEXT ALLOW NULL,
              qty REAL ALLOW NULL,
              price REAL ALLOW NULL,
              discount REAL ALLOW NULL,
              tax REAL ALLOW NULL,
              disam REAL ALLOW NULL,
              disratio REAL ALLOW NULL,
              sent INTEGER ALLOW NULL,
              unitid TEXT ALLOW NULL,
              unitname TEXT ALLOW NULL,
              factor REAL ALLOW NULL,
              serial INTEGER ALLOW NULL
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
              client Text ALLOW NULL,
              descr TEXT NOT NULL,
              mobile_uuid TEXT ALLOW NULL,
              accid TEXT ALLOW NULL,
              docno TEXT ALLOW NULL,
              total REAL NOT NULL,
              sent INTEGER ALLOW NULL,
              longitude REAL ALLOW NULL,
              latitude REAL ALLOW NULL
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
  acctype TEXT ALLOW NULL,
  discountratio REAL ALLOW NULL
)
""");
        await database.execute("""
CREATE TABLE items (
  itemid TEXT ALLOW NULL,
  name TEXT ALLOW NULL,
  price REAL ALLOW NULL,
  qty REAL ALLOW NULL,
  barcode TEXT ALLOW NULL,
  hasSerial REAL ALLOW NULL,
  unitid TEXT ALLOW NULL,
  unitname TEXT ALLOW NULL,
  factor REAL ALLOW NULL
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
  invoiceserial ALLOW NULL,
  multiunit INTEGER ALLOW NULL
)
""");
        await database.execute("""
CREATE TABLE mobileItemUnits (
  itemid TEXT ALLOW NULL,
  unitid TEXT ALLOW NULL,
  unitname TEXT ALLOW NULL,
  factor REAL ALLOW NULL
)
""");
      },
      version: 9,
      onUpgrade: (database, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add new columns to items table
          await database.execute("""
          ALTER TABLE items ADD COLUMN unitid TEXT
        """);
          await database.execute("""
          ALTER TABLE items ADD COLUMN unitname TEXT
        """);
          await database.execute("""
          ALTER TABLE items ADD COLUMN factor REAL
        """);
        }
        if (oldVersion < 3) {
          // Create mobileItemUnits table
          await database.execute("""
CREATE TABLE mobileItemUnits (
  itemid TEXT ALLOW NULL,
  unitid TEXT ALLOW NULL,
  unitname TEXT ALLOW NULL,
  factor REAL ALLOW NULL
)
        """);
          // Add multiunit column to settings table
          await database.execute("""
          ALTER TABLE settings ADD COLUMN multiunit INTEGER
        """);
          // Add unit columns to salesInvoiceDtl table
          await database.execute("""
          ALTER TABLE salesInvoiceDtl ADD COLUMN unitid TEXT
        """);
          await database.execute("""
          ALTER TABLE salesInvoiceDtl ADD COLUMN unitname TEXT
        """);
          await database.execute("""
          ALTER TABLE salesInvoiceDtl ADD COLUMN factor REAL
        """);
          // Add unit columns to ResalesInvoiceDtl table
          await database.execute("""
          ALTER TABLE ResalesInvoiceDtl ADD COLUMN unitid TEXT
        """);
          await database.execute("""
          ALTER TABLE ResalesInvoiceDtl ADD COLUMN unitname TEXT
        """);
          await database.execute("""
          ALTER TABLE ResalesInvoiceDtl ADD COLUMN factor REAL
        """);
        }
        if (oldVersion < 4) {
          // Add docno column to salesInvoiceHead table
          await database.execute("""
          ALTER TABLE salesInvoiceHead ADD COLUMN docno TEXT
        """);
          // Add docno column to ResalesInvoiceHead table
          await database.execute("""
          ALTER TABLE ResalesInvoiceHead ADD COLUMN docno TEXT
        """);
        }
        if (oldVersion < 5) {
          // Add serial column to salesInvoiceDtl table
          await database.execute("""
          ALTER TABLE salesInvoiceDtl ADD COLUMN serial INTEGER
        """);
          // Add serial column to ResalesInvoiceDtl table
          await database.execute("""
          ALTER TABLE ResalesInvoiceDtl ADD COLUMN serial INTEGER
        """);
        }
        if (oldVersion < 6) {
          // Add discount_ratio column to Customers table
          await database.execute("""
          ALTER TABLE Customers ADD COLUMN discount_ratio REAL
        """);
        }
        if (oldVersion < 7) {
          // Add longitude and latitude columns to salesInvoiceHead table
          await database.execute("""
          ALTER TABLE salesInvoiceHead ADD COLUMN longitude REAL
        """);
          await database.execute("""
          ALTER TABLE salesInvoiceHead ADD COLUMN latitude REAL
        """);
          // Add longitude and latitude columns to ResalesInvoiceHead table
          await database.execute("""
          ALTER TABLE ResalesInvoiceHead ADD COLUMN longitude REAL
        """);
          await database.execute("""
          ALTER TABLE ResalesInvoiceHead ADD COLUMN latitude REAL
        """);
          // Add longitude and latitude columns to cashIn table
          await database.execute("""
          ALTER TABLE cashIn ADD COLUMN longitude REAL
        """);
          await database.execute("""
          ALTER TABLE cashIn ADD COLUMN latitude REAL
        """);
        }
        if (oldVersion < 8) {
          // Add longitude and latitude columns if they don't exist (for databases that were already at version 7)
          try {
            await database.execute("""
            ALTER TABLE salesInvoiceHead ADD COLUMN longitude REAL
          """);
          } catch (e) {
            // Column might already exist, ignore error
          }
          try {
            await database.execute("""
            ALTER TABLE salesInvoiceHead ADD COLUMN latitude REAL
          """);
          } catch (e) {
            // Column might already exist, ignore error
          }
          try {
            await database.execute("""
            ALTER TABLE ResalesInvoiceHead ADD COLUMN longitude REAL
          """);
          } catch (e) {
            // Column might already exist, ignore error
          }
          try {
            await database.execute("""
            ALTER TABLE ResalesInvoiceHead ADD COLUMN latitude REAL
          """);
          } catch (e) {
            // Column might already exist, ignore error
          }
          try {
            await database.execute("""
            ALTER TABLE cashIn ADD COLUMN longitude REAL
          """);
          } catch (e) {
            // Column might already exist, ignore error
          }
          try {
            await database.execute("""
            ALTER TABLE cashIn ADD COLUMN latitude REAL
          """);
          } catch (e) {
            // Column might already exist, ignore error
          }
        }
        if (oldVersion < 9) {
          // Ensure longitude and latitude columns exist (for databases that were already at version 8)
          try {
            await database.execute("""
            ALTER TABLE salesInvoiceHead ADD COLUMN longitude REAL
          """);
          } catch (e) {
            // Column might already exist, ignore error
          }
          try {
            await database.execute("""
            ALTER TABLE salesInvoiceHead ADD COLUMN latitude REAL
          """);
          } catch (e) {
            // Column might already exist, ignore error
          }
          try {
            await database.execute("""
            ALTER TABLE ResalesInvoiceHead ADD COLUMN longitude REAL
          """);
          } catch (e) {
            // Column might already exist, ignore error
          }
          try {
            await database.execute("""
            ALTER TABLE ResalesInvoiceHead ADD COLUMN latitude REAL
          """);
          } catch (e) {
            // Column might already exist, ignore error
          }
          try {
            await database.execute("""
            ALTER TABLE cashIn ADD COLUMN longitude REAL
          """);
          } catch (e) {
            // Column might already exist, ignore error
          }
          try {
            await database.execute("""
            ALTER TABLE cashIn ADD COLUMN latitude REAL
          """);
          } catch (e) {
            // Column might already exist, ignore error
          }
        }
      },
    );
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
    int id = await db.insert(tableName, model.toMap());
    return id; // this is the new row IDt;
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

  Future<T?> getRecordByBarcode<T extends BaseModel>(String tableName,
      String barcode, T Function(Map<String, dynamic>) fromMap) async {
    final List<Map<String, dynamic>> result =
        await db.query(tableName, where: 'barcode = ?', whereArgs: [barcode]);

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
      T model, String tableName, int id) async {
    int result = await db.update(
      tableName,
      model.toMap(),
      where: 'innerid = ?',
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

  Future<void> deleteData() async {
    await db.delete(
      'salesInvoiceHead',
      where: "1 = 1",
      //whereArgs: [id],
    );
    await db.delete(
      'ResalesInvoiceHead',
      where: "1 = 1",
      //whereArgs: [id],
    );
    await db.delete(
      'salesInvoiceDtl',
      where: "1 = 1",
      //whereArgs: [id],
    );
    await db.delete(
      'ResalesInvoiceDtl',
      where: "1 = 1",
      //whereArgs: [id],
    );
    await db.delete(
      'purInvoiceHead',
      where: "1 = 1",
      //whereArgs: [id],
    );
    await db.delete(
      'purInvoiceDtl',
      where: "1 = 1",
      //whereArgs: [id],
    );
    await db.delete(
      'orderHead',
      where: "1 = 1",
      //whereArgs: [id],
    );
    await db.delete(
      'orderDtl',
      where: "1 = 1",
      //whereArgs: [id],
    );
    await db.delete(
      'cashIn',
      where: "1 = 1",
      //whereArgs: [id],
    );
    await db.delete(
      'cashInDtl',
      where: "1 = 1",
      //whereArgs: [id],
    );
  }

  Future<int> checkSerialNo(String id) async {
    int qty = 0;
    String query =
        "select sum(${DatabaseConstants.salesInvoiceDtlTable}.qty) as Qty "
        "from ${DatabaseConstants.salesInvoiceDtlTable}"
        " inner join items on ${DatabaseConstants.salesInvoiceDtlTable}.itemId = items.itemid  where id = '$id'"
        " and items.hasSerial=1";
    final List<Map<String, dynamic>> result = await db.rawQuery(query);

    if (result.isNotEmpty && result[0]["Qty"] != null) {
      double c = double.parse(result[0]["Qty"].toString());
      qty = c.truncate();
      if (kDebugMode) {
        print("Qty: $qty");
      }
    } else {
      if (kDebugMode) {
        print("No results or Qty is null.");
      }
    }
    return qty;
  }

  Future<int?> getLatestId(String tableName) async {
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT MAX(id) as latestId FROM $tableName');

    if (result.isNotEmpty && result.first['latestId'] != null) {
      return result.first['latestId'] as int;
    }
    return null; // Return null if the table is empty or no ID exists
  }

  Future<List<T>> getCashIns<T extends BaseModel>(String tableName, int id,
      T Function(Map<String, dynamic>) fromMap) async {
    String query =
        "select $tableName.*, ${DatabaseConstants.customersTable}.name as clientName from $tableName inner join ${DatabaseConstants.customersTable} on $tableName.accid=${DatabaseConstants.customersTable}.id where $tableName.id='$id'";

    final List<Map<String, dynamic>> result = await db.rawQuery(query);

    //tableName, where: 'id = ?', whereArgs: [id]

    return result.map((map) => fromMap(map)).toList();
  }

  Future<List<T>> getRecordsById<T extends BaseModel>(String tableName,
      String id, T Function(Map<String, dynamic>) fromMap) async {
    String query =
        "select $tableName.*, ${DatabaseConstants.itemsTable}.name as itemName from $tableName inner join ${DatabaseConstants.itemsTable} on $tableName.itemId=${DatabaseConstants.itemsTable}.itemid where $tableName.id='$id'";

    final List<Map<String, dynamic>> result = await db.rawQuery(query);

    //tableName, where: 'id = ?', whereArgs: [id]

    return result.map((map) => fromMap(map)).toList();
  }

  Future<List<T>> getRecordWhereSent<T extends BaseModel>(String tableName,
      int sent, T Function(Map<String, dynamic>) fromMap) async {
    String query = "select * from $tableName where sent=$sent";

    final List<Map<String, dynamic>> result = await db.rawQuery(query);
    return result.map((map) => fromMap(map)).toList();
  }

  Future<int> deleteAllRecord(String tableName) async {
    int result = await db.delete(tableName, where: '1 = 1');

    return result;
  }
}
