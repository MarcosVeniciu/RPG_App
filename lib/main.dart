import 'package:flutter/material.dart';
import 'package:rpg_app/views/chat_screen_view.dart';
import 'package:rpg_app/views/instructions_screen_view.dart';
import 'package:rpg_app/views/main_screen_view.dart';
import 'package:rpg_app/views/rating_screen_view.dart';
import 'package:rpg_app/views/subscription_screen_view.dart';

void main() {
  // TODO: Add necessary setup here (e.g., ProviderScope, initializations)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RPG App',
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const MainScreenView());
          case '/chat':
            final args = settings.arguments as String? ?? 'default_id';
            return MaterialPageRoute(
              builder: (_) => ChatScreenView(adventureId: args),
            );
          case '/instructions':
            return MaterialPageRoute(builder: (_) => const InstructionsScreenView());
          case '/rating':
            final args = settings.arguments as Map<String, String>? ?? {
              'adventureId': 'default_id',
              'adventureTitle': 'Adventure'
            };
            return MaterialPageRoute(
              builder: (_) => RatingScreenView(
                adventureId: args['adventureId']!,
                adventureTitle: args['adventureTitle']!,
              ),
            );
          case '/subscription':
            return MaterialPageRoute(builder: (_) => const SubscriptionScreenView());
          default:
            return MaterialPageRoute(builder: (_) => const MainScreenView());
        }
      },
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark, // Dark theme as requested
        primarySwatch: Colors.blue, // Base color
        scaffoldBackgroundColor: Colors.black, // Dark background

        // Define the default font family.
        // fontFamily: 'YourSciFiFont', // TODO: Add custom sci-fi font later

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          // TODO: Define specific text styles with neon accents if needed
          bodyMedium: TextStyle(color: Colors.white), // Example high contrast
        ),

        // Define button themes, card themes, etc. with neon accents
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, // Text color
            backgroundColor: Colors.blue.shade800, // Button background
            side: BorderSide(color: Colors.blue.shade300), // Neon border
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.grey.shade900,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue.shade400, width: 1), // Neon border
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        // TODO: Add other theme customizations (app bar, input fields, etc.)
      ),
      home: const MainScreenView(), // Main screen as initial route
    );
  }
}

// Placeholder screen until MainScreen is created
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RPG App - Loading...'),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}