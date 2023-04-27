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

Future<String?> dialogString(BuildContext context, String title, String hint, bool Function(String value) valid) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: hint),
          onSubmitted: (value) {
            if (valid(value)) {
              Navigator.pop(context, value);
            }
          },
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      );
    },
  );
}
