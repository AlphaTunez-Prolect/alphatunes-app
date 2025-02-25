import 'package:flutter/cupertino.dart';

class Logo extends StatelessWidget {
  final String assetPath;
  final double width;
  final double height;

  const Logo({
    Key? key,
    required this.assetPath,
    this.width = 200,
    this.height = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
    );
  }
}