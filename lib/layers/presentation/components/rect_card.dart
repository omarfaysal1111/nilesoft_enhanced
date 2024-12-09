import 'package:flutter/material.dart';

class RectCard extends StatelessWidget {
  final String text;
  final String icon;
  final Color iconBackgroundColor;

  const RectCard({
    Key? key,
    required this.text,
    required this.icon,
    this.iconBackgroundColor = Colors.teal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              fontFamily: 'Almarai',
              color: Colors.black87,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(icon)),
        ],
      ),
    );
  }
}
