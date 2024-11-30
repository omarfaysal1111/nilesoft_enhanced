// ignore_for_file: file_names

import 'package:nilesoft_erp/layers/data/models/cashin_model.dart';
import 'package:nilesoft_erp/layers/data/models/customers_model.dart';
import 'package:nilesoft_erp/layers/data/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/data/models/item_seerials_model.dart';
import 'package:nilesoft_erp/layers/data/models/items_model.dart';
import 'package:nilesoft_erp/layers/data/models/order_head_model.dart';
import 'package:nilesoft_erp/layers/data/models/reinvoice_model.dart';
import 'package:nilesoft_erp/layers/data/models/serials_model.dart';
import 'package:nilesoft_erp/layers/data/models/settings_model.dart';
import 'package:sqflite/sqflite.dart';
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

  Future<int> insertInvoiceHead(SalesHeadModel salesModel) async {
    int result = await db.insert('salesInvoiceHead', salesModel.toMap());

    // print(result);
    return result;
  }

  Future<int> insertRsalseHead(RSalesHeadModel salesModel) async {
    int result = await db.insert('ResalesInvoiceHead', salesModel.toMap());

    // print(result);
    return result;
  }

  Future<int> insertpurHead(SalesHeadModel salesModel) async {
    int result = await db.insert('purInvoiceHead', salesModel.toMap());

    // print(result);
    return result;
  }

  Future<int> insertSettings(SettingsModel settingsModel) async {
    int result = await db.insert('settings', settingsModel.toMap());

    // print(result);
    return result;
  }

  Future<int> insertitemsserials(ItemsSerialsModel salesModel) async {
    int result = await db.insert('itemsserials', salesModel.toMap());

    // print(result);
    return result;
  }

  Future<int> insertInvoiceDtl(SalesDtlModel salesModel) async {
    int result = await db.insert('salesInvoiceDtl', salesModel.toMap());

    return result;
  }

  Future<int> insertRsalesDtl(RSalesDtlModel salesModel) async {
    int result = await db.insert('ResalesInvoiceDtl', salesModel.toMap());

    return result;
  }

  Future<int> insertpureDtl(SalesDtlModel salesModel) async {
    int result = await db.insert('purInvoiceDtl', salesModel.toMap());

    return result;
  }

  Future<void> deleteDtl(String id) async {
    await db.delete(
      'salesInvoiceDtl',
      where: "id =" + id,
      //whereArgs: [id],
    );
  }

  Future<void> deletepurDtl(String id) async {
    await db.delete(
      'purInvoiceDtl',
      where: "id =" + id,
      //whereArgs: [id],
    );
  }

  Future<void> deleteSerial(String id, String serialNumber) async {
    await db.delete(
      'serials',
      where: "invid ='" + id + "' and serialNumber= '" + serialNumber + "'",
      //whereArgs: [id],
    );
  }

  Future<int> insertOrderHead(OrderHeadModel orderModel) async {
    int result = await db.insert('orderHead', orderModel.toMap());

    // print(result);
    return result;
  }

  Future<int> insertOrderDtl(OrderDtlModel orderDtlModel) async {
    int result = await db.insert('orderDtl', orderDtlModel.toMap());

    return result;
  }

  Future<int> insertItems(ItemsModel itemsModel) async {
    int result = await db.insert('items', itemsModel.toMap());

    // print(result);
    return result;
  }

  Future<int> insertCustomer(CustomersModel customersModel) async {
    int result = await db.insert('Customers', customersModel.toMap());

    // print(result);
    return result;
  }

  Future<void> deleteSettings() async {
    await db.delete(
      'settings',
      where: "1 = 1",
      //whereArgs: [id],
    );
  }

  Future<int> insertCashIn(CashinModel cashinModel) async {
    int result = await db.insert('cashIn', cashinModel.toMap());

    return result;
  }

  Future<int> insertCashIndtl(CashInDtl cashinModel) async {
    int result = await db.insert('cashInDtl', cashinModel.toMap());

    return result;
  }

  Future<int> insertSerials(SerialsModel serialsModel) async {
    int result = await db.insert('serials', serialsModel.toMap());

    return result;
  }

  Future<void> deleteCustomers() async {
    await db.delete(
      'Customers',
      where: "1 = 1",
      //whereArgs: [id],
    );
  }

  Future<void> deleteitems() async {
    await db.delete(
      'items',
      where: "1 = 1",
      //whereArgs: [id],
    );
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

  Future<List<SalesHeadModel>> retrieveUsers() async {
    final List<Map<String, Object?>> queryResult =
        await db.rawQuery('select * from salesInvoiceDtl');
    print(queryResult);
    return queryResult.map((i) => SalesHeadModel.fromMap(i)).toList();
  }

  // Future<List<CashinModel>> retrieveUsers2() async {
  //   final List<Map<String, Object?>> queryResult =
  //       await db.rawQuery('select * from cashIn');
  //   print(queryResult);
  //   return queryResult.map((i) => CashinModel.fromMap(i)).toList();
  // }
}
