import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/cashin_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/cashin_repo_impl.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/cashin/cashin_prev_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/cashin/cashin_prev_state.dart';

class CashinPrevBloc extends Bloc<CashinPrevEvent, CashinPrevState> {
  CashinPrevBloc() : super(CashinPrevInit()) {
    on<OnCashInPreview>(_onCashInPrev);
    on<OnCashinPreviewSent>(_onPreviewSentInitial);
    on<OnCashinPreviewUnsent>(_onPreviewUnsentInitial);
    on<OnCashinDelete>(_onDeleteInvoice);
  }
  Future<void> _onCashInPrev(
      OnCashInPreview event, Emitter<CashinPrevState> emit) async {
    emit(CashInPrevLoading());
    CashinRepoImpl cashinRepoImpl = CashinRepoImpl();
    List<CashinModel> cashinModel = await cashinRepoImpl.getCashIns(
        tableName: DatabaseConstants.cashinHeadTable);
    emit(CashInPrevLoaded(cashinModel: cashinModel));
  }

  Future<void> _onPreviewSentInitial(
      OnCashinPreviewSent event, Emitter<CashinPrevState> emit) async {
    CashinRepoImpl cashinRepoImpl = CashinRepoImpl();
    List<CashinModel> invoicesHead = await cashinRepoImpl.getSentInvoices(
        tableName: DatabaseConstants.cashinHeadTable);
    emit(CashInPrevLoaded(cashinModel: invoicesHead));
  }

  Future<void> _onPreviewUnsentInitial(
      OnCashinPreviewUnsent event, Emitter<CashinPrevState> emit) async {
    CashinRepoImpl cashinRepoImpl = CashinRepoImpl();
    List<CashinModel> invoicesHead = await cashinRepoImpl.getUnsentInvoices(
        tableName: DatabaseConstants.cashinHeadTable);
    emit(CashInPrevLoaded(cashinModel: invoicesHead));
  }

  Future<void> _onDeleteInvoice(
      OnCashinDelete event, Emitter<CashinPrevState> emit) async {
    CashinRepoImpl invoiceRepoImpl = CashinRepoImpl();
    await invoiceRepoImpl.deleteCashIn(id: event.id);

    emit(CashInDeleted());
  }
}
