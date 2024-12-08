import 'package:nilesoft_erp/layers/data/models/order_head_model.dart';
import 'package:nilesoft_erp/layers/domain/repository/order_repo.dart';

class OrdersRepoImpl implements OrderHeadRepo {
  @override
  Future<void> createOrderHead(
      {required OrderHeadModel invoice, required String tableName}) {
    //
    throw UnimplementedError();
  }

  @override
  Future<void> deleteOrderHead({required int id}) {
    //
    throw UnimplementedError();
  }

  @override
  Future<void> editOrder(
      {required OrderHeadModel invoice, required String tableName}) {
    //
    throw UnimplementedError();
  }

  @override
  Future<OrderHeadModel> getOrderHeadById(
      {required int id, required String tableName}) {
    //
    throw UnimplementedError();
  }

  @override
  Future<List<OrderHeadModel>> getOrdersHead({required String tableName}) {
    //
    throw UnimplementedError();
  }
}
