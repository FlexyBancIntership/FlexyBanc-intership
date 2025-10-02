import 'package:flutter/material.dart';

class PhoneStep extends StatelessWidget {
final TextEditingController phoneController;
final String? phoneError;
final bool isPhoneValid;
final VoidCallback onNext;
final VoidCallback onCountrySelector;
final String selectedCountry;
final String selectedCountryCode;
final List<Map<String, String>> countries;
final Animation<double> buttonScaleAnimation;
final Function(String) onSubmitted;

const PhoneStep({
super.key,
required this.phoneController,
required this.phoneError,
required this.isPhoneValid,
required this.onNext,
required this.onCountrySelector,
required this.selectedCountry,
required this.selectedCountryCode,
required this.countries,
required this.buttonScaleAnimation,
required this.onSubmitted,
});

// Color constants (consistent with other screens)
static const Color _primaryColor = Color(0xFF0B356A);
static const Color _accentColor = Color(0xFF97DAFF);
static const Color _backgroundColor = Color(0xFFFFFFFF);
static const Color _textColor = Colors.black;
static const Color _placeholderColor = Color(0xFF8DA4C2);
static const Color _inputBackground = Color(0xFFE8F2FF);
static const double _buttonHeight = 54.0;

/// Builds input decoration for phone with country selector
InputDecoration _buildPhoneInputDecoration() {
return InputDecoration(
labelText: 'Numéro de téléphone',
labelStyle: TextStyle(
color: _placeholderColor,
fontFamily: 'Poppins',
fontSize: 15,
fontWeight: FontWeight.w500,
),
prefixIcon: GestureDetector(
onTap: onCountrySelector,
child: Container(
padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Text(
countries.firstWhere((c) => c['code'] == selectedCountry)['flag']!,
style: const TextStyle(fontSize: 20),
),
const SizedBox(width: 8),
Text(
selectedCountryCode,
style: TextStyle(
fontFamily: 'Poppins',
fontSize: 16,
fontWeight: FontWeight.w600,
color: _textColor,
),
),
const SizedBox(width: 4),
const Icon(Icons.arrow_drop_down, color: _placeholderColor),
],
),
),
),
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
errorText: phoneError,
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
child: Text(
text,
style: TextStyle(
fontFamily: 'Montserrat',
fontWeight: FontWeight.w700,
fontSize: 17,
color: textColor,
letterSpacing: 0.5,
),
),
),
),
),
),
);
},
);
}

@override
Widget build(BuildContext context) {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Entrer votre numéro',
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
'Il faut entrer votre numéro de téléphone pour améliorer votre sécurité',
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
controller: phoneController,
decoration: _buildPhoneInputDecoration(),
style: const TextStyle(
color: _textColor,
fontFamily: 'Poppins',
fontSize: 17,
fontWeight: FontWeight.w500,
),
keyboardType: TextInputType.phone,
autofillHints: const [AutofillHints.telephoneNumber],
textInputAction: TextInputAction.done,
onSubmitted: onSubmitted,
),
const SizedBox(height: 375),
_buildButton(
text: 'Suivant',
textColor: isPhoneValid ? _primaryColor : _placeholderColor,
borderColor: isPhoneValid ? _primaryColor : _placeholderColor,
onPressed: isPhoneValid ? onNext : null,
),
],
);
}
}
