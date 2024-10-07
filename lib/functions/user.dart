import 'package:greentrition/classes/user.dart';
import 'package:greentrition/constants/standard_user.dart';
import 'package:greentrition/database/authorization.dart';
import 'package:greentrition/database/db_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getUsername() async {
  String user_name;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String ret = prefs.getString("user");
  if (ret == null) {
    user_name = free_user;
  } else {
    user_name = ret;
  }
  return user_name;
}

void setUsername(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (name != null) {
    prefs.setString("user", name);
  }
}

Future<String> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = prefs.getString("userId") ?? "";
  return userId;
}

void setUserId(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (userId != null) {
    prefs.setString("userId", userId);
  }
}

Future<String> getPassword() async {
  String password;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String ret = prefs.getString("password");
  if (ret == null) {
    password = free_password;
  } else {
    password = ret;
  }

  return password;
}

void setPassword(String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (password != null) {
    prefs.setString("password", password);
  }
}

Future<bool> isFreeUser() async {
  String usr = await getUsername();
  if (usr == free_user) {
    return true;
  } else {
    return false;
  }
}

Future<bool> isPremium() async {
  User usr;
  try {
    usr = await AppDb.getUser();
  } catch (err) {
    //err might occur when not internet connection is available
    print(err);
    return false;
  }
  return usr.premium;
}

void setDefaultUser(){
  setUsername(free_user);
  setPassword(free_password);
  setUserId(free_userid);
}

void logoutUser() {
  setDefaultUser();
  Authorization().authorize();
}
