import 'package:flutter/material.dart';

class FuntionHelper {
  static void showSnackbar(BuildContext context, String text) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
    ));
  }
}
