import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:greentrition/classes/ingredient.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/fonts.dart';

import 'ingredient.dart';

class Ingredients extends StatelessWidget {
  List<Ingredient> ingredients;

  Ingredients(List<Ingredient> ingredients) {
    this.ingredients = ingredients;
  }

  List<Widget> loadIngredients() {
    List<Widget> ret = [];
    ingredients.forEach((element) {
      ret.add(IngredientWidget(
        ingredient: element,
      ));
    });

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: colorContainer,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 1),
                spreadRadius: 1,
                blurRadius: 2,
                color: colorShadowBlack)
          ]),
      child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
              spacing: 5.0,
              alignment: WrapAlignment.center,
              children: ingredients.length > 0
                  ? loadIngredients()
                  : [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Dieses Produkt hat anscheinend noch keine Inhaltsstoffe und kann daher nicht richtig klassifiziert werden 😢"
                              " Füge sie gerne selbst hinzu! Klicke dafür oben rechts auf das Fragezeichen 😊",
                          style: standardStyle,
                        ),
                      )
                    ])),
    );
  }
}
