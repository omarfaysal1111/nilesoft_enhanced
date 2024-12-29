import 'package:flutter/material.dart';
import 'package:nilesoft_erp/layers/presentation/components/custom_textfield.dart';

class SummaryCard extends StatelessWidget {
  final String total; // Total value
  final String discount; // Discount value
  final String tax; // Tax value
  final String net; // Net value
  final TextEditingController disamController;
  final TextEditingController disratController;
  final ValueChanged<String> amChanged;
  final ValueChanged<String> ratChanged;
  const SummaryCard({
    super.key,
    required this.total,
    required this.discount,
    required this.tax,
    required this.net,
    required this.disamController,
    required this.disratController,
    required this.amChanged,
    required this.ratChanged,
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
            _buildInfoRow("الاجمالي", total),
            _buildInfoRow("الخصم", discount),
            _buildInfoRow("الضريبة", tax),
            _buildInfoRowEditable("الخصم علي الفاتورة", ""),
            _buildInfoRow("الصافي", net),
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

  Widget _buildInfoRowEditable(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  width: 70,
                  height: 60,
                  child: CustomTextField(
                      controller: disratController,
                      hintText: "نسبة",
                      hintStyle: const TextStyle(fontSize: 8),
                      onChanged: ratChanged)),
              SizedBox(
                  width: 70,
                  height: 60,
                  child: CustomTextField(
                    controller: disamController,
                    hintText: "قيمة",
                    hintStyle: const TextStyle(fontSize: 8),
                    onChanged: amChanged,
                  )),
            ],
          ),
          SizedBox(
            height: 60,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Almarai',
                color: Colors.white, // Text color
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
