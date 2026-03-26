import 'package:flutter/material.dart';

class SnackbarUtils {

  static void show(
    BuildContext context, 
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.fixed,
      ),
    );
  }
}