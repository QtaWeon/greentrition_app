import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/constants/categories.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/heroes.dart';
import 'package:greentrition/functions/ImageGetter.dart';

class CategoryWidget extends StatefulWidget {
  final String title;
  final double fontSize;
  final Color startingColor;
  final Category category;
  final String tag;

  const CategoryWidget(
      {Key key,
      this.category,
      this.title,
      this.fontSize,
      this.startingColor,
      this.tag})
      : super(key: key);

  @override
  CategoryWidgetState createState() => CategoryWidgetState();
}

class CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Widget nextPage = HeroFactory.tagToHero(this.widget.tag);
        Navigator.push(
            context, CupertinoPageRoute(builder: (context) => nextPage));
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            //color: widget.startingColor
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.startingColor,
                  widget.startingColor.withOpacity(0.7)
                ],
                stops: [
                  0.2,
                  0.9
                ]),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 2,
                  blurRadius: 5,
                  color: colorShadowBlack,
                  offset: Offset(1, 1)),
              BoxShadow(
                  color: colorShadowWhite,
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(-2, -2)),
            ]),
        width: MediaQuery.of(context).size.width * 0.37,
        height: MediaQuery.of(context).size.width * 0.27,
        child: Stack(alignment: Alignment.center, children: [
          ImageGetter.getCategoryTextIcon(this.widget.category, fontSize: 42),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                widget.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.pathwayGothicOne(
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black54,
                      offset: Offset(3.0, 5.0),
                    ),
                  ],
                  fontSize: widget.fontSize,
                  color: colorTextBright,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class Categories extends StatefulWidget {
  @override
  CategoriesState createState() => CategoriesState();
}

class CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            "Entdecken",
            style: GoogleFonts.quicksand(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.only(top: 15.0, bottom: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CategoryWidget(
                    title: "Fruktosefrei",
                    tag: "fructose",
                    fontSize: 20,
                    startingColor: colorFructose,
                    category: Category.fructose,
                  ),
                  CategoryWidget(
                    title: "Glutenfrei",
                    tag: "gluten",
                    fontSize: 20,
                    startingColor: colorGluten,
                    category: Category.gluten,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CategoryWidget(
                    title: "Zuckerfrei",
                    tag: "sugar",
                    fontSize: 20,
                    startingColor: colorSugar,
                    category: Category.sugar,
                  ),
                  CategoryWidget(
                      title: "Histaminarm",
                      tag: "histamine",
                      fontSize: 20,
                      startingColor: colorHistamine,
                      category: Category.histamine),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CategoryWidget(
                      title: "Vegan",
                      tag: "vegan",
                      fontSize: 20,
                      startingColor: colorVegan,
                      category: Category.vegan),
                  CategoryWidget(
                    title: "Vegetarisch",
                    fontSize: 20,
                    tag: "vegetarian",
                    startingColor: colorVegetarian,
                    category: Category.vegetarian,
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
