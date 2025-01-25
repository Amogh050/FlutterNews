import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newsapp/pages/home_page.dart';

Future<void> main() async {
  // Load the .env file before initializing the app
  await dotenv.load(fileName: ".env");

  // Check if OpenAI API Key is available
  final openAiApiKey = dotenv.env['OPENAI_API_KEY'];
  if (openAiApiKey == null || openAiApiKey.isEmpty) {
    throw Exception("OPENAI_API_KEY is missing or not set in the .env file.");
  }

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
        primarySwatch: Colors.purple,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 194, 80, 215),
          titleTextStyle: TextStyle(color: Colors.white),
        ),
        textTheme: const TextTheme(
          displayMedium: TextStyle(color: Colors.black),
          displayLarge: TextStyle(color: Colors.grey),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple[700],
          titleTextStyle: const TextStyle(color: Colors.white),
        ),
        textTheme: const TextTheme(
          displayMedium: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.grey),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
