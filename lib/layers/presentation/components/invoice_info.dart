import 'package:flutter/material.dart';

class DocInfoCard extends StatelessWidget {
  final String customerName;
  final double dateValue;
  final double netValue;
  final VoidCallback onViewPressed;

  const DocInfoCard({
    super.key,
    required this.customerName,
    required this.dateValue,
    required this.netValue,
    required this.onViewPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      //padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "MOB12-00012",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  customerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Almarai',
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          // Details
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateValue.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "التاريخ",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Almarai',
                  ),
                ),
              ],
            ),
          ),
          //const SizedBox(height: 8.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  netValue.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "الصافي",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontFamily: 'Almarai',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),

          // Button
          Container(
            margin: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: onViewPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    "استعراض",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Almarai',
                      fontSize: 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
