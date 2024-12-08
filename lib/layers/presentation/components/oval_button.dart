import 'package:flutter/material.dart';

class OvalButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const OvalButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF39B3BD), // Match the background color
        foregroundColor: Colors.white, // Text color
        elevation: 3, // Shadow depth
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded edges
        ),
        padding: const EdgeInsets.symmetric(
            horizontal: 30, vertical: 15), // Adjust padding
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              blurRadius: 2,
              color: Colors.black38, // Subtle shadow for text
              offset: Offset(1, 1),
            ),
          ],
        ),
      ),
    );
  }
}
