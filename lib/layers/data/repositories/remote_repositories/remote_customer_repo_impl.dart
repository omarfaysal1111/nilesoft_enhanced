import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';
import 'package:nilesoft_erp/layers/data/remote/data_sources.dart';
import 'package:nilesoft_erp/layers/domain/repository/remote/remote_customers_repo.dart';

class RemoteCustomerRepoImpl implements RemoteCustomersRepo {
  @override
  Future<List<CustomersModel>> getAllCustomers() async {
    return await MainFun.getReq(CustomersModel.fromMap, "nsbase/getaccounts");
  }
}
