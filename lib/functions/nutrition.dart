import 'package:greentrition/constants/categories.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, bool>> getNutritionSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool vegan = prefs.getBool("vegan") ?? false;
  bool vegetarian = prefs.getBool("vegetarian") ?? false;
  bool histamine = prefs.getBool("histamine") ?? false;
  bool gluten = prefs.getBool("gluten") ?? false;
  bool sugar = prefs.getBool("sugar") ?? false;
  bool fructose = prefs.getBool("fructose") ?? false;

  return {
    "vegan": vegan,
    "vegetarian": vegetarian,
    "histamine": histamine,
    "gluten": gluten,
    "sugar": sugar,
    "fructose": fructose,
  };
}

Future<bool> getNutritionSetting(Category category) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  switch (category) {
    case Category.vegan:
      {
        return prefs.getBool("vegan") ?? false;
      }
    case Category.vegetarian:
      {
        return prefs.getBool("vegetarian") ?? false;
      }
    case Category.gluten:
      {
        return prefs.getBool("gluten") ?? false;
      }
    case Category.sugar:
      {
        return prefs.getBool("sugar") ?? false;
      }
    case Category.fructose:
      {
        return prefs.getBool("fructose") ?? false;
      }
    case Category.histamine:
      {
        return prefs.getBool("histamine") ?? false;
      }
  }
}

void setNutrition(Category category, value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  switch (category) {
    case Category.vegan:
      {
        prefs.setBool("vegan", value);
        break;
      }
    case Category.vegetarian:
      {
        prefs.setBool("vegetarian", value);
        break;
      }
    case Category.gluten:
      {
        prefs.setBool("gluten", value);
        break;
      }
    case Category.sugar:
      {
        prefs.setBool("sugar", value);
        break;
      }
    case Category.fructose:
      {
        prefs.setBool("fructose", value);
        break;
      }
    case Category.histamine:
      {
        prefs.setBool("histamine", value);
        break;
      }
  }
}
