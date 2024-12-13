import 'package:flutter/material.dart';
import 'package:nilesoft_erp/layers/domain/models/items_model.dart';

class SearchableItemDropdown extends StatelessWidget {
  final List<ItemsModel>? items;
  final ItemsModel? selecteditem;
  final ValueChanged<ItemsModel?> onItemSelected;
  final double width;
  final Function(String) onSearch;

  const SearchableItemDropdown({
    super.key,
    required this.items,
    required this.selecteditem,
    required this.onItemSelected,
    required this.width,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await showSearch(
          context: context,
          delegate: ItemSearchDelegate(
            items: items ?? [],
            onSearch: onSearch,
          ),
        );
        if (result != null) {
          onItemSelected(result);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "اختر الصنف",
          labelStyle: const TextStyle(fontFamily: 'Almarai'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
        ),
        child: Text(
          selecteditem?.name ?? "اختر الصنف",
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}

class ItemSearchDelegate extends SearchDelegate<ItemsModel?> {
  final List<ItemsModel> items;
  final Function(String) onSearch;

  ItemSearchDelegate({
    required this.items,
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
    final filteredItems = items
        .where((customer) =>
            customer.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return Container(
          color: Colors.white,
          child: ListTile(
            title: Text(item.name!),
            onTap: () {
              close(context, item);
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
