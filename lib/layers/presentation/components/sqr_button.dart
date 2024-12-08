import 'package:flutter/material.dart';

class SqrButton extends StatelessWidget {
  final String text;
  final String img;
  final double width;
  final double height;
  final VoidCallback onClick;
  const SqrButton(
      {super.key,
      required this.text,
      required this.img,
      required this.width,
      required this.height,
      required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xffF3F3F3)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(img),
            Text(
              text,
              style: const TextStyle(
                  fontFamily: 'Almarai', fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
