import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class Instruction extends StatelessWidget {
  List<String> instructions = [];

  Instruction(List<String> instructions) {
    this.instructions = instructions;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: instructions.length,
      itemBuilder: (context, index) {
        return Text((index + 1).toString() + ".  " + instructions[index],
            style: GoogleFonts.quicksand(fontWeight: FontWeight.w600));
      },
    );
  }
}
