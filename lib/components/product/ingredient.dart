import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:greentrition/classes/ingredient.dart';
import 'package:greentrition/constants/categories.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/functions/helper_functions.dart';
import 'package:show_more_text_popup/show_more_text_popup.dart';
import 'package:google_fonts/google_fonts.dart';

class IngredientWidget extends StatefulWidget {
  final Ingredient ingredient;

  IngredientWidget({Key key, this.ingredient}) : super(key: key);

  @override
  IngredientWidgetState createState() => IngredientWidgetState();
}

class IngredientWidgetState extends State<IngredientWidget>
    with TickerProviderStateMixin {
  GlobalKey key = GlobalKey();

  IngredientWidget(Ingredient ingredient) {}

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: this.widget.ingredient.getFalseNutrition().length > 0
          ? ActionChip(
              shadowColor: colorShadow,
              onPressed: () {
                String text = "";
                this.widget.ingredient.getFalseNutrition().forEach((element) {
                  text += "nicht " + category_included_text[element] + ".";
                });
                if (this.widget.ingredient.info != null) {
                  text += " " + this.widget.ingredient.info;
                }

                if (text != null || text.length != 0) {
                  showInfo(text, this.widget.ingredient.color);
                }
              },
              key: key,
              avatar: CircleAvatar(
                backgroundColor: colorRed.withOpacity(0.5),
                child: Text(categoryToText[
                    this.widget.ingredient.getFalseNutrition()[0]][0]),
              ),
              label: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  this.widget.ingredient.name,
                  style: GoogleFonts.openSans(
                      color: textColorFromHex(this.widget.ingredient.color)),
                  textAlign: TextAlign.center,
                  maxLines: 5,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              backgroundColor: this.widget.ingredient.color,
            )
          : ActionChip(
              shadowColor: colorShadow,
              onPressed: () {
                if (this.widget.ingredient.info != null) {
                  showInfo(this.widget.ingredient.info,
                      this.widget.ingredient.color);
                }
              },
              key: key,
              backgroundColor: this.widget.ingredient.color,
              label: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  this.widget.ingredient.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColorFromHex(this.widget.ingredient.color),
                  ),
                  maxLines: 5,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
    );
  }

  void showInfo(String text, Color color) {
    ShowMoreTextPopup popup = ShowMoreTextPopup(context,
        widget: Text(
          text,
          overflow: TextOverflow.clip,
          style:
              TextStyle(color: textColorFromHex(this.widget.ingredient.color)),
          maxLines: 20,
        ),
        height: 35,
        width: 200,
        backgroundColor: color,
        padding: EdgeInsets.all(10.0),
        borderRadius: BorderRadius.circular(10.0),
        opacity: 0.9,
        vsync: this);

    /// show the popup for specific widget
    popup.show(
      widgetKey: this.key,
    );
  }
}
