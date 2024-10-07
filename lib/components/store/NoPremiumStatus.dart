import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/screens/settings.dart';

class NoPremiumStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            // showCupertinoModalBottomSheet(
            //   context: context,
            //   builder: (context) {
            //     return ProfilePremiumStatus();
            //   },
            // );
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => Settings(),
                    settings: RouteSettings(name: "Settings - Login")));
          },
          child: Text(
            "Diese Funktion mit Premium freischalten",
            style: GoogleFonts.quicksand(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
