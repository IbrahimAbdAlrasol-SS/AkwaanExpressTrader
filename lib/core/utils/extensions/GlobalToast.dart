import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class GlobalToast {
  static void show({
    required String message,
    required BuildContext context,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color? backgroundColor,
    Color? textColor,
    double fontSize = 16.0,
    int durationInSeconds = 2,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      backgroundColor:
          backgroundColor ?? Theme.of(context).colorScheme.inverseSurface,
      textColor: textColor ?? Theme.of(context).colorScheme.onInverseSurface,
      fontSize: fontSize,
      timeInSecForIosWeb: durationInSeconds,
    );
  }

  static void showSuccess({
    required String message,
    required BuildContext context,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color? backgroundColor,
    Color? textColor,
    double fontSize = 16.0,
    int durationInSeconds = 2,
  }) {
    show(
      message: message,
      context: context,
      gravity: gravity,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      textColor: textColor ?? Theme.of(context).colorScheme.onPrimary,
      fontSize: fontSize,
      durationInSeconds: durationInSeconds,
    );
  }
}
