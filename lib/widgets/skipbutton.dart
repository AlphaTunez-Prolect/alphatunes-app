import 'package:flutter/material.dart';

class SkipContinueButtons extends StatelessWidget {
  final VoidCallback onSkip;
  final VoidCallback onContinue;

  const SkipContinueButtons({
    super.key,
    required this.onSkip,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Skip Button
        ElevatedButton(
          onPressed: onSkip,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: const BorderSide(color: Colors.black),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
          child: const Text(
            "Skip",
            style: TextStyle(color: Colors.black, fontSize: 14),
          ),
        ),

        // Continue Button
        ElevatedButton(
          onPressed: onContinue,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
          ),
          child: const Text(
            "Continue",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
