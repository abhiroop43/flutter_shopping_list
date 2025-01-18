import 'package:flutter/material.dart';

SnackBar showErrorSnackBar(String message) {
  return SnackBar(
    content: Row(
      children: [
        Icon(
          Icons.error,
          color: Colors.red,
        ),
        SizedBox(width: 8),
        Text('$message Please try again later.'),
      ],
    ),
    behavior: SnackBarBehavior.floating,
  );
}
