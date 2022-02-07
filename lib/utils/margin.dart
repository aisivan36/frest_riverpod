import 'package:flutter/material.dart';

class XMargin extends StatelessWidget {
  final double? x;
  const XMargin({Key? key, this.x}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: x);
  }
}

class YMargin extends StatelessWidget {
  final double? y;
  const YMargin({Key? key, this.y}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: y);
  }
}

extension CustomContext on BuildContext {
  double screenHeight([double percent = 1]) =>
      MediaQuery.of(this).size.height * percent;

  double screenWidth([double percent = 1]) =>
      MediaQuery.of(this).size.width * percent;
}
