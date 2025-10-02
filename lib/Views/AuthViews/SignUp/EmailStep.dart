import 'package:flutter/material.dart';

class EmailStep extends StatelessWidget {
final TextEditingController emailController;
final String? emailError;
final bool isEmailValid;
final VoidCallback onNext;
final VoidCallback onGoogleSignIn;
final Animation<double> buttonScaleAnimation;
final Function(String) onSubmitted;
final int currentStep;
final int totalSteps;
final VoidCallback onBack;

const EmailStep({
super.key,
required this.emailController,
required this.emailError,
required this.isEmailValid,
required this.onNext,
required this.onGoogleSignIn,
required this.buttonScaleAnimation,
required this.onSubmitted,
required this.currentStep,
required this.totalSteps,
required this.onBack,
});

// Color constants (consistent with other screens)
static const Color _primaryColor = Color(0xFF0B356A);
static const Color _accentColor = Color(0xFF97DAFF);
static const Color _backgroundColor = Color(0xFFFFFFFF);
static const Color _textColor = Colors.black;
static const Color _placeholderColor = Color(0xFF8DA4C2);
static const Color _inputBackground = Color(0xFFE8F2FF);
static const double _buttonHeight = 54.0;

/// Builds input decoration for text fields
InputDecoration _buildInputDecoration({
required String labelText,
required IconData prefixIcon,
String? errorText,
}) {
return InputDecoration(
labelText: labelText,
labelStyle: TextStyle(
color: _placeholderColor,
fontFamily: 'Poppins',
fontSize: 15,
fontWeight: FontWeight.w500,
),
prefixIcon: Icon(prefixIcon, color: _placeholderColor, size: 24),
filled: true,
fillColor: _inputBackground,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(16),
borderSide: BorderSide.none,
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(16),
borderSide: const BorderSide(color: _accentColor, width: 2.5),
),
errorBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(16),
borderSide: const BorderSide(color: Colors.red, width: 2),
),
focusedErrorBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(16),
borderSide: const BorderSide(color: Colors.red, width: 2.5),
),
errorText: errorText,
errorMaxLines: 2,
contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
);
}

/// Builds a styled button with animations
Widget _buildButton({
required String text,
required Color textColor,
required Color borderColor,
required VoidCallback? onPressed,
IconData? prefixIcon,
}) {
return AnimatedBuilder(
animation: buttonScaleAnimation,
builder: (context, child) {
return Transform.scale(
scale: buttonScaleAnimation.value,
child: Container(
decoration: BoxDecoration(
color: Colors.transparent, // Always transparent background
border: Border.all(
color: borderColor,
width: 1,
),
borderRadius: BorderRadius.circular(16),
boxShadow: [
BoxShadow(
color: _primaryColor.withOpacity(0.15),
blurRadius: 20,
offset: const Offset(0, 8),
),
],
),
child: Material(
color: Colors.transparent,
child: InkWell(
onTap: onPressed,
borderRadius: BorderRadius.circular(16),
child: Container(
height: _buttonHeight,
alignment: Alignment.center,
child: Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
if (prefixIcon != null) ...[
Icon(prefixIcon, color: textColor, size: 22),
const SizedBox(width: 12),
],
Text(
text,
style: TextStyle(
fontFamily: 'Montserrat',
fontWeight: FontWeight.w700,
fontSize: 17,
color: textColor,
letterSpacing: 0.5,
),
),
],
),
),
),
),
),
);
},
);
}

/// Builds the "ou" divider
Widget _buildDivider() {
return Padding(
padding: const EdgeInsets.symmetric(vertical: 28),
child: Row(
children: [
Expanded(
child: Container(
height: 1.5,
decoration: BoxDecoration(
gradient: LinearGradient(
colors: [
_placeholderColor.withOpacity(0.1),
_placeholderColor.withOpacity(0.6),
_placeholderColor.withOpacity(0.1),
],
),
),
),
),
Padding(
padding: const EdgeInsets.symmetric(horizontal: 20),
child: Text(
'ou',
style: TextStyle(
fontFamily: 'Poppins',
fontSize: 16,
fontWeight: FontWeight.w600,
color: _placeholderColor,
),
),
),
Expanded(
child: Container(
height: 1.5,
decoration: BoxDecoration(
gradient: LinearGradient(
colors: [
_placeholderColor.withOpacity(0.1),
_placeholderColor.withOpacity(0.6),
_placeholderColor.withOpacity(0.1),
],
),
),
),
),
],
),
);
}

@override
Widget build(BuildContext context) {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Entrer votre email',
style: TextStyle(
fontFamily: 'Poppins',
fontSize: 32,
fontWeight: FontWeight.w800,
color: _textColor,
letterSpacing: -0.8,
),
),
const SizedBox(height: 18),
Text(
'Il faut entrer votre email pour améliorer votre sécurité',
style: TextStyle(
fontFamily: 'Poppins',
fontSize: 17,
fontWeight: FontWeight.w400,
color: _textColor.withOpacity(0.7),
height: 1.6,
),
),
const SizedBox(height: 40),
TextField(
controller: emailController,
decoration: _buildInputDecoration(
labelText: 'Votre email',
prefixIcon: Icons.email_outlined,
errorText: emailError,
),
style: const TextStyle(
color: _textColor,
fontFamily: 'Poppins',
fontSize: 17,
fontWeight: FontWeight.w500,
),
keyboardType: TextInputType.emailAddress,
autofillHints: const [AutofillHints.email],
textInputAction: TextInputAction.done,
onSubmitted: onSubmitted,
),
_buildDivider(),
_buildButton(
text: 'Connecter avec Google',
textColor: _primaryColor,
borderColor: _primaryColor,
prefixIcon: Icons.email,
onPressed: onGoogleSignIn,
),
const SizedBox(height: 240),
_buildButton(
text: 'Suivant',
textColor: isEmailValid ? _primaryColor : _placeholderColor,
borderColor: isEmailValid ? _primaryColor : _placeholderColor,
onPressed: isEmailValid ? onNext : null,
),
],
);
}
}
