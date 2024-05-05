import 'package:admin/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWrapper extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final double height;
  final Color color;

  LoadingWrapper({
    required this.child,
    required this.isLoading,
    required this.height,
    this.color = themeColor,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
      height: height,
      child: SpinKitWave(
        color: color,
        size: 30,
      ),
    )
    : Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: child,
    );
  }
}
