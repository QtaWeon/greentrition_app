import 'dart:ui';
import 'package:greentrition/constants/categories.dart';
import 'package:greentrition/constants/colors.dart';

Color colorFromCategory(Category category) {
  switch (category) {
    case Category.vegan:
      {
        return colorVegan;
      }
    case Category.vegetarian:
      {
        return colorVegetarian;
      }
    case Category.histamine:
      {
        return colorHistamine;
      }
    case Category.fructose:
      {
        return colorFructose;
      }
    case Category.sugar:
      {
        return colorSugar;
      }
    case Category.gluten:
      {
        return colorGluten;
      }
  }
}
