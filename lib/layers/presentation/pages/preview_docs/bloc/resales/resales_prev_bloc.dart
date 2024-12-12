import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/data/models/invoice_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/invoice_repo_impl.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/resales/resales_prev_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/resales/resales_prev_state.dart';

class RePreviewBloc extends Bloc<RePreviewEvent, RePreviewState> {
  RePreviewBloc() : super(ReDocPreviewInitial()) {
    on<ReOnPreviewInitial>(_onPreviewInitial);
  }
  Future<void> _onPreviewInitial(
      ReOnPreviewInitial event, Emitter<RePreviewState> emit) async {
    InvoiceRepoImpl invoiceRepoImpl = InvoiceRepoImpl();
    List<SalesHeadModel> invoicesHead = await invoiceRepoImpl.getInvoicesHead(
        tableName: DatabaseConstants.reSaleInvoiceHeadTable);
    emit(ReDocPreviewLoaded(salesModel: invoicesHead));
  }
}
