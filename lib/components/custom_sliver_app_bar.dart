import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/functions/navigator.dart';

class CustomSliverAppBar extends StatelessWidget {
  String text;

  CustomSliverAppBar(String text) {
    this.text = text;
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: backgroundColorStart,
      pinned: true,
      automaticallyImplyLeading: true,
      leading: IconButton(
        icon: Image.asset(
          "assets/icons/zuruck.png",
          scale: 20,
        ),
        onPressed: () {
          navigatorPop(context);
        },
      ),
      expandedHeight: 80,
      centerTitle: true,
      title: Text(
        text,
        style: GoogleFonts.quicksand(
            fontSize: 35, fontWeight: FontWeight.w500, color: colorTextDark),
      ),
    );
  }
}
