import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/classes/recipe.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/views/recipe.dart';

class RecipePreview extends StatelessWidget {
  AssetImage image;
  Recipe _recipe;

  RecipePreview(Recipe recipe) {
    this._recipe = recipe;
    this.image = this._recipe.image;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) {
            return RecipeView(recipe: _recipe);
          },
        ));
      },
      child: Stack(
        children: [
          Container(
            height: height / 4,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: colorShadowBlack,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(1, 1)),
              BoxShadow(
                  color: colorShadowWhite,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(-2, -2)),
            ], borderRadius: BorderRadius.circular(20.0)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Stack(children: [
                Container(
                  height: height / 4,
                  width: width / 2,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: image, fit: BoxFit.fill),
                  ),
                ),
                Container(
                  height: height / 8,
                  width: width / 2,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    colorRecipeGradientStart,
                    colorRecipeGradientEnd
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    "Testkuchen",
                    style: GoogleFonts.quicksand(
                        shadows: [
                          Shadow(
                              color: Colors.black,
                              blurRadius: 4,
                              offset: Offset.zero)
                        ],
                        color: colorTextBright,
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                                offset: Offset.zero,
                                color: colorVegan,
                                spreadRadius: 0.1,
                                blurRadius: 2)
                          ]),
                          child: Icon(
                            Icons.timelapse_rounded,
                            color: backgroundColorEnd,
                          ),
                        ),
                        Text("70 Min.",
                            style: GoogleFonts.quicksand(
                                color: colorTextGrey,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                      color: Colors.black,
                                      blurRadius: 5,
                                      offset: Offset.zero)
                                ]))
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
