import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title; // Title at the top
  final String price; // Price value
  final String discount; // Discount value
  final String quantity; // Quantity value
  final String tax; // Tax value
  final String total; // Total value
  final VoidCallback onDelete; // Action for delete icon
  final VoidCallback onEdit; // Action for edit icon

  const InfoCard({
    super.key,
    required this.title,
    required this.price,
    required this.discount,
    required this.quantity,
    required this.tax,
    required this.total,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xffF3F3F3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 20,
                      child: IconButton(
                        onPressed: onDelete,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      child: IconButton(
                        onPressed: onEdit,
                        icon: const Icon(
                          Icons.edit,
                          color: Color(0xff39B3BD),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 90,
                    ),
                  ],
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * .3,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * .9,
              child: const Divider(
                color: Color.fromARGB(255, 225, 223, 223),
              ),
            ),
            const SizedBox(height: 10),

            // Info Rows
            _buildInfoRow("السعر", price),
            _buildInfoRow("الخصم", discount),
            _buildInfoRow("الكمية", quantity),
            _buildInfoRow("الضريبة", tax),
            _buildInfoRow("اجمالي", total),

            const SizedBox(height: 10),

            // Action Buttons
          ],
        ),
      ),
    );
  }

  // Helper method to build each info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.left,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
