import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final Color background;
  final VoidCallback onTap;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.background,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: background,
          minimumSize: const Size(90, 90),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 36),
        ),
      ),
    );
  }
}
