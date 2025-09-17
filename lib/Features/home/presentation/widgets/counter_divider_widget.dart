import 'package:flutter/material.dart';

class CounterDividerWidget extends StatelessWidget {
  const CounterDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
    );
  }
}