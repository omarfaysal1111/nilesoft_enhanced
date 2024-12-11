abstract class RemoteInvoiceRepo {
  Future<void> sendInvoices(
      {required String headTableName,
      required String dtlTableName,
      required String endPoint});
}
