import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

import 'package:greentrition/constants/colors.dart';

/*const TextStyle headingFont = TextStyle(
    fontSize: 30,
    fontFamily: "Recoleta",
    color: colorTextDark
);*/

TextStyle headingFont =
    GoogleFonts.quicksand(fontSize: 30, fontWeight: FontWeight.w700, shadows: [
  BoxShadow(
      spreadRadius: 0.1,
      color: colorShadowBlack,
      blurRadius: 3,
      offset: Offset(1, 1))
]);

//davor:  oldbarlowSemiCondensed(
TextStyle titleFont = GoogleFonts.sourceSansPro(
    fontSize: 30.0, fontWeight: FontWeight.bold, color: colorTextDark);

TextStyle searchbarStyle = GoogleFonts.sourceSansPro(
    fontSize: 18, color: Colors.black, letterSpacing: 0.7);

TextStyle tabBarStyle = GoogleFonts.quicksand(
    fontSize: 20, fontWeight: FontWeight.w900, color: colorTextDark);

TextStyle standardStyle = GoogleFonts.quicksand(fontWeight: FontWeight.w600);

TextStyle openSans = GoogleFonts.openSans(fontSize: 19);
