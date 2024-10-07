enum Category { all, vegan, vegetarian, gluten, histamine, sugar, fructose }

const Map<Category, String> categoryToText = {
  Category.all: "All",
  Category.vegan: "Vegan",
  Category.vegetarian: "Vegetarisch",
  Category.gluten: "Gluten",
  Category.histamine: "Histamin",
  Category.sugar: "Zucker",
  Category.fructose: "Fruktose",
};

const Map<Category, String> category_included_text = {
  Category.vegan: "vegan",
  Category.vegetarian: "vegetarisch",
  Category.histamine: "histaminarm",
  Category.gluten: "glutenfrei",
  Category.sugar: "zuckerfrei",
  Category.fructose: "fruktosefrei"
};

const Map<Category, String> category_not_included_text = {
  Category.vegan: "nicht vegan",
  Category.vegetarian: "nicht vegetarisch",
  Category.histamine: "enthält Histamin",
  Category.gluten: "enthält Gluten",
  Category.sugar: "enthält Zucker",
  Category.fructose: "enthält Fruktose",
};

const Map<Category, String> category_text_icon = {
  Category.vegan: "🌱",
  Category.vegetarian: "🥛",
  Category.histamine: "🍅",
  Category.gluten: "🌾",
  Category.sugar: "🍭",
  Category.fructose: "🍏",
};
