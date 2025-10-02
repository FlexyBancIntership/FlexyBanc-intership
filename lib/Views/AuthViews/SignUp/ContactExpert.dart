import 'package:flutter/material.dart';

class ContactExpert extends StatefulWidget {
  final VoidCallback onContinue;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;

  const ContactExpert({
    super.key,
    required this.onContinue,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
  });

  @override
  _ContactExpertState createState() => _ContactExpertState();
}

class _ContactExpertState extends State<ContactExpert> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _messageController = TextEditingController();

  static const Color _primaryColor = Color(0xFF0B356A);
  static const Color _accentColor = Color(0xFF97DAFF);
  static const Color _backgroundColor = Color(0xFFFFFFFF);
  static const Color _textColor = Colors.black;
  static const Color _inputBackground = Color(0xFFE8F2FF);

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Prenez contact avec un expert',
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
          'FlexyBanq vous met en contact avec un expert qui vous accompagnera dans la création de votre compte. Vous obtiendrez votre numéro IBAN dans les 24h (hors week-end et jours fériés)',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: _textColor.withOpacity(0.8),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Message',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Entrez votre message...',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: _primaryColor.withOpacity(0.5),
                  ),
                  filled: true,
                  fillColor: _inputBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Message envoyé ! Un expert vous contactera bientôt.')),
                      );
                      widget.onContinue();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Continuer',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}