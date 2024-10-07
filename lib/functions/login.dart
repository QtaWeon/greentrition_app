import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greentrition/components/registration/add_username.dart';
import 'package:greentrition/database/authorization.dart';
import 'package:greentrition/functions/user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:http/http.dart' as http;

void loginApple(BuildContext context) async {
  final credential = await SignInWithApple.getAppleIDCredential(
    scopes: [
      AppleIDAuthorizationScopes.email,
      AppleIDAuthorizationScopes.fullName,
    ],
    webAuthenticationOptions: WebAuthenticationOptions(
      // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
      clientId: 'com.greentrition.applesignin',
      redirectUri: Uri.parse(
        'https://greentrition.de:2096/callbacks/sign_in_with_apple',
      ),
    ),
  );

  // This is the endpoint that will convert an authorization code obtained
  // via Sign in with Apple into a session in your system
  final signInWithAppleEndpoint = Uri(
    scheme: 'https',
    host: 'greentrition.de',
    path: '/sign_in_with_apple',
    port: 2096,
    queryParameters: <String, String>{
      'code': credential.authorizationCode,
      'firstName': credential.givenName,
      'lastName': credential.familyName,
      'useBundleId': Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
      if (credential.state != null) 'state': credential.state,
    },
  );

  final session = await http.Client().post(
    signInWithAppleEndpoint,
  );

  String password = jsonDecode(session.body)["password"];
  String name = jsonDecode(session.body)["name"];
  String email = jsonDecode(session.body)["email"];

  checkCredentials(name, password, email, context);
}

void loginGoogle(GoogleSignInAccount currentUser, String client_id,
    BuildContext context) async {
  GoogleSignInAuthentication auth = await currentUser.authentication;
  final signInWithGoogleEndpoint = Uri(
    scheme: 'https',
    host: 'greentrition.de',
    path: '/sign_in_with_google',
    port: 2096,
    queryParameters: <String, String>{
      'client_id': client_id,
      'idToken': auth.idToken,
    },
  );

  final session = await http.Client().post(
    signInWithGoogleEndpoint,
  );

  String password = jsonDecode(session.body)["password"];
  String name = jsonDecode(session.body)["name"];
  String email = jsonDecode(session.body)["email"];

  checkCredentials(name, password, email, context);
}

/// Determines whether this account has a username set
void checkCredentials(
    String name, String password, String email, BuildContext context) async {
  if (name.length == 0) {
    final result = await Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => AddUsername(
                  email: email,
                )));
    if (result[0] == true) {
      setUsername(result[1]);
      setPassword(password);
      Authorization().authorize();
      Navigator.of(context).pop();
    }
  } else {
    setUsername(name);
    setPassword(password);
    Authorization().authorize();
    Navigator.of(context).pop();
  }
}
