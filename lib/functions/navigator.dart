import 'package:flutter/material.dart';

void navigatorPop(BuildContext context) {
  if (Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}
