import 'package:flutter/material.dart';
import 'package:nilesoft_erp/layers/domain/models/customers_model.dart';

class SearchableDropdown extends StatelessWidget {
  final List<CustomersModel>? customers;
  final CustomersModel? selectedCustomer;
  final ValueChanged<CustomersModel?> onCustomerSelected;
  final double width;
  final Function(String) onSearch;

  const SearchableDropdown({
    super.key,
    required this.customers,
    required this.selectedCustomer,
    required this.onCustomerSelected,
    required this.width,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await showSearch(
          context: context,
          delegate: CustomerSearchDelegate(
            customers: customers ?? [],
            onSearch: onSearch,
          ),
        );
        if (result != null) {
          onCustomerSelected(result);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "اختر العميل",
          labelStyle: const TextStyle(fontFamily: 'Almarai'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
        ),
        child: Text(
          selectedCustomer?.name ?? "اختر العميل",
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}

class CustomerSearchDelegate extends SearchDelegate<CustomersModel?> {
  final List<CustomersModel> customers;
  final Function(String) onSearch;

  CustomerSearchDelegate({
    required this.customers,
    required this.onSearch,
  });

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          onSearch(query);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredCustomers = customers
        .where((customer) =>
            customer.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredCustomers.length,
      itemBuilder: (context, index) {
        final customer = filteredCustomers[index];
        return Container(
          color: Colors.white,
          child: ListTile(
            title: Text(customer.name!),
            onTap: () {
              close(context, customer);
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
