class User {
  String name;
  String email;
  String id;
  String date_added;
  bool premium = false;

  User(String name, String email, String id, String date_added, bool premium) {
    this.name = name;
    this.id = id;
    this.email = email;
    this.date_added = date_added;
    if (premium == null) {
      this.premium = false;
    } else {
      this.premium = premium;
    }
  }
}

class UserInformation {
  String name;
  String id;
  String date_added;
  int likes;
  int comments;
  bool premium;

  UserInformation(String name, String id, String date_added,
      {int likes = 0, int comments = 0, bool premium = false}) {
    this.name = name;
    this.id = id;
    this.date_added = date_added;
    this.likes = likes;
    this.comments = comments;
    if (premium == null) {
      this.premium = false;
    } else {
      this.premium = premium;
    }
  }
}
