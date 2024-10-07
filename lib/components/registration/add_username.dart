import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/sizing.dart';
import 'package:greentrition/database/db_adapter.dart';
import 'package:greentrition/views/basic_page.dart';

class AddUsername extends StatefulWidget {
  final String email;

  const AddUsername({Key key, this.email}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddUsernameState();
  }
}

class AddUsernameState extends State<AddUsername> {
  bool _nameAvailable = false;
  String newName;

  @override
  Widget build(BuildContext context) {
    return BasicPage(
        content: SafeArea(
            child: CustomScrollView(slivers: [
      SliverList(
          delegate: SliverChildListDelegate([
        Padding(
            padding: padding_all,
            child: Column(children: [
              SizedBox(
                height: 70,
              ),
              Text(
                "Nutzernamen anlegen",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Dein Account braucht noch einen Benutzernamen.\n"
                "Such Dir einen Namen aus, der anderen Nutzern angezeigt werden soll und "
                "schliesse die Registrierung ab",
                style: GoogleFonts.quicksand(),
              ),
              SizedBox(
                height: 30,
              ),
              TextField(
                obscureText: false,
                onChanged: (name) {
                  newName = name;
                  print(newName);
                  if (name.length < 4) {
                    setState(() {
                      _nameAvailable = false;
                    });
                  } else {
                    AppDb.isNameAvailable(name).then((value) {
                      setState(() {
                        _nameAvailable = value;
                      });
                    });
                  }
                },
                decoration: InputDecoration(
                    suffix: _nameAvailable
                        ? Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.close_outlined,
                            color: colorRed,
                          ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorGreen)),
                    border: OutlineInputBorder(),
                    labelText: "MusternutzerIn",
                    labelStyle: TextStyle(color: colorTextDark)),
              ),
              Center(
                heightFactor: 7,
                child: OutlinedButton(
                  // highlightElevation: 5,
                  // highlightedBorderColor: colorGreen,
                  // highlightColor: colorGreen.withOpacity(0.4),
                  // borderSide: BorderSide(color: colorGreen),
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    if (_nameAvailable) {
                      AppDb.setInitialUsername(newName, this.widget.email)
                          .then((value) {
                        if (value == true) {
                          Fluttertoast.showToast(
                              msg: "Account erfolgreich erstellt!");
                          Navigator.pop(context, [true, newName]);
                        }
                      });
                    }
                  },
                  child: Text("Account erstellen"),
                ),
              )
            ]))
      ]))
    ])));
  }
}
