import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isFormValid;
  final Widget text;

  SubmitButton({
    required this.onPressed,
    required this.isFormValid,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isFormValid ? onPressed : null,
      child: text,
    );
  }
}
