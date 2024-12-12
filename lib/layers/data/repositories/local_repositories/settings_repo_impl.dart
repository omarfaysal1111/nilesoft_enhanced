import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/settings_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/local/settings_repo.dart';

DatabaseHelper _databaseHelper = DatabaseHelper();

class SettingsRepoImpl implements SettingsRepo {
  @override
  Future<void> addSettings(
      {required SettingsModel setting, required String tableName}) async {
    await DatabaseConstants.startDB(_databaseHelper);

    await _databaseHelper.insertRecord(setting, tableName);
  }

  @override
  Future<void> deleteSettings() async {
    await DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.deleteSettings();
  }

  @override
  Future<List<SettingsModel>> getSettings({required String tableName}) async {
    await DatabaseConstants.startDB(_databaseHelper);
    List<SettingsModel> settingsModel =
        await _databaseHelper.getAllRecords(tableName, SettingsModel.fromMap);
    return settingsModel;
  }
}
