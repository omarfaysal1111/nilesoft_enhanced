import 'package:nilesoft_erp/layers/domain/models/serials_model.dart';

abstract class SerialsRepo {
  Future<void> saveSerial({required SerialsModel serial});
  Future<List<SerialsModel>> getAllSerials();
}
