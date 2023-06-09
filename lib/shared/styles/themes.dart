import 'package:flutter/material.dart';
import 'package:graduation_project/shared/styles/colors.dart';
import 'package:hexcolor/hexcolor.dart';

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

ThemeData lightTheme = ThemeData(
    primarySwatch: oceanBlue,
    timePickerTheme: TimePickerThemeData(
      hourMinuteTextColor: oceanBlue.shade800,
      dialHandColor: oceanBlue.shade800,
      dayPeriodTextColor: oceanBlue.shade800,
      entryModeIconColor: oceanBlue.shade800,
      padding: EdgeInsets.zero,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: oceanBlue[900],
      unselectedIconTheme: IconThemeData(color: HexColor("#0a0a0a")),
      selectedLabelStyle: TextStyle(color: oceanBlue),
      unselectedLabelStyle: TextStyle(color: HexColor("#0a0a0a")),
      elevation: 40.0,
    ),
    backgroundColor: oceanBlue.shade800,
    focusColor: oceanBlue.shade800,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      centerTitle: true,
      iconTheme: IconThemeData(color: HexColor("#0a0a0a")),
    ),
    textTheme: TextTheme(
        headlineSmall: TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w500,
          color: HexColor("#0a0a0a"),
        ),
        headlineLarge: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontFamily: 'OpenSans',
        ),
        bodyLarge: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontFamily: 'OpenSans',
        ),
        bodySmall: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: HexColor("#0a0a0a"),
        ),
        bodyMedium: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: HexColor("#0a0a0a"),
        ),
        titleMedium: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: oceanBlue.shade800,
        )),
    buttonTheme: ButtonThemeData(
      buttonColor: oceanBlue.shade800,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
          textStyle:
              MaterialStatePropertyAll(TextStyle(color: oceanBlue.shade800)),
          foregroundColor: MaterialStatePropertyAll(oceanBlue.shade800)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      modalBackgroundColor: Colors.white,
      modalElevation: 4.2,
      elevation: 4.2,
      modalBarrierColor: Colors.black.withOpacity(0.7),
    ),
    inputDecorationTheme: InputDecorationTheme(
        prefixIconColor: defaultColor,
        suffixIconColor: defaultColor,
        labelStyle: TextStyle(color: defaultColor),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: oceanBlue.shade800))),
    iconTheme: IconThemeData(
      color: HexColor("#0a0a0a"),
    ),
    fontFamily: 'OpenSans');
