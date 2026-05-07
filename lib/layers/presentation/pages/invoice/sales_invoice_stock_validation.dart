import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/items_repo_impl.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/settings_repo_impl.dart';
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/domain/models/items_model.dart';
import 'package:nilesoft_erp/layers/domain/models/settings_model.dart';

Future<bool> salesInvoiceRestrictsToInStock() async {
  final SettingsRepoImpl settingsRepo = SettingsRepoImpl();
  final List<SettingsModel> settings = await settingsRepo.getSettings(
      tableName: DatabaseConstants.settingsTable);
  if (settings.isEmpty) return false;
  return settings.first.inStock == 1;
}

/// When [restrictToInStock] is true, ensures line quantities do not exceed stock.
///
/// [SalesDtlModel.factor] is the same multiplier used for pricing (base unit × factor).
/// Required and available amounts are both converted to that base so different UOM lines
/// compare correctly to [ItemsModel.qty] × [ItemsModel.factor] from inventory.
Future<String?> validateSalesInvoiceLinesAgainstStock({
  required List<SalesDtlModel> lines,
  required bool restrictToInStock,
}) async {
  if (!restrictToInStock || lines.isEmpty) return null;

  final Map<String, double> baseQtyByItem = {};
  for (final SalesDtlModel line in lines) {
    final String? id = line.itemId;
    if (id == null || id.isEmpty) continue;
    final double lineBase =
        (line.qty ?? 0) * (line.factor ?? 1.0);
    baseQtyByItem[id] = (baseQtyByItem[id] ?? 0) + lineBase;
  }

  final ItemsRepoImpl itemsRepo = ItemsRepoImpl();
  final List<ItemsModel> allItems = await itemsRepo.getItems(
    tableName: DatabaseConstants.itemsTable,
    onlyWithPositiveQty: false,
  );
  final Map<String, ItemsModel> byId = {
    for (final ItemsModel i in allItems)
      if (i.itemid != null) i.itemid!: i,
  };

  for (final MapEntry<String, double> e in baseQtyByItem.entries) {
    final ItemsModel? item = byId[e.key];
    if (item == null) continue;
    final double availableBase =
        (item.qty ?? 0) * (item.factor ?? 1.0);
    if (e.value > availableBase) {
      return 'الرصيد غير كافٍ للصنف "${item.name ?? e.key}" (المطلوب ${e.value.toStringAsFixed(2)} — المتاح ${availableBase.toStringAsFixed(2)})';
    }
  }
  return null;
}
