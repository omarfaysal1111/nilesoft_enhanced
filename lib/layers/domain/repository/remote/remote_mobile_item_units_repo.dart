import 'package:nilesoft_erp/layers/domain/models/mobile_item_units_model.dart';

abstract class RemoteMobileItemUnitsRepo {
  Future<List<MobileItemUnitsModel>> getAllMobileItemUnits();
}


