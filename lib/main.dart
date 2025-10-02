import 'package:flexybank_intership/Views/AuthViews/Onboarding/OnboardingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for SystemChrome

/// Entry point of the Flexibanq app
void main() {
  // Ensure Flutter bindings are initialized before calling SystemChrome
  WidgetsFlutterBinding.ensureInitialized();

  // Set full-screen immersive mode
  try {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  } catch (e) {
    print('Erreur lors de la configuration du mode immersif : $e');
  }

  // Set preferred orientations to portrait
  try {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e) {
    print('Erreur lors de la configuration de l\'orientation : $e');
  }

  // Run the app
  runApp(const MyApp());
}

/// Root widget defining app theme and initial screen
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flexibanq',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF16579D)),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Color(0xFF1B1D4D),
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Color(0xFF1B1D4D),
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF1C2526),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF1B1D4D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16579D),
          brightness: Brightness.dark,
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Color(0xFFF5F7FA),
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Color(0xFFF5F7FA),
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF1C2526),
      ),
      home: const OnboardingScreen(), // Changed from SplashScreen to OnboardingScreen
    );
  }
}