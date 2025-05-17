import 'package:flutter/material.dart';
import 'package:nilesoft_erp/layers/domain/models/city.dart';

class CitiesDropdown extends StatelessWidget {
  final List<CityModel>? citys;
  final CityModel? selectedCity;
  final ValueChanged<CityModel?> onCitySelected;
  final double width;
  final String lable;
  final Function(String) onSearch;

  const CitiesDropdown({
    super.key,
    required this.citys,
    required this.selectedCity,
    required this.onCitySelected,
    required this.width,
    required this.onSearch,
    required Null Function(dynamic value) onCustomerSelected,
    required this.lable,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await showSearch(
          context: context,
          delegate: CitySearchDelegate(
            citys: citys ?? [],
            onSearch: onSearch,
          ),
        );
        if (result != null) {
          onCitySelected(result);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: lable,
          labelStyle: const TextStyle(fontFamily: 'Almarai'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
        ),
        child: Text(
          selectedCity?.name ?? lable,
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}

class CitySearchDelegate extends SearchDelegate<CityModel?> {
  final List<CityModel> citys;
  final Function(String) onSearch;

  CitySearchDelegate({
    required this.citys,
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
    final filteredCitys = citys
        .where((city) => city.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredCitys.length,
      itemBuilder: (context, index) {
        final CityModel city = filteredCitys[index];
        return Container(
          color: Colors.white,
          child: ListTile(
            title: Text(city.name),
            onTap: () {
              close(context, city);
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
