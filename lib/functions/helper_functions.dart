import 'package:flutter/cupertino.dart';
import 'package:greentrition/constants/colors.dart';

Color textColorFromHex(Color col){
  String hexcolor = col.value.toRadixString(16);
  hexcolor = hexcolor.substring(2);
  // Convert to RGB value
  int r = int.parse(hexcolor.substring(0, 2), radix: 16);
  int g = int.parse(hexcolor.substring(2, 4), radix: 16);
  int b = int.parse(hexcolor.substring(4, 6), radix: 16);

  // Get YIQ ratio
  double yiq = ((r * 299) + (g * 587) + (b * 114)) / 1000;

  // Check contrast
  return (yiq >= 128) ? colorTextDark : colorTextBright;
}