import 'package:jivanand/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';

class AppTheme {
  //
  AppTheme._();

  static ThemeData lightTheme({Color? color}) => ThemeData(
    useMaterial3: true,
    primarySwatch: createMaterialColor(color ?? primaryColor),
    primaryColor: color ?? primaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: color ?? primaryColor, outlineVariant: borderColor),
    scaffoldBackgroundColor: Colors.white,
    fontFamily: GoogleFonts.lexend().fontFamily,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Colors.white),
    iconTheme: const IconThemeData(color: appTextSecondaryColor),
    // textTheme: GoogleFonts.workSansTextTheme(),
    textTheme: GoogleFonts.lexendTextTheme(),
    dialogBackgroundColor: Colors.white,
    unselectedWidgetColor: Colors.black,
    dividerColor: borderColor,
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
      backgroundColor: Colors.white,
    ),
    cardColor: cardColors,
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: color ?? primaryColor),
    appBarTheme: const AppBarTheme(systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light)),
    dialogTheme: DialogTheme(shape: dialogShape()),
    navigationBarTheme: NavigationBarThemeData(labelTextStyle: WidgetStateProperty.all(primaryTextStyle(size: 10))),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );

  static ThemeData darkTheme({Color? color}) => ThemeData(
    useMaterial3: true,
    primarySwatch: createMaterialColor(color ?? primaryColor),
    primaryColor: color ?? primaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: color ?? primaryColor, outlineVariant: borderColor),
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
    ),
    scaffoldBackgroundColor: scaffoldColorDark,
    fontFamily: GoogleFonts.lexend().fontFamily,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: scaffoldSecondaryDark),
    iconTheme: const IconThemeData(color: Colors.white),
    textTheme: GoogleFonts.lexendTextTheme(),
    dialogBackgroundColor: scaffoldSecondaryDark,
    unselectedWidgetColor: Colors.white60,
    bottomSheetTheme: BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
      backgroundColor: scaffoldSecondaryDark,
    ),
    dividerColor: dividerDarkColor,
    floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: color ?? primaryColor),
    cardColor: scaffoldSecondaryDark,
    dialogTheme: DialogTheme(shape: dialogShape()),
    navigationBarTheme: NavigationBarThemeData(labelTextStyle: WidgetStateProperty.all(primaryTextStyle(size: 10, color: Colors.white))),
  ).copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
