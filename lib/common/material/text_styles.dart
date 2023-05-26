import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle regular(
      {Color color = Colors.black,
      double fontSize = 14.0,
      TextOverflow? textOverFlow,
      double? height}) {
    return TextStyle(
        height: height,
        color: color,
        fontFamily: 'Roboto',
        overflow: textOverFlow ?? TextOverflow.visible,
        fontWeight: FontWeight.w400,
        fontSize: fontSize);
  }

  static TextStyle bold({
    Color color = Colors.black,
    double fontSize = 14.0,
    double? height,
  }) =>
      TextStyle(
          height: height,
          color: color,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
          fontSize: fontSize);

  static TextStyle medium(
          {Color color = Colors.black,
          double fontSize = 14.0,
          TextOverflow? textOverFlow,
          double? height}) =>
      TextStyle(
          height: height,
          color: color,
          overflow: textOverFlow ?? TextOverflow.visible,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          fontSize: fontSize);
}
