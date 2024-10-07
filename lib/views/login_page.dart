import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/functions/login.dart';
import 'package:greentrition/functions/user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'basic_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  GoogleSignInAccount _currentUser;
  bool loggedIn = false;
  GoogleSignIn _googleSignIn;
  String client_id = "";

  @override
  void initState() {
    if (Platform.isIOS) {
      client_id =
          "95899471867-phq0afpq6c254qrpgd5m3675ehosed3r.apps.googleusercontent.com";
    } else if (Platform.isAndroid) {
      client_id =
          "95899471867-4plfssaalv4us91alcnk9hf7psmrjngm.apps.googleusercontent.com";
    } else {
      client_id =
          "95899471867-52092reo17gp2vl1h88k6q29v92geuu5.apps.googleusercontent.com";
    }
    _googleSignIn = GoogleSignIn(
      scopes: <String>['email'],
      clientId: client_id,
    );

    if (Platform.isAndroid) {
      _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
        setState(() {
          _currentUser = account;
        });
        loginGoogle(account, client_id, context);
      });
      _googleSignIn.signInSilently().then((value) {
        if (value != null) {
          setState(() {
            _currentUser = value;
          });
          loginGoogle(value, client_id, context);
        }
      });
    } else if (Platform.isIOS) {}
    super.initState();
  }

  /// Handles sign in and opens registration form on android when no account
  /// was found.
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  ///Default sign out
  Future<void> _handleSignOut() {
    if (Platform.isAndroid) {
      _googleSignIn.disconnect();
      logoutUser();
    }
  }

  void requestActivationEmail() {}

  Widget _buildSignInButtons() {
    double height = 44;
    if (_currentUser != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: _currentUser,
            ),
            title: Text(_currentUser.displayName ?? ''),
            subtitle: Text(_currentUser.email ?? ''),
          ),
          const Text("Signed in successfully."),
          ElevatedButton(
            child: const Text('SIGN OUT'),
            onPressed: _handleSignOut,
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: height,
            child: SizedBox.expand(
              child: CupertinoButton(
                onPressed: _handleSignIn,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                padding: EdgeInsets.zero,
                color: Colors.black,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(width: 1, color: colorTextDark)),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  height: height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/platform/google_logo.png"),
                        height: 28 / 44 * 38,
                        width: 28 / 44 * 38,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontSize: 44 * 0.43,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SignInWithAppleButton(
            onPressed: () async {
              loginApple(context);
            },
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasicPage(
      content: Container(
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildSignInButtons(),
        ),
      ),
    );
  }
}
