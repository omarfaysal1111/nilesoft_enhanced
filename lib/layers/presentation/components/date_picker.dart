import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final String label; // e.g., "من"
  final DateTime? selectedDate;
  final void Function(DateTime) onDateSelected;

  const DatePickerField({
    super.key,
    required this.label,
    required this.onDateSelected,
    this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.calendar_today,
              color: Colors.grey[700],
            ),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Almarai', // Use the desired font
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
