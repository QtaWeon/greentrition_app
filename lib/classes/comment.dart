import 'package:greentrition/constants/categories.dart';

class Comment {
  String author;
  String userId;
  String id;
  String text;
  String date_added;
  Category category;
  int likes;
  Comment(String author,
          String userId,
          String id,
          String text,
          String date_added,
          String category,
          int likes) {
    this.author = author;
    this.userId=userId;
    this.id = id;
    this.text = text;
    this.date_added = date_added;
    this.likes = likes;
    Category.values.forEach((element) {
      if (category.toLowerCase() == element.toString().toLowerCase())
        this.category = element;
    });
  }
}