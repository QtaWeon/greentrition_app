import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:greentrition/components/registration/sign_in_buttons.dart';
import 'package:greentrition/constants/fonts.dart';
import 'package:greentrition/views/basic_page.dart';

class RegisterForFeature extends StatefulWidget {
  final VoidCallback login_key;

  const RegisterForFeature({Key key, this.login_key})
      : super(key: key);

  @override
  RegisterForFeatureState createState() => RegisterForFeatureState();
}

class RegisterForFeatureState extends State<RegisterForFeature> {
  @override
  void initState() {
    super.initState();
  }

  void updateKey() {
    this.widget.login_key();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BasicPage(
      content: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Login",
                style: headingFont,
              ),
              SizedBox(height: 100,),
              SignInButtons(
                  callback: updateKey,
                ),


            ],
          )),
      showBackButton: true,
    );
  }
}
