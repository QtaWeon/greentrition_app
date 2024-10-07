import 'package:flutter/cupertino.dart';
import 'package:greentrition/constants/categories.dart';

///Represents a full recipe
class Recipe {
  String id;
  String title;
  String name;
  String description;
  ImageProvider image;
  int durationMiliseconds;
  Map<String, String> ingredientsPerPortion;
  int portions;
  int kcalPerPortion;
  Map<String, String> nutritionalValuesPerPortion;
  List<String> instructions;
  //TODO add to constructor
  List<Map<String, String>> ingredientsPerInstruction;
  List<String> tags;
  String difficulty;
  double rating;
  List<String> similarRecipesIds;
  List<String> suggestionRecipesIds;
  List<Category> categories;

  int minutes;

  Recipe(
      String id,
      String titel,
      String name,
      String description,
      ImageProvider image,
      int durationMiliseconds,
      Map<String, String> ingredientsPerPortion,
      int portions,
      int kcalPerPortion,
      Map<String, String> nutritionalValuesPerPortion,
      List<String> instructions,
      List<String> tags,
      String difficulty,
      double rating,
      List<String> similarRecipesIds,
      List<String> suggestionRecipesIds,
      List<Category> categories) {
    this.id = id;
    this.title = titel;
    this.name = name;
    this.description = description;
    this.image = image;
    this.durationMiliseconds = durationMiliseconds;
    this.ingredientsPerPortion = ingredientsPerPortion;
    this.portions = portions;
    this.kcalPerPortion = kcalPerPortion;
    this.nutritionalValuesPerPortion = nutritionalValuesPerPortion;
    this.instructions = instructions;
    this.tags = tags;
    this.difficulty = difficulty;
    this.rating = rating;
    this.similarRecipesIds = similarRecipesIds;
    this.suggestionRecipesIds = suggestionRecipesIds;
    this.categories = categories;

    this.minutes = Duration(milliseconds: durationMiliseconds).inMinutes;
  }
}
