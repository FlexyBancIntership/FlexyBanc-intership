import 'package:flutter/material.dart';

class PaymentPack extends StatelessWidget {
  final VoidCallback onTrialSelected;
  final Function(String) onPackSelected;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;

  const PaymentPack({
    super.key,
    required this.onTrialSelected,
    required this.onPackSelected,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
  });

  // Color constants (matching the existing theme)
  static const Color _primaryColor = Color(0xFF0B356A);
  static const Color _accentColor = Color(0xFF97DAFF);
  static const Color _backgroundColor = Color(0xFFFFFFFF);
  static const Color _textColor = Colors.black;
  static const Color _placeholderColor = Color(0xFF8DA4C2);
  static const Color _buttonColor = Color(0xFFF5F6FA);

  Widget _buildPackCard(
      BuildContext context, {
        required String title,
        required String price,
        required List<String> features,
        required Color primaryColor,
        required Color accentColor,
        required VoidCallback onSelect,
      }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          ...features.map((feature) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(Icons.check, color: primaryColor, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feature,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: _textColor,
                    ),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onSelect,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Commencer',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.white,
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
          'Choisir votre pack',
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
          'Sélectionnez un pack ou essayez gratuitement',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            fontWeight: FontWeight.w400,
            color: _textColor.withOpacity(0.7),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _accentColor.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: _accentColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Essai gratuit de 10 jours',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Nous vous proposons dans notre pack des avantages pour répondre à tous vos besoins.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _textColor.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTrialSelected,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Commencer',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildPackCard(
          context,
          title: 'Pack Basic',
          price: '19 €/mois HT',
          features: [
            '6 utilisateurs (rôle maître + 5 utilisateurs de groupe)',
            'Fonctionnalités avancées (multi-comptes, virements groupés)',
            'Pack compatible (exige, détecteur Auto TVA, etc.)',
            'Support client par email',
          ],
          primaryColor: _primaryColor,
          accentColor: _accentColor,
          onSelect: () => onPackSelected('Pack Basic'),
        ),
        _buildPackCard(
          context,
          title: 'Pack Pro',
          price: '39 €/mois HT',
          features: [
            '10 utilisateurs (rôle maître + 9 utilisateurs de groupe)',
            'Fonctionnalités avancées + rapports personnalisés',
            'Intégration avec outils comptables',
            'Support client prioritaire (email + téléphone)',
            'Accès à des financements accélérés',
          ],
          primaryColor: _primaryColor,
          accentColor: _accentColor,
          onSelect: () => onPackSelected('Pack Pro'),
        ),
        _buildPackCard(
          context,
          title: 'Pack Enterprise',
          price: '79 €/mois HT',
          features: [
            'Utilisateurs illimités',
            'Gestion avancée des comptes multiples',
            'Services de trésorerie et cash management',
            'Support dédié avec gestionnaire de compte',
            'Accès à des solutions de paiement internationales',
          ],
          primaryColor: _primaryColor,
          accentColor: _accentColor,
          onSelect: () => onPackSelected('Pack Enterprise'),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}