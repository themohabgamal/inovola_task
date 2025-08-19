import 'package:flutter/material.dart';

class AppToasts {
  static void showSuccess(BuildContext context, String message) {
    _showToast(context, message, Colors.green);
  }

  static void showError(BuildContext context, String message) {
    _showToast(context, message, Colors.red);
  }

  static void showInfo(BuildContext context, String message) {
    _showToast(context, message, Colors.blueGrey);
  }

  static void _showToast(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
