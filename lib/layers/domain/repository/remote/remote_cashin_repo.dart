abstract class RemoteCashineRepo {
  Future<void> sendInvoices(
      {required String headTableName, required String endPoint});
}
