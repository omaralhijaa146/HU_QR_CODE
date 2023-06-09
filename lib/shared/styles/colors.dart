import 'package:flutter/material.dart';

Map<int, Color> mediumSlateBlueCM = {
  50: Color.fromRGBO(123, 131, 235, .1),
  100: Color.fromRGBO(123, 131, 235, .2),
  200: Color.fromRGBO(123, 131, 235, .3),
  300: Color.fromRGBO(123, 131, 235, .4),
  400: Color.fromRGBO(123, 131, 235, .5),
  500: Color.fromRGBO(123, 131, 235, .6),
  600: Color.fromRGBO(123, 131, 235, .7),
  700: Color.fromRGBO(123, 131, 235, .8),
  800: Color.fromRGBO(123, 131, 235, .9),
  900: Color.fromRGBO(123, 131, 235, 1),
};

Map<int, Color> oceanBlueCM = {
  50: Color.fromRGBO(70, 78, 184, .1),
  100: Color.fromRGBO(70, 78, 184, .2),
  200: Color.fromRGBO(70, 78, 184, .3),
  300: Color.fromRGBO(70, 78, 184, .4),
  400: Color.fromRGBO(70, 78, 184, .5),
  500: Color.fromRGBO(70, 78, 184, .6),
  600: Color.fromRGBO(70, 78, 184, .7),
  700: Color.fromRGBO(70, 78, 184, .8),
  800: Color.fromRGBO(70, 78, 184, .9),
  900: Color.fromRGBO(70, 78, 184, 1),
};

Map<int, Color> irisCM = {
  50: Color.fromRGBO(80, 90, 201, .1),
  100: Color.fromRGBO(80, 90, 201, .2),
  200: Color.fromRGBO(80, 90, 201, .3),
  300: Color.fromRGBO(80, 90, 201, .4),
  400: Color.fromRGBO(80, 90, 201, .5),
  500: Color.fromRGBO(80, 90, 201, .6),
  600: Color.fromRGBO(80, 90, 201, .7),
  700: Color.fromRGBO(80, 90, 201, .8),
  800: Color.fromRGBO(80, 90, 201, .9),
  900: Color.fromRGBO(80, 90, 201, 1),
};
MaterialColor oceanBlue = MaterialColor(0x464EB8, oceanBlueCM);
MaterialColor mediumSlateBlue = MaterialColor(0x7B83EB, mediumSlateBlueCM);
MaterialColor iris = MaterialColor(0x505AC9, irisCM);
Color defaultColor = oceanBlue.shade800;
