import 'dart:async';

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final ValueChanged<String> onChanged;
  final Duration debounceDuration;
  final bool? readonly;
  final TextStyle? hintStyle;
  final VoidCallback? onTap;
  const CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.readonly,
    this.debounceDuration = const Duration(milliseconds: 900),
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    required this.onChanged,
    this.onTap,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    Timer? debounce;
    void onTextChanged(String value) {
      if (debounce?.isActive ?? false) debounce!.cancel();

      debounce = Timer(debounceDuration, () {
        onChanged(value);
      });
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        readOnly: readonly ?? false,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textAlign: TextAlign.right,
        onChanged: onTextChanged,
        onTap: () {
          controller!.selection = TextSelection(
              baseOffset: 0, extentOffset: controller!.text.length);
        },
        decoration: InputDecoration(
          hintText: hintText,
          labelText: hintText,
          hintStyle: hintStyle,
          alignLabelWithHint: true,
          labelStyle: const TextStyle(
            color: Color(0xff434343),
            fontWeight: FontWeight.bold,
            fontFamily: 'Almarai',
            fontSize: 16,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
    );
  }
}
