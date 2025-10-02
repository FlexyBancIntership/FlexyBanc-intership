import 'package:flexybank_intership/Views/AuthViews/SignIn/Passcode.dart';
import 'package:flexybank_intership/Views/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricLoginScreen extends StatefulWidget {
  const BiometricLoginScreen({super.key});

  @override
  State<BiometricLoginScreen> createState() => _BiometricLoginScreenState();
}

class _BiometricLoginScreenState extends State<BiometricLoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;
  List<BiometricType> _availableBiometrics = [];
  String _biometricTypeText = 'Biométrie';
  IconData _biometricIcon = Icons.fingerprint;

  // Color constants
  static const Color _primaryColor = Color(0xFF16579D);
  static const Color _accentColor = Color(0xFF97DAFF);
  static const Color _inputBackground = Color(0xFFE8F2FF);
  static const Color _placeholderColor = Color(0xFF8DA4C2);
  static const Color _textColor = Color(0xFF1B1D4D);
  static const Color _darkBackground = Color(0xFF1C2526);
  static const Color _successColor = Color(0xFF4CAF50);
  static const Color _errorColor = Color(0xFFF44336);
  static const Color _goldAccent = Color(0xFFFFD700);
  static const Color _premiumGradientStart = Color(0xFF2C3E50);
  static const Color _premiumGradientEnd = Color(0xFF4A6741);

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      bool canCheck = await auth.canCheckBiometrics;
      List<BiometricType> available = await auth.getAvailableBiometrics();

      setState(() {
        _canCheckBiometrics = canCheck;
        _availableBiometrics = available;

        // Détermine le type de biométrie à afficher
        if (available.contains(BiometricType.face)) {
          _biometricTypeText = 'Vérification Faciale';
          _biometricIcon = Icons.face;
        } else if (available.contains(BiometricType.fingerprint)) {
          _biometricTypeText = 'Empreinte Digitale';
          _biometricIcon = Icons.fingerprint;
        } else if (available.contains(BiometricType.iris)) {
          _biometricTypeText = 'Scan de l\'Iris';
          _biometricIcon = Icons.remove_red_eye;
        }
      });

      print("Biométrie disponible: $canCheck, types: $available");
    } catch (e) {
      print("Erreur lors de la vérification biométrique: $e");
    }
  }

  Future<void> _authenticate() async {
    if (!_canCheckBiometrics || _availableBiometrics.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Aucune méthode biométrique disponible."),
          backgroundColor: _errorColor,
        ),
      );
      return;
    }

    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authentifiez-vous pour accéder à FlexiBanQ',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Authentification échouée."),
            backgroundColor: _errorColor,
          ),
        );
      }
    } catch (e) {
      print("Erreur d'authentification: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Erreur lors de l'authentification."),
          backgroundColor: _errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/img.png', height: 80, fit: BoxFit.contain),
                const SizedBox(height: 40),
                Text(
                  'Bienvenue à FlexiBanQ',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Veuillez utiliser vos identifiants biométriques ou vous connecter',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: _placeholderColor),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _inputBackground,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(_biometricIcon, size: 60, color: _primaryColor),
                      const SizedBox(height: 10),
                      Text(
                        _biometricTypeText,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: _primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed:
                      _canCheckBiometrics && _availableBiometrics.isNotEmpty
                          ? _authenticate
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(250, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    _canCheckBiometrics && _availableBiometrics.isNotEmpty
                        ? 'Se connecter avec $_biometricTypeText'
                        : 'Biométrie non disponible',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PasscodeScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(250, 50),
                    side: BorderSide(color: _primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Se connecter via PassCode',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Affichage des types de biométrie disponibles (pour debug)
                if (_availableBiometrics.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Types disponibles: ${_availableBiometrics.map((e) => e.name).join(', ')}',
                      style: TextStyle(fontSize: 12, color: _placeholderColor),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
