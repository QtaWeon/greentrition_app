import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/classes/recipe.dart';
import 'package:greentrition/components/recipes/recipe_preview.dart';
import 'package:greentrition/constants/categories.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/sizing.dart';

class Recipes extends StatelessWidget {
  Category category;
  List<Widget> lv;

  Recipes(Category category) {
    this.category = category;
    lv = [
      SizedBox(
        width: padding_left.left,
      ),
      RecipePreview(Recipe(
          "123",
          "Testkuchen",
          "Testkuchen 123",
          "beschreibung",
          AssetImage("assets/images/kuchen.jpg"),
          20000000000000000,
          {"asd": "500g",
          "asd": "500g",
          "asd": "500g",
          "asd": "500g",
          "asd": "500g",
          "asd": "500g",
          "asd": "500g",
          "asd": "500g",
          "asd": "500g",
          "asd": "500g"
          },
          200,
          100,
          {"Zucker": "500g","Salz": "500g"},
          ["ANleitung1", "ANleitung2", "ANleitung2", "ANleitung2", "ANleitung2"],
          ["gut", "lecker", "vegan"],
          "einfach",
          4.3,
          ["123", "1234"],
          ["123", "123"],
          [Category.fructose, Category.fructose])),
      RecipePreview(Recipe(
          "123",
          "Testkuchen",
          "Testkuchen 123",
          "beschrebescbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibunghreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungbeschreibungibung",
          AssetImage("assets/images/lava-cake.jpg"),
          2000000,
          {"asd": "500g"},
          20,
          10,
          {"Zucker": "500g"},
          ["ANleitung1", "ANleitung2"],
          ["gut", "lecker", "vegan"],
          "einfach",
          4.3,
          ["123", "1234"],
          ["123", "123"],
          [Category.fructose, Category.fructose])),
      RecipePreview(Recipe(
          "123",
          "Testkuchen",
          "Testkuchen 123",
          "beschreibung",
          AssetImage("assets/images/kuchen.jpg"),
          200,
          {"asd": "500g"},
          20,
          10,
          {"Zucker": "500g"},
          ["ANleitung1", "ANleitung2"],
          ["gut", "lecker", "vegan"],
          "einfach",
          4.3,
          ["123", "1234"],
          ["123", "123"],
          [Category.fructose, Category.fructose])),
      RecipePreview(Recipe(
          "123",
          "Testkuchen",
          "Testkuchen 123",
          "beschreibung",
          AssetImage("assets/images/lava-cake.jpg"),
          200,
          {"asd": "500g"},
          20,
          10,
          {"Zucker": "500g"},
          ["ANleitung1", "ANleitung2"],
          ["gut", "lecker", "vegan"],
          "einfach",
          4.3,
          ["123", "1234"],
          ["123", "123"],
          [Category.fructose, Category.fructose])),
      RecipePreview(Recipe(
          "123",
          "Testkuchen",
          "Testkuchen 123",
          "beschreibung",
          AssetImage("assets/images/kuchen.jpg"),
          200,
          {"asd": "500g"},
          20,
          10,
          {"Zucker": "500g"},
          ["ANleitung1", "ANleitung2"],
          ["gut", "lecker", "vegan"],
          "einfach",
          4.3,
          ["123", "1234"],
          ["123", "123"],
          [Category.fructose, Category.fructose])),
      RecipePreview(Recipe(
          "123",
          "Testkuchen",
          "Testkuchen 123",
          "beschreibung",
          AssetImage("assets/images/lava-cake.jpg"),
          200,
          {"asd": "500g"},
          20,
          10,
          {"Zucker": "500g"},
          ["ANleitung1", "ANleitung2"],
          ["gut", "lecker", "vegan"],
          "einfach",
          4.3,
          ["123", "1234"],
          ["123", "123"],
          [Category.fructose, Category.fructose])),
      RecipePreview(Recipe(
          "123",
          "Testkuchen",
          "Testkuchen 123",
          "beschreibung",
          AssetImage("assets/images/kuchen.jpg"),
          200,
          {"asd": "500g"},
          20,
          10,
          {"Zucker": "500g"},
          ["ANleitung1", "ANleitung2"],
          ["gut", "lecker", "vegan"],
          "einfach",
          4.3,
          ["123", "1234"],
          ["123", "123"],
          [Category.fructose, Category.fructose])),
      RecipePreview(Recipe(
          "123",
          "Testkuchen",
          "Testkuchen 123",
          "beschreibung",
          AssetImage("assets/images/lava-cake.jpg"),
          200,
          {"asd": "500g"},
          20,
          10,
          {"Zucker": "500g"},
          ["ANleitung1", "ANleitung2"],
          ["gut", "lecker", "vegan"],
          "einfach",
          4.3,
          ["123", "1234"],
          ["123", "123"],
          [Category.fructose, Category.fructose])),
      SizedBox(
        width: 40,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10, left: padding_left.left),
          child: Text("Backen & Desserts",
              style: GoogleFonts.quicksand(
                  shadows: [
                    Shadow(
                        color: Colors.black,
                        blurRadius: 0.5,
                        offset: Offset.zero)
                  ],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorTextDark)),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 4.5,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 10,
              );
            },
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: lv.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: lv[index]);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, left: padding_left.left),
          child: Text("Hauptmahlzeiten",
              style: GoogleFonts.quicksand(
                  shadows: [
                    Shadow(
                        color: Colors.black,
                        blurRadius: 0.5,
                        offset: Offset.zero)
                  ],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorTextDark)),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 4.5,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 10,
              );
            },
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: lv.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: lv[index]);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10, left: padding_left.left),
          child: Text("Test-Titel 2021",
              style: GoogleFonts.quicksand(
                  shadows: [
                    Shadow(
                        color: Colors.black,
                        blurRadius: 0.5,
                        offset: Offset.zero)
                  ],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorTextDark)),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 4.5,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                width: 10,
              );
            },
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: lv.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: lv[index]);
            },
          ),
        ),
      ],
    );
  }
}
