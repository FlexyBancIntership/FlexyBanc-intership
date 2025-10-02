import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneVerificationStep extends StatelessWidget {
final List<TextEditingController> phoneCodeControllers;
final List<FocusNode> phoneFocusNodes;
final String phoneNumber;
final String countryCode;
final int phoneTimerSeconds;
final bool isPhoneCodeValid;
final VoidCallback onNext;
final VoidCallback onResend;
final Animation<double> buttonScaleAnimation;
final Animation<double> codeScaleAnimation;
final AnimationController timerAnimationController;
final Function(String) onCodeChanged;

const PhoneVerificationStep({
super.key,
required this.phoneCodeControllers,
required this.phoneFocusNodes,
required this.phoneNumber,
required this.countryCode,
required this.phoneTimerSeconds,
required this.isPhoneCodeValid,
required this.onNext,
required this.onResend,
required this.buttonScaleAnimation,
required this.codeScaleAnimation,
required this.timerAnimationController,
required this.onCodeChanged,
});

// Color constants (consistent with other screens)
static const Color _primaryColor = Color(0xFF0B356A);
static const Color _accentColor = Color(0xFF97DAFF);
static const Color _backgroundColor = Color(0xFFFFFFFF);
static const Color _textColor = Colors.black;
static const Color _placeholderColor = Color(0xFF8DA4C2);
static const Color _codeInputBackground = Color(0xFFF8FBFF);
static const Color _codeBorderColor = Color(0xFFE1E8F0);
static const double _buttonHeight = 54.0;

/// Builds input decoration for code digits
InputDecoration _buildCodeInputDecoration(bool isFocused) {
return InputDecoration(
filled: true,
fillColor: isFocused ? _accentColor.withOpacity(0.1) : _codeInputBackground,
contentPadding: const EdgeInsets.symmetric(vertical: 24),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(20),
borderSide: const BorderSide(color: _codeBorderColor, width: 2),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(20),
borderSide: const BorderSide(color: _codeBorderColor, width: 2),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(20),
borderSide: const BorderSide(color: _accentColor, width: 3),
),
counterText: '',
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
final isCodeFilled = phoneCodeControllers.every((c) => c.text.isNotEmpty) && isPhoneCodeValid;

return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Vérifiez votre numéro',
style: TextStyle(
fontFamily: 'Poppins',
fontSize: 32,
fontWeight: FontWeight.w800,
color: _textColor,
letterSpacing: -0.8,
),
),
const SizedBox(height: 18),
RichText(
text: TextSpan(
style: TextStyle(
fontFamily: 'Poppins',
fontSize: 17,
fontWeight: FontWeight.w400,
color: _textColor.withOpacity(0.7),
height: 1.6,
),
children: [
const TextSpan(text: 'Nous avons envoyé un code à 4 chiffres à '),
TextSpan(
text: '$countryCode $phoneNumber',
style: TextStyle(
fontWeight: FontWeight.w600,
color: _primaryColor,
),
),
],
),
),
const SizedBox(height: 40),
Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: List.generate(4, (index) {
return SizedBox(
width: 70,
child: AnimatedBuilder(
animation: codeScaleAnimation,
builder: (context, child) {
return Transform.scale(
scale: phoneFocusNodes[index].hasFocus ? codeScaleAnimation.value : 1.0,
child: TextField(
controller: phoneCodeControllers[index],
focusNode: phoneFocusNodes[index],
decoration: _buildCodeInputDecoration(phoneFocusNodes[index].hasFocus),
style: TextStyle(
fontFamily: 'Poppins',
fontSize: 24,
fontWeight: FontWeight.w800,
color: _textColor,
),
textAlign: TextAlign.center,
keyboardType: TextInputType.number,
maxLength: 1,
inputFormatters: [FilteringTextInputFormatter.digitsOnly],
onChanged: (value) => onCodeChanged(value),
),
);
},
),
);
}),
),
const SizedBox(height: 32),
Center(
child: phoneTimerSeconds > 0
? AnimatedBuilder(
animation: timerAnimationController,
builder: (context, child) {
return Text(
'Renvoyer le code dans ${phoneTimerSeconds}s',
style: TextStyle(
fontFamily: 'Poppins',
fontSize: 16,
fontWeight: FontWeight.w500,
color:
_placeholderColor.withOpacity(0.8 + 0.2 * timerAnimationController.value),
),
);
},
)
    : TextButton(
onPressed: onResend,
child: Text(
'Renvoyer le code',
style: TextStyle(
fontFamily: 'Poppins',
fontSize: 16,
fontWeight: FontWeight.w600,
color: _primaryColor,
),
),
),
),
const SizedBox(height: 298),
_buildButton(
text: 'Vérifier',
textColor: isCodeFilled ? _primaryColor : _placeholderColor,
borderColor: isCodeFilled ? _primaryColor : _placeholderColor,
onPressed: isCodeFilled ? onNext : null,
),
],
);
}
}
