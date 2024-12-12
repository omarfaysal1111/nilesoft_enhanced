import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/serials_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/local/serials_repo.dart';

class SerialsRepoImpl extends SerialsRepo {
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Future<List<SerialsModel>> getAllSerials() async {
    DatabaseConstants.startDB(databaseHelper);
    List<SerialsModel> serials = await databaseHelper.getAllRecords(
        DatabaseConstants.serialsDtlTable, SerialsModel.fromMap);
    return serials;
  }

  @override
  Future<void> saveSerial({required SerialsModel serial}) async {
    DatabaseConstants.startDB(databaseHelper);
    await databaseHelper.insertRecord<SerialsModel>(
        serial, DatabaseConstants.serialsDtlTable);
  }
}
