import 'package:nilesoft_erp/layers/data/local/data_source_local.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/models/settings_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/settings_repo.dart';

DatabaseHelper _databaseHelper = DatabaseHelper();

class SettingsRepoImpl implements SettingsRepo {
  @override
  Future<void> addSettings(
      {required SettingsModel setting, required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);

    await _databaseHelper.insertRecord(setting, tableName);
  }

  @override
  Future<void> deleteSettings() async {
    DatabaseConstants.startDB(_databaseHelper);
    await _databaseHelper.deleteSettings();
  }

  @override
  Future<SettingsModel> getSettings({required String tableName}) async {
    DatabaseConstants.startDB(_databaseHelper);
    SettingsModel? settingsModel = await _databaseHelper.getRecordById(
        tableName, 1, SettingsModel.fromMap);
    return settingsModel!;
  }
}
