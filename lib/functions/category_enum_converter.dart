import 'package:greentrition/constants/categories.dart';

Category getCategoryEnum(String category) {
  switch (category) {
    case "all":
      {
        return Category.all;
      }
      break;

    case "vegan":
      {
        return Category.vegan;
      }
      break;

    case "vegetarian":
      {
        return Category.vegetarian;
      }
      break;

    case "gluten":
      {
        return Category.gluten;
      }
      break;

    case "histamine":
      {
        return Category.histamine;
      }
      break;

    case "sugar":
      {
        return Category.sugar;
      }
      break;

    case "fructose":
      {
        return Category.fructose;
      }
      break;

    default:
      {
        return null;
      }
  }
}
