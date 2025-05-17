import 'package:nilesoft_erp/layers/domain/models/add_customer.dart';
import 'package:nilesoft_erp/layers/data/remote/data_sources.dart';
import 'package:nilesoft_erp/layers/domain/models/baisc_response.dart';
import 'package:nilesoft_erp/layers/domain/repository/remote/add_customer_repo.dart';

class AddCustomerRepoImpl extends AddCustomerRepo {
  @override
  Future<ResponseModel> addCustomer(
      {required AddCustomerModel customer}) async {
    return await MainFun.postReq(
        ResponseModel.fromJson, "fastcustomers/addnew", customer.toMap());
  }
}
