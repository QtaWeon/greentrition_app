import 'package:flutter/cupertino.dart';
import 'colors.dart';

const LinearGradient backgroundGradient = LinearGradient(
    colors: [backgroundColorStart, backgroundColorEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.4, 0.8]);
