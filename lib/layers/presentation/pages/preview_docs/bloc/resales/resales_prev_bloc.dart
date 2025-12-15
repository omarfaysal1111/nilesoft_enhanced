import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/invoice_repo_impl.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/resales/resales_prev_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/resales/resales_prev_state.dart';

class RePreviewBloc extends Bloc<RePreviewEvent, RePreviewState> {
  RePreviewBloc() : super(ReDocPreviewInitial()) {
    on<ReOnPreviewInitial>(_onPreviewInitial);
    on<ReOnPreviewSent>(_onPreviewSentInitial);
    on<ReOnPreviewUnsent>(_onPreviewUnsentInitial);
    on<OnReInvoiceDelete>(_onReDeleteInvoice);
    on<ReOnShareDoc>(_onShare);
  }
  Future<void> _onPreviewInitial(
      ReOnPreviewInitial event, Emitter<RePreviewState> emit) async {
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    List<SalesHeadModel> invoicesHead = await invoiceRepoImpl.getInvoicesHead(
        tableName: DatabaseConstants.reSaleInvoiceHeadTable);
    emit(ReDocPreviewLoaded(salesModel: invoicesHead));
  }

  Future<void> _onPreviewSentInitial(
      ReOnPreviewSent event, Emitter<RePreviewState> emit) async {
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    List<SalesHeadModel> invoicesHead = await invoiceRepoImpl.getSentInvoices(
        tableName: DatabaseConstants.reSaleInvoiceHeadTable);
    emit(ReDocPreviewLoaded(salesModel: invoicesHead));
  }

  Future<void> _onPreviewUnsentInitial(
      ReOnPreviewUnsent event, Emitter<RePreviewState> emit) async {
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    List<SalesHeadModel> invoicesHead = await invoiceRepoImpl.getUnsentInvoices(
        tableName: DatabaseConstants.reSaleInvoiceHeadTable);
    emit(ReDocPreviewLoaded(salesModel: invoicesHead));
  }

  Future<void> _onReDeleteInvoice(
      OnReInvoiceDelete event, Emitter<RePreviewState> emit) async {
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    await invoiceRepoImpl.deleteInvoice(
        id: event.id, tableName: DatabaseConstants.reSaleInvoiceHeadTable);

    await invoiceRepoImpl.deleteInvoice(
        id: event.id, tableName: DatabaseConstants.reSaleInvoiceDtlTable);
    emit(OnReInvoiceDeleted(id: event.id));
  }

  Future<void> _onShare(
      ReOnShareDoc event, Emitter<RePreviewState> emit) async {
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    List<SalesDtlModel>? dtl = await invoiceRepoImpl.getSingleInvoiceDtl(
        tableName: DatabaseConstants.reSaleInvoiceDtlTable, id: event.id);

    emit(ReShareDoc(dtl: dtl));
  }
}
