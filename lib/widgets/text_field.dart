import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput(
      {required this.textEditingController,
      required this.textInputType,
      required this.hintText,
      this.isPass = false,
      super.key});
  final String? hintText;
  final bool isPass;
  final TextInputType textInputType;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    final inputBorder =
        OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        border: inputBorder,
        focusedBorder: inputBorder,
        enabledBorder: inputBorder,
        filled: true,
      ),
      obscureText: isPass,
      keyboardType: textInputType,
    );
  }
}
