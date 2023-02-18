// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textInput;
  final TextInputType keyboardinput;
  final bool obscure;
  final String hintText;
  const TextFieldInput(
      {required this.textInput,
      required this.keyboardinput,
      this.obscure = false,
      required this.hintText,
      super.key});

  @override
  Widget build(BuildContext context) {
    final normalBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(width: 1, color: Colors.grey.shade800));
    final focusBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          width: 2,
        ));
    return TextField(
      controller: textInput,
      decoration: InputDecoration(
          hintText: hintText,
          focusedBorder: focusBorder,
          border: normalBorder,
          filled: true,
          contentPadding: const EdgeInsets.all(8)),
      keyboardType: keyboardinput,
      obscureText: obscure,
    );
  }
}
