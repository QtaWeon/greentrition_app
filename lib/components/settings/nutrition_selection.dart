import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/constants/categories.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/functions/ImageGetter.dart';
import 'package:greentrition/functions/category_enum_converter.dart';
import 'package:greentrition/functions/nutrition.dart';

class NutritionSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NutritionSelectionState();
  }
}

class NutritionSelectionState extends State<NutritionSelection> {
  List<Category> categories = [];

  @override
  void initState() {
    getNutritionSettings().then((value) =>
        categories = value.keys.map((e) => getCategoryEnum(e)).toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.white),
      child: ListView.builder(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return NutritionSwitchTile(
              category: categories[index],
            );
          }),
    );
  }
}

class NutritionSelectionChip extends StatefulWidget {
  final Category category;

  const NutritionSelectionChip({Key key, this.category}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NutritionSelectionChipState();
  }
}

class NutritionSelectionChipState extends State<NutritionSelectionChip>
    with SingleTickerProviderStateMixin {
  String text = "";
  bool selected = false;
  AnimationController _controller;
  Animation colorTween;

  @override
  void initState() {
    text = categoryToText[this.widget.category];
    getNutritionSetting(this.widget.category).then((value) {
      selected = value;
      //animate if value true
      if (selected) {
        animate(selected);
      }
    });

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    colorTween = ColorTween(begin: colorUnchecked, end: colorVegetarian)
        .animate(_controller);
    super.initState();
  }

  void toggleSelection() {
    setNutrition(this.widget.category, !selected);
    selected = !selected;

    animate(selected);
  }

  void animate(bool selected) {
    if (selected == true) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return ActionChip(
            shadowColor: colorShadow,
            elevation: 1,
            onPressed: () {
              toggleSelection();
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(23.0),
                side: BorderSide(color: selected ? colorGreen : colorTextDark)),
            padding: EdgeInsets.all(14),
            label: Text(
              this.text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            backgroundColor: colorTween.value,
            avatar:
                ImageGetter.getCategoryAsset(this.widget.category, scale: 0.5),
          );
        });
  }
}

class NutritionSwitchTile extends StatefulWidget {
  final Category category;

  const NutritionSwitchTile({Key key, this.category}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NutritionSwitchTileState();
  }
}

class NutritionSwitchTileState extends State<NutritionSwitchTile> {
  String text = "";
  bool selected = false;

  @override
  void initState() {
    text = categoryToText[this.widget.category];
    getNutritionSetting(this.widget.category).then((value) {
      setState(() {
        selected = value;
      });
    });

    super.initState();
  }

  void toggleSelection() {
    selected = !selected;
    setNutrition(this.widget.category, selected);
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
        activeColor: colorGreen,
        value: selected,
        title: Text(
          category_included_text[this.widget.category],
          style: GoogleFonts.openSans(),
        ),
        secondary: ImageGetter.getCategoryTextIcon(
          this.widget.category,
          fontSize: 22,
        ),
        onChanged: (val) {
          setState(() {
            toggleSelection();
          });
        });
  }
}
