import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/ui/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NextGeir',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Colors.teal, // Set your primary color
          secondary: Colors.orange, // Set your secondary color
        ),
        scaffoldBackgroundColor: Colors.grey[900], // Set your background color

        appBarTheme: const AppBarTheme(
          color: Colors.teal, // Set app bar color
          iconTheme:
          IconThemeData(color: Colors.white), // Set app bar icon color
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.teal, // Set default button color
          textTheme: ButtonTextTheme.primary, // Set button text color
        ),
      ),
      home: const SplashScreen(),
    );
  }
}