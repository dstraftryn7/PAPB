import 'package:flutter/material.dart';

import 'home.dart';
import 'login.dart';
import 'profile.dart';
import 'register.dart';

void main() {
  runApp(const UTaskApp());
}

class UTaskApp extends StatelessWidget {
  const UTaskApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'U-TASK',
      theme: ThemeData(
        primarySwatch:
            generateMaterialColor(const Color.fromARGB(255, 202, 172, 205)),
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const UTaskHomePage(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}

MaterialColor generateMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (var i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  return MaterialColor(color.value, swatch);
}
