import 'package:flutter/material.dart';
import 'package:mon_petit_carnet/utils/responsive_utils.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? maxWidth;
  final EdgeInsets? padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? 1200,
        ),
        padding: padding ?? ResponsiveUtils.getScreenPadding(context),
        child: child,
      ),
    );
  }
}