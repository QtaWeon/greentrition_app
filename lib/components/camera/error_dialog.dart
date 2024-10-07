import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/shadows.dart';

class ErrorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.3,
      height: 120,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        boxShadow: shadowList,
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Wrap(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Dieses Produkt existiert leider noch nicht 😢',
                style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: colorTextDark),
                softWrap: true,
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                decoration: BoxDecoration(
                  color: colorGreen.withOpacity(0.3),
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Produkt anlegen",
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: colorTextDark),
                      ),
                    ),
                    Image.asset(
                      "assets/icons/bearbeiten.png",
                      height: 18,
                      color: colorTextDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]),
      ),
    );
    // return Container(
    //     width: MediaQuery.of(context).size.width / 1.3,
    //     margin: EdgeInsets.symmetric(horizontal: 20),
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(8),
    //         color: colorRedIngredient.withOpacity(0.2)),
    //     child: Padding(
    //       padding: const EdgeInsets.all(8.0),
    //       child: Wrap(
    //         children: [
    //           Column(
    //             children: [
    //               Row(
    //                 children: [
    //                   Image.asset(
    //                     "assets/icons/shield_error.png",
    //                     height: 30,
    //                   ),
    //                   SizedBox(
    //                     width: 10,
    //                   ),
    //                   Flexible(
    //                     child: Text(
    //                       "Dieses Produkt existiert leider noch nicht",
    //                       style: GoogleFonts.quicksand(
    //                           fontWeight: FontWeight.bold,
    //                           fontSize: 18,
    //                           color: colorTextBright),
    //                       maxLines: 5,
    //                       softWrap: true,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Container(
    //                 decoration: BoxDecoration(
    //                     color: backgroundColorEnd,
    //                     borderRadius: BorderRadius.all(Radius.circular(5))),
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(8.0),
    //                   child: Text(
    //                     "Möchtest Du es anlegen?",
    //                     style: GoogleFonts.quicksand(
    //                         fontWeight: FontWeight.bold,
    //                         fontSize: 15,
    //                         color: colorTextDark),
    //                   ),
    //                 ),
    //               )
    //             ],
    //           )
    //         ],
    //       ),
    //     ));
  }
}
