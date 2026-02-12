import 'package:flutter/material.dart';
import 'package:nilesoft_erp/layers/domain/models/mobile_item_units_model.dart';

class UnitsDropdown extends StatelessWidget {
  final List<MobileItemUnitsModel>? units;
  final MobileItemUnitsModel? selectedUnit;
  final ValueChanged<MobileItemUnitsModel?> onUnitSelected;
  final double width;

  const UnitsDropdown({
    super.key,
    required this.units,
    required this.selectedUnit,
    required this.onUnitSelected,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (units == null || units!.isEmpty) {
      return const SizedBox.shrink();
    }

    // Find the selected unit in the list by comparing unitid
    // This ensures the value matches one of the items
    MobileItemUnitsModel? validSelectedUnit;
    if (selectedUnit != null && selectedUnit!.unitid != null) {
      validSelectedUnit = units!.firstWhere(
        (unit) => unit.unitid == selectedUnit!.unitid,
        orElse: () => units!.isNotEmpty ? units!.first : MobileItemUnitsModel(),
      );
      // If found unit is empty, set to null
      // ignore: unnecessary_null_comparison
      if (validSelectedUnit != null && validSelectedUnit.unitid == null) {
        validSelectedUnit = units!.isNotEmpty ? units!.first : null;
      }
    } else {
      // If no selected unit, default to first unit if available
      validSelectedUnit = units!.isNotEmpty ? units!.first : null;
    }

    return SizedBox(
      width: width,
      child: DropdownButtonFormField<MobileItemUnitsModel>(
        value: validSelectedUnit,
        decoration: InputDecoration(
          labelText: "اختر الوحدة",
          labelStyle: const TextStyle(fontFamily: 'Almarai'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
        ),
        items: units!.map((unit) {
          return DropdownMenuItem<MobileItemUnitsModel>(
            value: unit,
            child: Text(unit.unitname ?? ''),
          );
        }).toList(),
        onChanged: (value) {
          onUnitSelected(value);
        },
      ),
    );
  }
}
