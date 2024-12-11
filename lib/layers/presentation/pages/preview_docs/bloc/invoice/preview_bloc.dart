import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/invoice_repo_impl.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/invoice/preview_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/invoice/preview_state.dart';

class PreviewBloc extends Bloc<PreviewEvent, PreviewState> {
  PreviewBloc() : super(DocPreviewInitial()) {
    on<OnPreviewInitial>(_onPreviewInitial);
  }
  Future<void> _onPreviewInitial(
      OnPreviewInitial event, Emitter<PreviewState> emit) async {
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    List<SalesHeadModel> invoicesHead = await invoiceRepoImpl.getInvoicesHead(
        tableName: DatabaseConstants.salesInvoiceHeadTable);
    emit(DocPreviewLoaded(salesModel: invoicesHead));
  }
}
