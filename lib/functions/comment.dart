import 'package:greentrition/database/db_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> getLocalLikeStatus(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool status = prefs.getBool(id) ?? false;
  return status;
}

void toggleLike(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool status = prefs.getBool(id) ?? false;
  if (!status) {
    AppDb.addLike(id, 1);
  } else {
    AppDb.addLike(id, -1);
  }
  prefs.setBool(id, !status);
}
