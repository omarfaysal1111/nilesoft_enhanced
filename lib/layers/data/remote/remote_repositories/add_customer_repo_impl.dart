import 'package:nilesoft_erp/layers/data/models/add_customer.dart';
import 'package:nilesoft_erp/layers/data/remote/data_sources.dart';
import 'package:nilesoft_erp/layers/domain/repository/remote/add_customer_repo.dart';

class AddCustomerRepoImpl extends AddCustomerRepo {
  @override
  Future<void> addCustomer({required AddCustomerModel customer}) async {
    await MainFun.postReq(
        AddCustomerModel.fromMap, "fastcustomers/addnew", customer.toMap());
  }
}
