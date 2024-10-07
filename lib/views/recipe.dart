import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/classes/recipe.dart';
import 'package:greentrition/components/recipes/instructions.dart';
import 'package:greentrition/components/recipes/map_display.dart';
import 'package:greentrition/components/recipes/recipe_stepper.dart';
import 'package:greentrition/components/recipes/tags.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/fonts.dart';
import 'package:greentrition/constants/sizing.dart';
import 'package:greentrition/views/basic_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class RecipeView extends StatefulWidget {
  final Recipe recipe;

  const RecipeView({Key key, this.recipe}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RecipeViewState();
  }
}

class RecipeViewState extends State<RecipeView> {
  int selectedPortions = 1;

  @override
  Widget build(BuildContext context) {
    double max_height = MediaQuery.of(context).size.height;
    return BasicPage(
      onStack1: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: TextButton(
            child: Container(
              child: Text(
                "Jetzt zubereiten",
                style: GoogleFonts.quicksand(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            // elevation: 2,
            // color: colorTextDark,
            // textColor: colorTextBright,
            // splashColor: Colors.black,
            // padding: EdgeInsets.all(18),
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(20),
            //     side: BorderSide(color: colorGreen)),
            onPressed: () {
              showCupertinoModalBottomSheet(
                context: context,
                builder: (context) {
                  return RecipeStepper(
                    steps: this.widget.recipe.instructions,
                    title: this.widget.recipe.title,
                  );
                },
              );
            },
          ),
        ),
      ),
      content: SafeArea(
        child: CupertinoScrollbar(
          thickness: 3,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                    height: max_height / 3,
                    child: Image(
                      image: this.widget.recipe.image,
                      fit: BoxFit.fitWidth,
                      width: double.infinity,
                    )),
                Padding(
                  padding: padding_left_and_right,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        this.widget.recipe.title,
                        style: headingFont,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.local_fire_department_outlined),
                              Text(
                                this.widget.recipe.kcalPerPortion.toString() +
                                    " kcal",
                                style: standardStyle,
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.timelapse_rounded),
                              Text(
                                  this.widget.recipe.minutes.toString() +
                                      " Min",
                                  style: standardStyle)
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.star_rate),
                              Text("5/5", style: standardStyle)
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(this.widget.recipe.description,
                          style: standardStyle),
                      Tags(this.widget.recipe.tags),
                      Divider(
                        thickness: 1,
                      ),
                      MapDisplay(
                          ingredientsPerPortion:
                              this.widget.recipe.ingredientsPerPortion,
                          portions: this.widget.recipe.portions),
                      SizedBox(
                        height: 20,
                      ),
                      Instruction(this.widget.recipe.instructions),
                      Divider(
                        thickness: 1,
                      ),
                      MapDisplay(
                        ingredientsPerPortion:
                            this.widget.recipe.nutritionalValuesPerPortion,
                        portions: this.widget.recipe.portions,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
