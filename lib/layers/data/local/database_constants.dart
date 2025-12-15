import 'package:flutter/foundation.dart';
import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';

class DatabaseConstants {
  static const String salesInvoiceHeadTable = "salesInvoiceHead";
  static const String salesInvoiceDtlTable = "salesInvoiceDtl";
  static const String purchaseInvoiceHeadTable = "purInvoiceHead";
  static const String purchaseInvoiceDtlTable = "purInvoiceDtl";
  static const String reSaleInvoiceHeadTable = "ResalesInvoiceHead";
  static const String reSaleInvoiceDtlTable = "ResalesInvoiceDtl";
  static const String itemSerials = "itemsserials";
  static const String orderHeadTable = "orderHead";
  static const String orderDtlTable = "orderDtl";
  static const String cashinHeadTable = "cashIn";
  static const String cashInDtlTable = "cashInDtl";
  static const String serialsDtlTable = "serials";
  static const String customersTable = "Customers";
  static const String settingsTable = "settings";
  static const String itemsTable = "items";
  static const String mobileItemUnitsTable = "mobileItemUnits";
  static Future<void> startDB(DatabaseHelper databaseHelper) async {
    await databaseHelper.initDB().whenComplete(
      () {
        if (kDebugMode) {
          print("Started");
        }
      },
    );
  }
}
