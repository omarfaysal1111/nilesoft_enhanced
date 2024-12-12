import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/local/database_constants.dart';
import 'package:nilesoft_erp/layers/domain/models/cashin_model.dart';
import 'package:nilesoft_erp/layers/data/repositories/local_repositories/cashin_repo_impl.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/cashin/cashin_prev_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/preview_docs/bloc/cashin/cashin_prev_state.dart';

class CashinPrevBloc extends Bloc<CashinPrevEvent, CashinPrevState> {
  CashinPrevBloc() : super(CashinPrevInit()) {
    on<OnCashInPreview>(_onCashInPrev);
  }
  Future<void> _onCashInPrev(
      OnCashInPreview event, Emitter<CashinPrevState> emit) async {
    emit(CashInPrevLoading());
    CashinRepoImpl cashinRepoImpl = CashinRepoImpl();
    List<CashinModel> cashinModel = await cashinRepoImpl.getCashIns(
        tableName: DatabaseConstants.cashinHeadTable);
    emit(CashInPrevLoaded(cashinModel: cashinModel));
  }
}
