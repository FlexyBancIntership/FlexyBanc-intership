import 'package:flutter/material.dart';

class ActivityTypeScreen extends StatelessWidget {
  final Function(String) onNext;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;

  const ActivityTypeScreen({
    super.key,
    required this.onNext,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
  });

  // Color constants
  static const Color _primaryColor = Color(0xFF0B356A);
  static const Color _accentColor = Color(0xFF97DAFF);
  static const Color _backgroundColor = Color(0xFFFFFFFF);
  static const Color _textColor = Colors.black;
  static const Color _placeholderColor = Color(0xFF8DA4C2);

  // Define activityTypes locally with only the four specified types
  static const List<String> _activityTypes = [
    'Je suis Indépendant',
    'Entreprise de 1 à 9',
    'Entreprise de 9 à plus',
    'est une Association',
  ];

  Widget _buildActivityOption(
      BuildContext context, {
        required String title,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accentColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: _accentColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _accentColor.withOpacity(0.2),
                    _accentColor.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _accentColor.withOpacity(0.3), width: 1),
              ),
              child: Icon(
                icon,
                color: _primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textColor,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: _primaryColor,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> activityTypeMapping = {
      'Je suis Indépendant': 'Je suis Indépendant',
      'Entreprise de 1 à 9': 'Entreprise de 1 à 9',
      'Entreprise de 9 à plus': 'Entreprise de 9 à plus',
      'est une Association': 'est une Association',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type d\'activité',
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
          'Sélectionnez le type d\'activité correspondant à votre profil',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: _textColor.withOpacity(0.7),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),
        ..._activityTypes.map((type) => _buildActivityOption(
          context,
          title: activityTypeMapping[type] ?? type,
          icon: {
            'Je suis Indépendant': Icons.person_outline,
            'Entreprise de 1 à 9': Icons.groups_outlined,
            'Entreprise de 9 à plus': Icons.business_outlined,
            'est une Association': Icons.volunteer_activism_outlined,
          }[type] ?? Icons.business_center_outlined,
          onTap: () => onNext(type),
        )),
      ],
    );
  }
}