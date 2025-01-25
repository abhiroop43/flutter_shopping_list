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
        Text(message),
      ],
    ),
    behavior: SnackBarBehavior.floating,
    // margin: EdgeInsetsDirectional.only(bottom: 8.0),
  );
}
