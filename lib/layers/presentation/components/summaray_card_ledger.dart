import 'package:flutter/material.dart';

class SummaryLedgCard extends StatelessWidget {
  final String openbal; // Total value
  final String debit; // Discount value
  final String credit; // Tax value
  final String currentbal; // Net value

  const SummaryLedgCard({
    super.key,
    required this.openbal,
    required this.debit,
    required this.credit,
    required this.currentbal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //margin: const EdgeInsets.all(16.0),
      elevation: 0,
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xff39B3BD), // Background color similar to screenshot
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoRow("الرصيد الافتتاحي", openbal),
            _buildInfoRow("اجمالي المدين", debit),
            _buildInfoRow("اجمالي الدائن", credit),
            _buildInfoRow("الرصيد الحالي", currentbal),
          ],
        ),
      ),
    );
  }

  // Helper method to build each info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white, // Text color
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Almarai',
              color: Colors.white, // Text color
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
