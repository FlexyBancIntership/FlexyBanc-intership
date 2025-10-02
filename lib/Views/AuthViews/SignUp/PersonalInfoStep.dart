import 'dart:io';
import 'package:flutter/material.dart';

class PersonalInfoStep extends StatelessWidget {
final TextEditingController firstNameController;
final TextEditingController lastNameController;
final TextEditingController birthDateController;
final TextEditingController idCardController;
final String? firstNameError;
final String? lastNameError;
final String? birthDateError;
final String? idCardError;
final bool isPersonalInfoValid;
final File? idCardImage;
final VoidCallback onComplete;
final VoidCallback onSelectDate;
final VoidCallback onPickImage;
final Animation<double> buttonScaleAnimation;

const PersonalInfoStep({
super.key,
required this.firstNameController,
required this.lastNameController,
required this.birthDateController,
required this.idCardController,
required this.firstNameError,
required this.lastNameError,
required this.birthDateError,
required this.idCardError,
required this.isPersonalInfoValid,
required this.idCardImage,
required this.onComplete,
required this.onSelectDate,
required this.onPickImage,
required this.buttonScaleAnimation,
});

// Color constants (consistent with other screens)
static const Color _primaryColor = Color(0xFF0B356A);
static const Color _accentColor = Color(0xFF97DAFF);
static const Color _backgroundColor = Color(0xFFFFFFFF);
static const Color _textColor = Colors.black;
static const Color _placeholderColor = Color(0xFF8DA4C2);
static const Color _inputBackground = Color(0xFFE8F2FF);
static const Color _codeBorderColor = Color(0xFFE1E8F0);
static const Color _successColor = Color(0xFF4CAF50);
static const double _buttonHeight = 54.0;

/// Builds input decoration for text fields
InputDecoration _buildInputDecoration({
required String labelText,
required IconData prefixIcon,
String? errorText,
Widget? suffixIcon,
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
suffixIcon: suffixIcon,
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
'Informations personnelles',
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
'Complétez vos informations pour finaliser votre inscription',
style: TextStyle(
fontFamily: 'Poppins',
fontSize: 17,
fontWeight: FontWeight.w400,
color: _textColor.withOpacity(0.7),
height: 1.6,
),
),
const SizedBox(height: 40),
// First Name
TextField(
controller: firstNameController,
decoration: _buildInputDecoration(
labelText: 'Prénom',
prefixIcon: Icons.person_outline,
errorText: firstNameError,
),
style: const TextStyle(
color: _textColor,
fontFamily: 'Poppins',
fontSize: 17,
fontWeight: FontWeight.w500,
),
textCapitalization: TextCapitalization.words,
textInputAction: TextInputAction.next,
),
const SizedBox(height: 20),
// Last Name
TextField(
controller: lastNameController,
decoration: _buildInputDecoration(
labelText: 'Nom',
prefixIcon: Icons.person_outline,
errorText: lastNameError,
),
style: const TextStyle(
color: _textColor,
fontFamily: 'Poppins',
fontSize: 17,
fontWeight: FontWeight.w500,
),
textCapitalization: TextCapitalization.words,
textInputAction: TextInputAction.next,
),
const SizedBox(height: 20),
// Birth Date
TextField(
controller: birthDateController,
decoration: _buildInputDecoration(
labelText: 'Date de naissance',
prefixIcon: Icons.calendar_today_outlined,
errorText: birthDateError,
suffixIcon: IconButton(
icon: const Icon(Icons.date_range, color: _primaryColor),
onPressed: onSelectDate,
),
),
style: const TextStyle(
color: _textColor,
fontFamily: 'Poppins',
fontSize: 17,
fontWeight: FontWeight.w500,
),
readOnly: true,
onTap: onSelectDate,
),
const SizedBox(height: 20),
// ID Card Number
TextField(
controller: idCardController,
decoration: _buildInputDecoration(
labelText: 'Numéro de carte d\'identité',
prefixIcon: Icons.credit_card_outlined,
errorText: idCardError,
),
style: const TextStyle(
color: _textColor,
fontFamily: 'Poppins',
fontSize: 17,
fontWeight: FontWeight.w500,
),
textInputAction: TextInputAction.done,
),
const SizedBox(height: 30),
// ID Card Image
Container(
width: double.infinity,
decoration: BoxDecoration(
color: _inputBackground,
borderRadius: BorderRadius.circular(16),
border: Border.all(
color: idCardImage != null ? _accentColor : _codeBorderColor,
width: idCardImage != null ? 2 : 1,
),
),
child: Material(
color: Colors.transparent,
child: InkWell(
onTap: onPickImage,
borderRadius: BorderRadius.circular(16),
child: Container(
padding: const EdgeInsets.all(20),
child: idCardImage != null
? Column(
children: [
Container(
height: 200,
decoration: BoxDecoration(
borderRadius: BorderRadius.circular(12),
image: DecorationImage(
image: FileImage(idCardImage!),
fit: BoxFit.cover,
),
),
),
const SizedBox(height: 15),
Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(Icons.check_circle, color: _successColor, size: 24),
const SizedBox(width: 8),
Text(
'Image téléchargée avec succès',
style: TextStyle(
fontFamily: 'Poppins',
fontSize: 16,
fontWeight: FontWeight.w600,
color: _successColor,
),
),
],
),
],
)
    : Column(
children: [
Container(
width: 80,
height: 80,
decoration: BoxDecoration(
color: _primaryColor.withOpacity(0.1),
borderRadius: BorderRadius.circular(40),
),
child: const Icon(
Icons.camera_alt_outlined,
size: 40,
color: _primaryColor,
),
),
const SizedBox(height: 20),
Text(
'Télécharger une photo de votre carte d\'identité',
style: TextStyle(
fontFamily: 'Poppins',
fontSize: 18,
fontWeight: FontWeight.w600,
color: _textColor,
),
textAlign: TextAlign.center,
),
const SizedBox(height: 8),
Text(
'Appuyez pour sélectionner une image',
style: TextStyle(
fontFamily: 'Poppins',
fontSize: 15,
fontWeight: FontWeight.w400,
color: _placeholderColor,
),
textAlign: TextAlign.center,
),
],
),
),
),
),
),
const SizedBox(height: 40),
_buildButton(
text: 'Continuer',
textColor: isPersonalInfoValid ? _primaryColor : _placeholderColor,
borderColor: isPersonalInfoValid ? _primaryColor : _placeholderColor,
onPressed: isPersonalInfoValid ? onComplete : null,
),
],
);
}
}
