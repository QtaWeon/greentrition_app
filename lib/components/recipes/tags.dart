import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/constants/colors.dart';

class Tags extends StatelessWidget {
  final List<Widget> chips = [];

  Tags(List<String> tags) {
    tags.forEach((element) {
      this.chips.add(RawChip(
            label: Text(element, style: GoogleFonts.quicksand()),
            backgroundColor: backgroundColorStart,
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: chips,
      spacing: 10,
      runSpacing: 3,
    );
  }
}
