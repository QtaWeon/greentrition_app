import 'package:flutter/cupertino.dart';
import 'package:greentrition/constants/categories.dart';
import 'package:greentrition/functions/category_enum_converter.dart';

class Ingredient {
  Color color;
  String name;
  String info;
  Map<String, bool> nutrition;

  Ingredient(
      String name, String info, Color color, Map<String, bool> nutrition) {
    this.name = name;
    this.info = info;
    this.color = color;
    this.nutrition = nutrition;
  }

  List<Category> getTrueNutrition() {
    List<Category> retVal = [];
    nutrition.forEach((key, value) {
      if (value == true) {
        retVal.add(getCategoryEnum(key));
      }
    });

    return retVal;
  }

  List<Category> getFalseNutrition() {
    List<Category> retVal = [];
    nutrition.forEach((key, value) {
      if (value == false) {
        retVal.add(getCategoryEnum(key));
      }
    });

    return retVal;
  }
}

//Contains the information for the given ingredients.
class IngredientInformation {
  List<Ingredient> ingredients;
  Map<String, bool> nutritionClassification;

  IngredientInformation(
      List<Ingredient> ingredients, Map<String, bool> nutritionClassification) {
    this.ingredients = ingredients;
    this.nutritionClassification = nutritionClassification;
  }

  List<Category> getTrueNutrition() {
    List<Category> ret = [];
    nutritionClassification.forEach((key, value) {
      if (value == true) {
        ret.add(getCategoryEnum(key));
      }
    });
    return ret;
  }

  List<Category> getFalseNutrition() {
    List<Category> ret = [];
    nutritionClassification.forEach((key, value) {
      if (value == false) {
        ret.add(getCategoryEnum(key));
      }
    });
    return ret;
  }

  /// Get whether a category is included or not.
  ///
  /// E.g. If the ingredients are glutenfree it would return true for value Category.gluten
  bool isNutrition(Category category) {
    nutritionClassification.forEach((key, value) {
      if (getCategoryEnum(key) == category && value == true) {
        return true;
      }
    });
    return false;
  }
}
