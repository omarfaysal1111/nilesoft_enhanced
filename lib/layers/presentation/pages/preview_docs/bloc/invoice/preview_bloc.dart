import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/invoice_repo_impl.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/invoice/preview_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/invoice/preview_state.dart';

class PreviewBloc extends Bloc<PreviewEvent, PreviewState> {
  PreviewBloc() : super(DocPreviewInitial()) {
    on<OnPreviewInitial>(_onPreviewInitial);
    on<OnPreviewSent>(_onPreviewSentInitial);
    on<OnPreviewUnsent>(_onPreviewUnsentInitial);
    on<OnInvoiceDelete>(_onDeleteInvoice);
  }
  Future<void> _onDeleteInvoice(
      OnInvoiceDelete event, Emitter<PreviewState> emit) async {
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    await invoiceRepoImpl.deleteInvoice(
        id: event.id, tableName: DatabaseConstants.salesInvoiceHeadTable);

    await invoiceRepoImpl.deleteInvoice(
        id: event.id, tableName: DatabaseConstants.salesInvoiceDtlTable);
    emit(OnInvoiceDeleted(id: event.id));
  }

  Future<void> _onPreviewInitial(
      OnPreviewInitial event, Emitter<PreviewState> emit) async {
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    List<SalesHeadModel> invoicesHead = await invoiceRepoImpl.getInvoicesHead(
        tableName: DatabaseConstants.salesInvoiceHeadTable);
    emit(DocPreviewLoaded(salesModel: invoicesHead));
  }

  Future<void> _onPreviewSentInitial(
      OnPreviewSent event, Emitter<PreviewState> emit) async {
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    List<SalesHeadModel> invoicesHead = await invoiceRepoImpl.getSentInvoices(
        tableName: DatabaseConstants.salesInvoiceHeadTable);
    emit(DocPreviewLoaded(salesModel: invoicesHead));
  }

  Future<void> _onPreviewUnsentInitial(
      OnPreviewUnsent event, Emitter<PreviewState> emit) async {
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    List<SalesHeadModel> invoicesHead = await invoiceRepoImpl.getUnsentInvoices(
        tableName: DatabaseConstants.salesInvoiceHeadTable);
    emit(DocPreviewLoaded(salesModel: invoicesHead));
  }
}
