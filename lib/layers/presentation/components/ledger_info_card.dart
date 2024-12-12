import 'package:flutter/material.dart';

class LedgerInfoCard extends StatelessWidget {
  final String date;
  final String docNumber;
  final String description;
  final String debit;
  final String credit;
  final String balance;

  const LedgerInfoCard({
    super.key,
    required this.date,
    required this.docNumber,
    required this.description,
    required this.debit,
    required this.credit,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[100], // Light background color
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildRow(label: "التاريخ", value: date),
          const SizedBox(height: 8.0),
          _buildRow(label: "رقم المستند", value: docNumber),
          const SizedBox(height: 8.0),
          _buildRow(label: "البيان", value: description),
          const SizedBox(height: 8.0),
          _buildRow(label: "مدين", value: debit),
          const SizedBox(height: 8.0),
          _buildRow(label: "دائن", value: credit),
          const SizedBox(height: 8.0),
          _buildRow(label: "الرصيد", value: balance),
        ],
      ),
    );
  }

  Widget _buildRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Almarai', // Use your desired font
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Almarai', // Use your desired font
            fontSize: 14.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
