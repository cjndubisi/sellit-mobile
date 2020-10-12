//Styles
import 'package:flutter/material.dart';

final TextStyle style = TextStyle(fontSize: 17.0);
final TextStyle style2 = TextStyle(color: colorWhite);

//Colors
final Color colorPrimary = Color(0xff019d3c);
final Color colorPrimaryDark = Color(0xff014f1e);
final Color colorPrimaryLight = Color(0xff67c48a);
final Color colorRed = Color(0xffe63946);
final Color colorWhite = Colors.white;
final Color colorLightGrey = Color(0xfff7f9f7);
final Color colorGrey = Colors.grey;
final Color colorBlack = Color(0xff111111);
final Color colorBlue = Color(0xff3f7cac);
final Color colorYellow = Color(0xffffda22);
final Color colorLightPink = Color(0xffd87cac);

//Widget
final Widget stickyInternetWidget = Container(
  alignment: Alignment.topCenter,
  padding: smallSpacing,
  color: colorRed,
  child: Text(
    "Internet connection error...Please check your network",
    style: style.copyWith(color: colorWhite),
  ),
);

//Sizes
final SizedBox smallSize = SizedBox(
  height: 5.0,
);
final SizedBox mediumSize = SizedBox(
  height: 10.0,
);
final SizedBox fabSize = SizedBox(
  height: 16.0,
);
final SizedBox bigSize = SizedBox(
  height: 20.0,
);

//Paddings
final EdgeInsets smallSpacing = EdgeInsets.all(5);
final EdgeInsets mediumSpacing = EdgeInsets.all(10);
final EdgeInsets fabSpacing = EdgeInsets.all(16);
final EdgeInsets bigSpacing = EdgeInsets.all(20);
