import 'package:flutter/material.dart';

const TextStyle style = TextStyle(fontSize: 17.0);
const TextStyle style2 = TextStyle(color: Colors.white);

extension ColorPalette on Colors {
  static const Color primary = Color(0xff019d3c);
  static const Color primaryDark = Color(0xff014f1e);
  static const Color primaryLight = Color(0xff67c48a);
  static const Color red = Color(0xffe63946);
  static const Color lightGrey = Color(0xfff7f9f7);
  static const Color black = Color(0xff111111);
  static const Color blue = Color(0xff3f7cac);
  static const Color yellow = Color(0xffffda22);
  static const Color lightPink = Color(0xffd87cac);
  static const Color white = Color(0xffffffff);
  static const Color grey = Color(0xffe2e2e2);
}

extension Sizing on SizedBox {
  static const SizedBox small = SizedBox(height: 5.0);
  static const SizedBox medium = SizedBox(height: 10.0);
  static const SizedBox fab = SizedBox(height: 16.0);
  static const SizedBox big = SizedBox(height: 20.0);
}
//Sizes

extension Spacing on EdgeInsets {
  static const EdgeInsets small = EdgeInsets.all(5);
  static const EdgeInsets medium = EdgeInsets.all(10);
  static const EdgeInsets fab = EdgeInsets.all(16);
  static const EdgeInsets big = EdgeInsets.all(20);
}