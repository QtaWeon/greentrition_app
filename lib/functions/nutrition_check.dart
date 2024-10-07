import 'dart:ui';
import 'dart:core';

import 'package:greentrition/classes/ingredient.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/functions/nutrition.dart';
import 'package:greentrition/nutrition_data/e_numbers.dart';
import 'package:greentrition/nutrition_data/gluten.dart';
import 'package:greentrition/nutrition_data/histamin.dart';
import 'package:greentrition/nutrition_data/sugar.dart';
import 'package:greentrition/nutrition_data/vegan.dart';
import 'package:greentrition/nutrition_data/vegetarian.dart';

///Get the Ingredient information the for given ingredients.
Future<IngredientInformation> getIngredientInformation(
    List<String> ingredients) async {
  Map<String, bool> eating_habits = {};
  Map<String, bool> settings = await getNutritionSettings();

  settings.keys.forEach((element) {
    bool value = settings[element];
    if (value == true) {
      eating_habits[element] = value;
    }
  });

  Map<String, bool> ingredient_eating_habits = Map.from(eating_habits);
  List<Ingredient> ingredientClasses = [];

  if (ingredients != null) {
    for (int i = 0; i < ingredients.length; i++) {
      Map<String, bool> temp_ingredient_eating_habits =
          Map.from(ingredient_eating_habits);
      //used for later
      List<String> ing_array = [];

      String ingredient = ingredients[i].toLowerCase();
      RegExp exp = new RegExp("\\d{1,3}%?[ ]*%?", caseSensitive: false);
      RegExpMatch match = exp.firstMatch(ingredient);
      String clean_ingredient;
      if (match != null) {
        clean_ingredient = ingredient.substring(0, match.end);
      } else {
        clean_ingredient = ingredient;
      }

      String info;
      Color color = colorIngredientInContainer;

      ing_array.add(clean_ingredient);

      RegExp tokenizer = new RegExp(
          "[\\s()!\"#\$%&\'()\*\+,./:;<=>?@\[\\\]^_`{|}~]",
          caseSensitive: false,
          dotAll: false,
          multiLine: true,
          unicode: true);

      //adding the clean and also the full tokenized string
      ing_array.addAll(clean_ingredient.split(tokenizer));
      ing_array.addAll(ingredient.split(tokenizer));

      for (int i = 0; i < ing_array.length; i++) {
        String clean_ing = ing_array[i].trim();

        // E Number
        RegExp re =
            new RegExp("[Ee][ ]?\\d{3,4}[abcde]?", caseSensitive: false);
        if (re.firstMatch(clean_ing) != null) {
          info = getEnrInformation(ingredient, re);
          color = colorEnr;
        }
        if (eating_habits.containsKey("sugar")) {
          if (sugarSet.contains(clean_ing.toLowerCase())) {
            color = colorSugar;
            eating_habits["sugar"] = false;
            temp_ingredient_eating_habits["sugar"] = false;
          }
        }
        if (eating_habits.containsKey("histamine")) {
          if (histamineSet.contains(clean_ing.toLowerCase())) {
            color = colorHistamine;
            eating_habits["histamine"] = false;
            temp_ingredient_eating_habits["histamine"] = false;
          }
        }
        if (eating_habits.containsKey("gluten")) {
          if (glutenSet.contains(clean_ing.toLowerCase())) {
            color = colorGluten;
            eating_habits["gluten"] = false;
            temp_ingredient_eating_habits["gluten"] = false;
          }
        }
        if (eating_habits.containsKey("vegan")) {
          if (veganSet.contains(clean_ing.toLowerCase())) {
            color = colorRedIngredient;
            eating_habits["vegan"] = false;
            temp_ingredient_eating_habits["vegan"] = false;
          }
        }
        if (eating_habits.containsKey("vegetarian")) {
          if (vegetarianSet.contains(clean_ing.toLowerCase())) {
            color = colorRedIngredient;
            eating_habits["vegetarian"] = false;
            temp_ingredient_eating_habits["vegetarian"] = false;
          }
        }
      }
      ingredientClasses.add(Ingredient(
          ingredients[i], info, color, temp_ingredient_eating_habits));
    }
  } else {
    print(
        "Could not automatically generate informations about the ingredients");
    return null;
  }
  return IngredientInformation(ingredientClasses, eating_habits);
}

///Extract E-Number information
String getEnrInformation(String ingredient, RegExp re) {
  RegExpMatch match = re.firstMatch(ingredient);
  String e_nr = ingredient.substring(match.start, match.end);
  String info;

  if (re.firstMatch(e_nr) != null && e_nr.substring(0, 0) != " ") {
    e_nr = "E " + e_nr.substring(1).trim();
  }
  if (e_nr[0] == "e") {
    e_nr = e_nr.replaceRange(0, 1, e_nr[0].toUpperCase());
  }

  if (eNumbers.containsKey(e_nr)) {
    info = eNumbers[e_nr]["stoff"];
    String additionalInfo = eNumbers[e_nr]["bemerkungen"];
    if (additionalInfo.length > 0) {
      info += " " + additionalInfo;
    }
  }
  return info;
}
