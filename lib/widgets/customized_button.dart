import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText; // Text to display on the button
  final VoidCallback onPressed; // Callback when the button is pressed
  final double width; // Width of the button
  final double height; // Height of the button
  final Color backgroundColor; // Background color of the button
  final Color textColor; // Text color of the button
  final double borderRadius; // Border radius of the button

  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.width = 250, // Default width
    this.height = 63, // Default height
    this.backgroundColor = const Color(0xFFE40683), // Default background color
    this.textColor = Colors.white, // Default text color
    this.borderRadius = 20, // Default border radius
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 18,
            color: textColor,
          ),
        ),
      ),
    );
  }
}