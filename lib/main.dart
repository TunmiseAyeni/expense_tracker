import 'package:expense_tracker/expenses.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

var kColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 96, 59, 181));
var kDarkColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 5, 99, 125),
  brightness: Brightness
      .dark, //this helps in setting the brightness of the theme to dark
);

void main() {
  //Note:this is how to set the app to run in portrait mode
//we move the runapp method into the thhen method of the setPreferredOrientations method to ensure that the app runs in portrait mode
// the setPreferred orientations is used to set a list of orientations that the app can be displayed in
// WidgetsFlutterBinding.ensureInitialized(); //this is used to ensure that the widgets are initialized before the app runs
//   SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//   ]).then((value) =>
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      //for the dark theme, we are using the copyWith method to copy the default dark theme and then we are overriding the colorScheme property
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: kDarkColorScheme,
        cardTheme: const CardTheme().copyWith(
          color: kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
            foregroundColor: kDarkColorScheme.onPrimaryContainer,
          ),
        ),
      ),
      //for the light theme, we are using the copyWith method to copy the default theme and then we are overriding the colorScheme, appBarTheme, cardTheme, elevatedButtonTheme and textTheme properties
      theme: ThemeData().copyWith(
        // scaffoldBackgroundColor: const Color.fromARGB(255, 243, 201, 250),
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: kColorScheme.onPrimaryContainer,
          foregroundColor: kColorScheme.primaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kColorScheme.primaryContainer,
          ),
        ),
        textTheme: ThemeData().textTheme.copyWith(
                titleLarge: TextStyle(
              fontWeight: FontWeight.bold,
              color: kColorScheme.onSecondaryContainer,
              // fontSize: 12,
            )),
      ),
      // themeMode: ThemeMode.system, //this is the default
      home: const Expenses(),
    ),
  );
  // );
}
