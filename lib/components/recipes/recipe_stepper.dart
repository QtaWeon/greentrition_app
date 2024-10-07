import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greentrition/constants/colors.dart';
import 'package:greentrition/constants/fonts.dart';
import 'package:greentrition/constants/sizing.dart';

class RecipeStepper extends StatefulWidget {
  final List<String> steps;
  final String title;

  const RecipeStepper({Key key, this.steps, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RecipeStepperState();
  }
}

class RecipeStepperState extends State<RecipeStepper> {
  List<Step> steps;
  int currentStep = 0;

  @override
  void initState() {
    steps = [];
    this.widget.steps.forEach((element) {
      steps.add(Step(
        title: Text("Zutaten"),
        content: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              element,
              textAlign: TextAlign.left,
              style: standardStyle,
            )),
      ));
    });
    super.initState();
  }

  void next() {
    currentStep + 1 != steps.length
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
    return Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: padding_all,
            child: Text(this.widget.title + " zubereiten", style: titleFont),
          ),
          Stepper(
            controlsBuilder: (context, ControlsDetails details) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      // color: colorGreen,
                      onPressed: details.onStepContinue,
                      child: !(currentStep + 1 == steps.length)
                          ? Text("Weiter")
                          : Text("Fertig"),
                    )
                  ],
                ),
              );
            },
            steps: this.steps,
            currentStep: currentStep,
            onStepCancel: cancel,
            onStepContinue: next,
            onStepTapped: (step) => goTo(step),
          ),
        ],
      ),
    );
  }
}
