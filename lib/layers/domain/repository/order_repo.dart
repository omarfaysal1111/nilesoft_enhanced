import 'package:nilesoft_erp/layers/data/models/order_head_model.dart';

abstract class OrderHeadRepo {
  Future<List<OrderHeadModel>> getOrdersHead({required String tableName});
  Future<OrderHeadModel> getOrderHeadById(
      {required int id, required String tableName});
  Future<void> createOrderHead(
      {required OrderHeadModel invoice, required String tableName});
  Future<void> editOrder(
      {required OrderHeadModel invoice, required String tableName});
  Future<void> deleteOrderHead({required int id});
}
