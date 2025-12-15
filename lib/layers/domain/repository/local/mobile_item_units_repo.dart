import 'package:nilesoft_erp/layers/domain/models/mobile_item_units_model.dart';

abstract class MobileItemUnitsRepo {
  Future<List<MobileItemUnitsModel>> getMobileItemUnits({required String tableName});
  Future<List<MobileItemUnitsModel>> getMobileItemUnitsByItemId({required String itemId, required String tableName});
  Future<void> createMobileItemUnit(
      {required MobileItemUnitsModel item, required String tableName});
  Future<void> addAllMobileItemUnits(
      {required List<MobileItemUnitsModel> items, required String tableName});
  Future<void> deleteAllMobileItemUnits({required String tableName});
}

