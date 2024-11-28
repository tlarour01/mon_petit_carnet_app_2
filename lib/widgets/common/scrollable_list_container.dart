import 'package:flutter/material.dart';

class ScrollableListContainer extends StatelessWidget {
  final Widget child;

  const ScrollableListContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // The actual refresh is handled by the StreamBuilder/FutureBuilder
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: child,
    );
  }
}