import 'package:equatable/equatable.dart';
import 'package:nilesoft_erp/layers/data/models/customers_model.dart';
import 'package:nilesoft_erp/layers/data/models/items_model.dart';

class HomeState extends Equatable {
  final List<ItemsModel> items;
  final List<CustomersModel> customers;
  final bool isUpdateSubmitted;
  final bool isUpdateLoading;
  final bool isUpdateSucc;
  final bool isSendingSubmitted;
  final bool isSendingLoading;
  final bool isSendingSucc;

  const HomeState({
    required this.items,
    required this.isUpdateSubmitted,
    required this.isUpdateLoading,
    required this.customers,
    required this.isUpdateSucc,
    required this.isSendingSubmitted,
    required this.isSendingLoading,
    required this.isSendingSucc,
  });

  factory HomeState.initial() {
    return const HomeState(
      items: [],
      isUpdateSubmitted: false,
      isUpdateLoading: false,
      customers: [],
      isUpdateSucc: false,
      isSendingSubmitted: false,
      isSendingLoading: false,
      isSendingSucc: false,
    );
  }

  HomeState copyWith({
    List<ItemsModel>? items,
    bool? isUpdateSubmitted,
    bool? isUpdateLoading,
    bool? isUpdateSucc,
    bool? isSendingSubmitted,
    bool? isSendingLoading,
    bool? isSendingSucc,
    List<CustomersModel>? customers,
  }) {
    return HomeState(
      items: items ?? this.items,
      isUpdateSubmitted: isUpdateSubmitted ?? this.isUpdateSubmitted,
      isUpdateLoading: isUpdateLoading ?? this.isUpdateLoading,
      isUpdateSucc: isUpdateSucc ?? this.isUpdateSucc,
      customers: customers ?? this.customers,
      isSendingSubmitted: isSendingSubmitted ?? this.isSendingSubmitted,
      isSendingLoading: isSendingLoading ?? this.isSendingLoading,
      isSendingSucc: isSendingSucc ?? this.isSendingSucc,
    );
  }

  @override
  List<Object?> get props => [
        items,
        isUpdateSubmitted,
        isUpdateLoading,
        isUpdateSucc,
        isSendingSubmitted,
        isSendingLoading,
        customers,
        isSendingSucc,
      ];
}
