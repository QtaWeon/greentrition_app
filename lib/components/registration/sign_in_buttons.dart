import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/functions/login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInButtons extends StatefulWidget {
  final VoidCallback callback;

  const SignInButtons({Key key, this.callback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignInButtonsState();
  }
}

class SignInButtonsState extends State<SignInButtons> {
  //currentUser is not used
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
          "95899471867-4ass6jfkm4n7al64js7v04pl2cl42loq.apps.googleusercontent.com";
    } else {
      client_id =
          "95899471867-52092reo17gp2vl1h88k6q29v92geuu5.apps.googleusercontent.com";
    }
    _googleSignIn = GoogleSignIn(
      scopes: <String>['email'],
      //clientId: client_id,
    );

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      loginGoogle(account, client_id, context);
      this.widget.callback();
      /*_googleSignIn.signInSilently().then((value) {
        if (value != null) {
          setState(() {
            _currentUser = value;
          });
          loginGoogle(value, client_id);
        }
      });*/
    });
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

  @override
  Widget build(BuildContext context) {
    double height = 44;
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
            this.widget.callback();
          },
        ),
        // SizedBox(
        //   height: 10,
        // ),
        // SizedBox(
        //   child: OutlineButton(
        //     child: Text("Login mit Testaccount"),
        //     onPressed: () {
        //       setUsername("TestNutzerIn");
        //       setPassword("anonym");
        //       Authorization().authorize();
        //       this.widget.callback();
        //     },
        //   ),
        // )
      ],
    );
  }
}
