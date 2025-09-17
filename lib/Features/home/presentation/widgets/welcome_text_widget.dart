import 'package:flutter/material.dart';
import 'package:Tosell/core/model_core/User.dart';
import 'package:gap/gap.dart';

class WelcomeTextWidget extends StatelessWidget {
  final User user;

  const WelcomeTextWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مرحبا بك 👋',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
        ),
        const Gap(2),
        Text(
          user.fullName ?? user.userName ?? 'المستخدم',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                //fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
      ],
    );
  }
}