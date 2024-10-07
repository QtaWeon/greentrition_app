import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:greentrition/classes/product.dart';
import 'package:greentrition/components/product_registration/product_scanner.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/fonts.dart';
import 'package:greentrition/database/db_adapter.dart';
import 'package:greentrition/product_initialization/edeka.dart';
import 'package:greentrition/views/basic_page.dart';
import 'package:http/http.dart';

import 'barcode_scanner.dart';

class ProductRegistrationStepper extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProductRegistrationStepperState();
  }
}

class ProductRegistrationStepperState
    extends State<ProductRegistrationStepper> {
  TextEditingController controller = TextEditingController();
  int currentStep = 0;
  final int stepperSize = 5;
  XFile productPicture;
  XFile ingredientsPicture;
  List<String> ingredients = [];
  String brands = "";
  String productName = "";
  String barcode = "";

  @override
  void initState() {
    super.initState();
  }

  void next() {
    if (currentStep + 1 == stepperSize) {
      Fluttertoast.showToast(
        msg: "Deine Daten wurden übermittelt. Danke für Deine Unterstützung!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: colorTextDark,
        textColor: Colors.white,
        fontSize: 15.0,
      );
    }
    currentStep + 1 != stepperSize
        ? goTo(currentStep + 1)
        : setState(() => Navigator.pop(context));
  }

  void goTo(int step) {
    setState(() {
      currentStep = step;
    });
  }

  void cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasicPage(
      content: Material(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  child: SafeArea(
                      child: Text("Produkt hinzufügen", style: titleFont))),
              Flexible(
                child: CupertinoScrollbar(
                  thickness: 3.0,
                  child: Stepper(
                    type: StepperType.vertical,
                    controlsBuilder: (context, ControlsDetails details) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            currentStep > 0
                                ? OutlinedButton(
                                    // color: colorGreen,
                                    onPressed: details.onStepCancel,
                                    child: Text("Zurück"),
                                  )
                                : SizedBox(
                                    height: 0,
                                  ),
                            currentStep == 0 || currentStep == 3
                                ? SizedBox(
                                    height: 0,
                                  )
                                : OutlinedButton(
                                    // color: colorGreen,
                                    onPressed: !(currentStep + 1 == stepperSize)
                                        ? details.onStepContinue
                                        : () {
                                            productPicture
                                                .readAsBytes()
                                                .then((bytes) {
                                              AppDb.uploadProductImage(
                                                  MultipartFile.fromBytes(
                                                      "image", bytes,
                                                      filename: "front.jpg"),
                                                  barcode);
                                            });
                                            ingredientsPicture
                                                .readAsBytes()
                                                .then((bytes) {
                                              AppDb.uploadProductImage(
                                                  MultipartFile.fromBytes(
                                                      "image", bytes,
                                                      filename: "back.jpg"),
                                                  barcode);
                                            });

                                            FirebaseDb().requestNewProduct(
                                                Product.fromStepper(
                                              brands,
                                              productName,
                                              barcode,
                                              ingredients,
                                            ));
                                            details.onStepContinue();
                                          },
                                    child: !(currentStep + 1 == stepperSize)
                                        ? Text("Weiter")
                                        : Text("Daten absenden"),
                                  )
                          ],
                        ),
                      );
                    },
                    steps: [
                      Step(
                        title: Text(
                            "Produktvorder- und Hinterseite(Inhaltsstoffe) fotografieren"),
                        content: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                Text(
                                  "Achte darauf, dass der Produktname und die Inhaltsstoffe genau zu erkennen sind. "
                                  "Das macht es uns einfacher sie später zu erkennen.",
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextButton(
                                  child: Text("Start"),
                                  // color: Colors.green.withOpacity(0.7),
                                  onPressed: () async {
                                    List<dynamic> retVals =
                                        await Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    Camera()));
                                    setState(() {
                                      productPicture = retVals[0];
                                      ingredientsPicture = retVals[1];
                                      productName = retVals[2];
                                      ingredients =
                                          readIngredients(retVals[3])[0];
                                    });
                                    next();
                                  },
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(10)),
                                )
                              ],
                            )),
                      ),
                      Step(
                        title: Text("Produktname und Hersteller"),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //TODO CHANGE
                            // Align(
                            //     alignment: Alignment.centerLeft,
                            //     child: Text(
                            //       "Sind die Angaben korrekt?",
                            //       textAlign: TextAlign.left,
                            //     )),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Hersteller angeben",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 17),
                            ),
                            TextFormField(
                              initialValue: brands,
                              onChanged: (value) {
                                this.brands = value;
                              },
                              decoration: InputDecoration(
                                  hintText: "Hersteller angeben"),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Produktnamen angeben",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 17),
                            ),
                            TextFormField(
                              initialValue: productName,
                              onChanged: (value) {
                                this.productName = value;
                              },
                              decoration: InputDecoration(
                                  hintText: "Produktnamen angeben"),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            productPicture == null
                                ? SizedBox(
                                    height: 0,
                                  )
                                : FutureBuilder(
                                    future: productPicture.readAsBytes(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Image.memory(snapshot.data);
                                      } else {
                                        return SizedBox(height: 0);
                                      }
                                    },
                                  ),
                            ingredientsPicture == null
                                ? SizedBox(
                                    height: 100,
                                  )
                                : FutureBuilder(
                                    future: ingredientsPicture.readAsBytes(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Image.memory(snapshot.data);
                                      } else {
                                        return SizedBox(height: 0);
                                      }
                                    },
                                  ),
                          ],
                        ),
                      ),
                      Step(
                          title: Text("Inhaltsstoffe"),
                          content: Column(
                            children: [
                              //TODO CHANGE
                              // Text(
                              //   "Erkannte Inhaltsstoffe",
                              //   textAlign: TextAlign.left,
                              //   style: TextStyle(fontSize: 17),
                              // ),
                              ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    thickness: 1,
                                  );
                                },
                                shrinkWrap: true,
                                itemCount: ingredients.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(ingredients[index]),
                                    trailing: IconButton(
                                      icon: Icon(Icons.cancel),
                                      onPressed: () {
                                        setState(() {
                                          ingredients.removeAt(index);
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                              TextFormField(
                                controller: controller,
                                style: TextStyle(color: colorGreen),
                                onFieldSubmitted: (value) {
                                  if (value.length > 0) {
                                    setState(() {
                                      this.ingredients.add(value);
                                    });
                                  }
                                  controller.text = "";
                                },
                                maxLines: 1,
                                cursorColor: colorGreen,
                                decoration: InputDecoration(
                                    hintText: "Inhaltsstoff hinzufügen",
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: colorGreen)),
                                    suffix: IconButton(
                                      onPressed: () {
                                        if (controller.text.length > 0) {
                                          setState(() {
                                            this
                                                .ingredients
                                                .add(controller.text);
                                          });
                                        }
                                        controller.text = "";
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        color: colorGreen,
                                      ),
                                    )),
                              )
                            ],
                          )),
                      Step(
                        title: Text("Barcode"),
                        content: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                Text(
                                  "Scanne den Barcode des Produktes",
                                  textAlign: TextAlign.left,
                                ),
                                TextButton(
                                  onPressed: () async {
                                    this.barcode = await Navigator.of(context)
                                        .push(CupertinoPageRoute(
                                      builder: (context) => MyBarcodeScanner(),
                                    ));
                                    if (this.barcode != null &&
                                        this.barcode.length > 0) {
                                      next();
                                    }
                                  },
                                  child: Text("Scan"),
                                  // color: Colors.green.withOpacity(0.7),
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(10)),
                                )
                              ],
                            )),
                      ),
                      Step(
                        title: Text("Übersicht"),
                        content: Column(
                          children: [
                            Table(border: TableBorder.all(), children: [
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Hersteller"),
                                ),
                                Container(child: Text(brands))
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Produktname"),
                                ),
                                Text(productName)
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Inhaltsstoffe"),
                                ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: ingredients.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(ingredients[index]),
                                    );
                                  },
                                )
                              ]),
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Barcode"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(barcode),
                                )
                              ])
                            ]),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Du kannst deine Daten nun absenden!",
                                  textAlign: TextAlign.left,
                                )),
                          ],
                        ),
                      )
                    ],
                    currentStep: currentStep,
                    onStepCancel: cancel,
                    onStepContinue: next,
                    // onStepTapped: (step) => goTo(step),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
