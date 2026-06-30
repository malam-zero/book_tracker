import 'package:book_tracker/pages/book_details.dart';
import 'package:book_tracker/pages/favourites_screen.dart';
import 'package:book_tracker/pages/home.dart';
import 'package:book_tracker/pages/home_screen.dart';
import 'package:book_tracker/pages/saved_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  runApp(const BookTrackerApp());
}

class BookTrackerApp extends StatelessWidget {
  const BookTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2D5A27),
          primary: const Color(0xFF2D5A27),
          surface: const Color(0xFFFAEDCD),
          surfaceContainerHighest: const Color(0xFFE9DCC9),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAEDCD),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2D5A27),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/home': (context) => HomeScreen(),
        '/details': (context) => BookDetailsScreen(),
        '/favourites': (context) => FavouritesScreen(),
        '/saved': (context) => SavedScreen(),
      },
      home: MyHomePage(),
    );
  }
}
