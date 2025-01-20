import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newsapp/pages/home_page.dart';

const apiKey = 'AIzaSyDXUQno3CD9-9tJHrIttZJUoMci1o5V84Q';
void main() {
  Gemini.init(apiKey: apiKey);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.purple, // Light theme with purple shade
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 194, 80, 215), // AppBar color for light theme
          titleTextStyle:  TextStyle(color: Colors.white), // Title color
        ),
        textTheme: const TextTheme(
          displayMedium: TextStyle(color: Colors.black), // Default text color
          displayLarge: TextStyle(color: Colors.grey),  // Secondary text color
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple, // Dark theme with purple shade
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple[700], // Darker shade for AppBar
          titleTextStyle: const TextStyle(color: Colors.white), // Title color
        ),
        textTheme: const TextTheme(
          displayMedium: TextStyle(color: Colors.white), // Default text color in dark theme
          displayLarge: TextStyle(color: Colors.grey),  // Secondary text color
        ),
      ),
      themeMode: ThemeMode.system, // Automatically switch between themes based on system settings
      home: const HomePage(),
    );
  }
}
