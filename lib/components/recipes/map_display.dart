import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:greentrition/constants/fonts.dart';

class MapDisplay extends StatefulWidget {
  final Map<String, String> ingredientsPerPortion;
  final int portions;

  const MapDisplay({Key key, this.ingredientsPerPortion, this.portions})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => MapDisplayState();
}

class MapDisplayState extends State<MapDisplay> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: this.widget.ingredientsPerPortion.keys.length,
      itemBuilder: (context, index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(this.widget.ingredientsPerPortion.keys.elementAt(index),
                style: standardStyle),
            Text(
                this.widget.ingredientsPerPortion[
                    this.widget.ingredientsPerPortion.keys.elementAt(index)],
                style: standardStyle)
          ],
        );
      },
    );
  }
}
