import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:greentrition/classes/product.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/sizing.dart';
import 'package:greentrition/database/db_adapter.dart';
import 'package:greentrition/views/basic_page.dart';

class ChangeRequest extends StatefulWidget {
  final Product product;

  const ChangeRequest({Key key, this.product}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ChangeRequestState();
  }
}

class ChangeRequestState extends State<ChangeRequest> {
  final Map<int, String> valueToChangeOption = {
    1: "Hersteller & Produktname",
    2: "Inhaltsstoffe",
    3: "Unverträglichkeiten/Ernährung",
    4: "Sonstiges"
  };
  final TextEditingController _textEditingController = TextEditingController();
  // default Inhaltsstoffe
  int _value = 2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BasicPage(
        content: Container(
          height: double.infinity,
          color: colorModalBackground,
          child: SafeArea(
            child: CupertinoScrollbar(
              thickness: 3.0,
              child: SingleChildScrollView(
                child: Padding(
                  padding: padding_left_and_right,
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Center(child: Icon(Icons.drag_handle)),
                        Center(
                          child: Text(
                            "Produktinformationen ändern/vorschlagen",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(this.widget.product.brands +
                            this.widget.product.product_name +
                            "; Barcode:" +
                            this.widget.product.code),
                        SizedBox(
                          height: 10,
                        ),
                        Text("Änderung auswählen"),
                        DropdownButton(
                            value: _value,
                            items: [
                              DropdownMenuItem(
                                child: Text("Hersteller & Produktname"),
                                value: 1,
                              ),
                              DropdownMenuItem(
                                child: Text("Inhaltsstoffe"),
                                value: 2,
                              ),
                              DropdownMenuItem(
                                  child: Text("Unverträglichkeiten/Ernährung"),
                                  value: 3),
                              DropdownMenuItem(child: Text("Sonstiges"), value: 4)
                            ],
                            onChanged: (value) {
                              setState(() {
                                _value = value;
                              });
                            }),
                        TextFormField(
                          controller: _textEditingController,
                          maxLines: 5,
                          style: TextStyle(decorationColor: Colors.black),
                          decoration: InputDecoration(
                              hintText: "Beschreibe Dein Anliegen..."),
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey[600])),
                            onPressed: () {
                              FirebaseDbAdapter().db.requestChangeExistingProduct(
                                  this.widget.product,
                                  _textEditingController.value.text,
                                  DateTime.now().millisecondsSinceEpoch.toString(),
                                  valueToChangeOption[_value]);
                              Fluttertoast.showToast(
                                msg:
                                    "Vielen Dank! Deine Informationen wurden übermittelt.",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 3,
                                backgroundColor: Colors.grey[600],
                                textColor: Colors.white,
                                fontSize: 15.0,
                              );
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Absenden",
                              style: TextStyle(fontSize: 16),
                            )),
                        SizedBox(
                          height: 300,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
