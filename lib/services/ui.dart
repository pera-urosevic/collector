import 'package:flutter/material.dart';

displayMessage(BuildContext context, String message, {int duration = 2}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      duration: Duration(seconds: duration),
      showCloseIcon: true,
    ),
  );
}
