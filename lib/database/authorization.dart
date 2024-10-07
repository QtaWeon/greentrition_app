import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:greentrition/database/server.dart';
import 'package:greentrition/functions/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'db_adapter.dart';

class Authorization {
  void authorize() async {
    String usr = await getUsername();
    String pw = await getPassword();
    print("AUTHORIZING");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await getAppDBToken(usr, pw)
          .then((value) => prefs.setString("auth_key", value));
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: "A problem with the server occured.");
    }
    await getFirebaseToken(usr, pw).then((value) => initializeFirebase(value));

    //Setting local userId
    AppDb.getUser().then((user) {
      setUserId(user.id);
    });
  }

  Future<String> getFirebaseToken(user, pwd) async {
    Map jsonData = {"user": user, "password": pwd};
    final resp =
        await http.post(Uri.https(authenticationServer, "/firebaseAuth"),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
            },
            body: jsonEncode(jsonData));
    return resp.body;
  }

  Future<String> getAppDBToken(user, pwd) async {
    Map jsonData = {"user": user, "password": pwd};
    final resp = await http.post(Uri.https(authenticationServer, "/auth"),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: jsonEncode(jsonData));
    return resp.body;
  }

  void initializeFirebase(String key) async {
    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInWithCustomToken(key);
  }
}
