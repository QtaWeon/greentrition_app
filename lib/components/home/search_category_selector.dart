import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/constants/categories.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/functions/category_enum_converter.dart';
import 'package:greentrition/functions/colors.dart';
import 'package:greentrition/functions/helper_functions.dart';
import 'package:greentrition/functions/nutrition.dart';

class SearchCategorySelector extends StatefulWidget {
  final List<Category> _selectedCategories = [];

  @override
  State<StatefulWidget> createState() {
    return SearchCategorySelectorState();
  }

  List<Category> getSelectedCategories() {
    return _selectedCategories;
  }
}

class SearchCategorySelectorState extends State<SearchCategorySelector>
    with SingleTickerProviderStateMixin {
  List<Category> _allCategories = [];
  List<CategoryChip> chips = [];
  int firstUnselectedIndex = 0;

  @override
  void initState() {
    getNutritionSettings().then((settings) {
      settings.keys.where((element) => settings[element]).toList().forEach((value) {
        print(value);
        setState(() {
          _allCategories.add(getCategoryEnum(value));
        });
        chips = buildChips();
      });
    });
    super.initState();
  }

  void swapChips(Category category, bool selected) {
    setState(() {
      if (selected) {
        firstUnselectedIndex++;
        CategoryChip chip = chips.removeAt(
            chips.indexWhere((element) => element.category == category));
        chips.insert(0, chip);
        this.widget._selectedCategories.add(category);
      } else {
        firstUnselectedIndex--;
        CategoryChip chip = chips.removeAt(
            chips.indexWhere((element) => element.category == category));
        if (firstUnselectedIndex == chips.length) {
          chips.add(chip);
        } else {
          chips.insert(firstUnselectedIndex, chip);
        }
        this.widget._selectedCategories.remove(category);
      }
    });
  }

  List<CategoryChip> buildChips() {
    List<CategoryChip> widgets = [];
    _allCategories.forEach((category) {
      widgets.add(CategoryChip(
          key: UniqueKey(),
          category: category,
          swapChips: (Category category, bool selected) =>
              swapChips(category, selected)));
    });
    return widgets;
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      child: Wrap(
          spacing: 5.0,
          children: chips,),
    );
  }
}

class CategoryChip extends StatefulWidget {
  final Category category;
  final Function swapChips;

  const CategoryChip({Key key, this.category, this.swapChips})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CategoryChipState();
  }
}

class CategoryChipState extends State<CategoryChip> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return InputChip(
      padding: EdgeInsets.all(5),
      label: Text(category_included_text[this.widget.category],
          style: GoogleFonts.openSans(fontSize: 15,
            color: selected
                ? textColorFromHex(colorFromCategory(this.widget.category))
                : colorTextDark,)),
      onPressed: () {
        setState(() {
          selected = !selected;
          this.widget.swapChips(this.widget.category, selected);
        });
      },
      selectedColor: colorFromCategory(this.widget.category),
      backgroundColor: Colors.grey[200],
      selected: selected,
    );
  }
}
