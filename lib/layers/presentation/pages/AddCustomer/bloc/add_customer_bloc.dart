import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nilesoft_erp/layers/data/remote/remote_repositories/add_customer_repo_impl.dart';
import 'package:nilesoft_erp/layers/presentation/pages/AddCustomer/bloc/add_customer_event.dart';
import 'package:nilesoft_erp/layers/presentation/pages/AddCustomer/bloc/add_customer_state.dart';

class AddCustomerBloc extends Bloc<AddCustomerEvent, AddCustomerState> {
  AddCustomerBloc() : super(AddCustomerInit()) {
    // Register the handler for OnAddCustomerInit
    on<OnAddCustomerInit>(_onAddCustomerInit);

    // Register the handler for OnAddCustomer
    on<OnAddCustomer>(_onAddCustomer);
  }

  // Handler for the OnAddCustomerInit event
  void _onAddCustomerInit(
      OnAddCustomerInit event, Emitter<AddCustomerState> emit) {
    // Perform initialization logic if needed, or keep it simple
    emit(AddCustomerInit());
  }

  // Handler for the OnAddCustomer event
  Future<void> _onAddCustomer(
      OnAddCustomer event, Emitter<AddCustomerState> emit) async {
    try {
      AddCustomerRepoImpl addCustomerRepoImpl = AddCustomerRepoImpl();
      await addCustomerRepoImpl.addCustomer(customer: event.customerModel);
      emit(AddCustomerSucc());
    } catch (e) {
      // Emit an error state if something goes wrong
    }
  }
}
