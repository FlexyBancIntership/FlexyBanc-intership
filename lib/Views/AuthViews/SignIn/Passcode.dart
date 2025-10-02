
import 'package:flexybank_intership/Views/AuthViews/SignIn/Biometric_login_screen.dart';
import 'package:flexybank_intership/Views/Home/home_screen.dart';
import 'package:flutter/material.dart';

class PasscodeScreen extends StatefulWidget {
  const PasscodeScreen({super.key});

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  String enteredPasscode = '';
  final String correctPasscode = '1234'; // Code à 4 chiffres par défaut

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

  void _checkPasscode() {
    if (enteredPasscode == correctPasscode) {
      // Code correct, naviguer vers HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      // Code incorrect, afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Code incorrect. Veuillez réessayer."),
          backgroundColor: _errorColor,
        ),
      );
      // Réinitialiser le code entré
      setState(() {
        enteredPasscode = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Column(
                  children: [
                    Image.asset(
                      'assets/img.png',
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                const SizedBox(height: 40),

                // Titre et sous-titre
                Text(
                  'Veuillez saisir votre code à 4 chiffres',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: _placeholderColor),
                ),
                const SizedBox(height: 30),

                // Points de code
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(4, (index) {
                    bool filled = index < enteredPasscode.length;
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: filled ? _primaryColor : Colors.transparent,
                        border: Border.all(color: _primaryColor, width: 2),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 40),

                // Clavier numérique
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(12, (index) {
                    if (index == 9) return _buildPasscodeButton('face_id');
                    if (index == 10) return _buildPasscodeButton('0');
                    if (index == 11) return _buildPasscodeButton('X');
                    return _buildPasscodeButton((index + 1).toString());
                  }),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPasscodeButton(String value) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (value == 'X') {
            if (enteredPasscode.isNotEmpty) {
              enteredPasscode = enteredPasscode.substring(
                0,
                enteredPasscode.length - 1,
              );
            }
          } else if (value == 'face_id') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BiometricLoginScreen()),
            );
          } else if (enteredPasscode.length < 4) {
            enteredPasscode += value;
            if (enteredPasscode.length == 4) {
              // Vérification du code quand 4 chiffres sont entrés
              _checkPasscode();
            }
          }
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: _primaryColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: _inputBackground, width: 1),
        ),
        padding: const EdgeInsets.all(10),
      ),
      child:
          value == 'X'
              ? Icon(Icons.backspace, size: 26, color: _primaryColor)
              : value == 'face_id'
              ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.face, size: 28, color: _primaryColor),
                  const SizedBox(height: 4),
                  Text(
                    'Face ID',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                      color: _primaryColor,
                    ),
                  ),
                ],
              )
              : Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  color: _primaryColor,
                ),
              ),
    );
  }
}
