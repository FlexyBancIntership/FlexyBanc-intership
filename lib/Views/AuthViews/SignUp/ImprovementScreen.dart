import 'package:flutter/material.dart';

class ImprovementScreen extends StatefulWidget {
  final String activityType;
  final Function(List<String>) onSubmit;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;

  const ImprovementScreen({
    super.key,
    required this.activityType,
    required this.onSubmit,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
  });

  @override
  _ImprovementScreenState createState() => _ImprovementScreenState();
}

class _ImprovementScreenState extends State<ImprovementScreen> {
  List<String> selectedImprovements = [];
  final TextEditingController _workDomainController = TextEditingController();
  final TextEditingController _aboutYouController = TextEditingController();

  // Color constants
  static const Color _primaryColor = Color(0xFF0B356A);
  static const Color _accentColor = Color(0xFF97DAFF);
  static const Color _backgroundColor = Color(0xFFFFFFFF);
  static const Color _textColor = Colors.black;
  static const Color _placeholderColor = Color(0xFF8DA4C2);
  static const Color _inputBackground = Color(0xFFE8F2FF);

  // Define improvementOptions locally
  static const List<String> _improvementOptions = [
    'Épargne',
    'Investissement',
    'Paiements',
    'Transferts',
    'Budgétisation',
    'Crédit',
  ];

  @override
  void dispose() {
    _workDomainController.dispose();
    _aboutYouController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getActivityContent() {
    switch (widget.activityType) {
      case 'Je suis Indépendant':
        return {
          'title': 'Gérez votre activité d\'indépendant',
          'description': 'En tant qu\'indépendant, vous avez besoin d\'outils financiers adaptés à votre situation. Un compte professionnel vous permet de séparer vos finances personnelles et professionnelles.',
          'icon': Icons.person_outline,
          'benefits': [
            'Séparer vos finances personnelles et professionnelles',
            'Faciliter votre comptabilité et déclarations fiscales',
            'Bénéficier de solutions de paiement professionnelles',
            'Accéder à des outils de gestion financière',
            'Obtenir des justificatifs pour vos clients',
          ],
          'reasons': [
            'Obligation légale pour certaines activités',
            'Crédibilité professionnelle accrue',
            'Suivi simplifié des revenus et charges',
            'Accès à des services bancaires spécialisés',
          ]
        };
      case 'Entreprise de 1 à 9':
        return {
          'title': 'Solutions pour petites entreprises',
          'description': 'Votre petite entreprise mérite des services bancaires professionnels adaptés à sa taille. Gérez facilement vos finances d\'équipe et vos opérations quotidiennes.',
          'icon': Icons.groups_outlined,
          'benefits': [
            'Gestion multi-utilisateurs pour votre équipe',
            'Suivi des dépenses par employé ou projet',
            'Solutions de paiement pour vos clients',
            'Outils de facturation intégrés',
            'Accès à des financements adaptés',
          ],
          'reasons': [
            'Optimiser la gestion des salaires',
            'Centraliser les dépenses professionnelles',
            'Faciliter les paiements fournisseurs',
            'Préparer la croissance de l\'entreprise',
          ]
        };
      case 'Entreprise de 9 à plus':
        return {
          'title': 'Solutions entreprise avancées',
          'description': 'Votre entreprise en croissance nécessite des outils financiers robustes et évolutifs. Bénéficiez de services bancaires professionnels de niveau entreprise.',
          'icon': Icons.business_outlined,
          'benefits': [
            'Gestion avancée des comptes multiples',
            'Services de trésorerie et cash management',
            'Solutions de paiement internationales',
            'Outils de reporting financier détaillés',
            'Accès privilégié aux financements',
          ],
          'reasons': [
            'Gérer des flux financiers complexes',
            'Optimiser la trésorerie d\'entreprise',
            'Faciliter l\'expansion internationale',
            'Bénéficier d\'un accompagnement dédié',
          ]
        };
      case 'est une Association':
        return {
          'title': 'Services bancaires associatifs',
          'description': 'Votre association a des besoins spécifiques. Bénéficiez de services bancaires adaptés au secteur associatif avec des conditions préférentielles.',
          'icon': Icons.volunteer_activism_outlined,
          'benefits': [
            'Comptes adaptés au statut associatif',
            'Gestion des cotisations et dons',
            'Outils de suivi des projets',
            'Services de paiement pour événements',
            'Accompagnement dans les démarches',
          ],
          'reasons': [
            'Respecter les obligations comptables',
            'Faciliter la gestion des bénévoles',
            'Optimiser la collecte de fonds',
            'Bénéficier de tarifs préférentiels',
          ]
        };
      default:
        return {
          'title': 'Votre activité professionnelle',
          'description': 'Chaque activité a ses spécificités. Découvrez comment un compte professionnel peut vous aider.',
          'icon': Icons.business_center_outlined,
          'benefits': [],
          'reasons': []
        };
    }
  }

  Widget _buildBenefitCard(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _accentColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _primaryColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: _textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: _inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _accentColor.withOpacity(0.3)),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: _textColor,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: _placeholderColor,
              ),
              prefixIcon: icon != null
                  ? Icon(icon, color: _primaryColor, size: 20)
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReasonChip(String reason) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _primaryColor.withOpacity(0.3)),
      ),
      child: Text(
        reason,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _primaryColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = _getActivityContent();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                content['icon'],
                color: _primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                content['title'],
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: _textColor,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          content['description'],
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: _textColor.withOpacity(0.8),
            height: 1.5,
          ),
        ),
        const SizedBox(height: 30),
        if (content['reasons'].isNotEmpty) ...[
          Text(
            'Pourquoi ouvrir un compte professionnel ?',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            children: content['reasons'].map<Widget>((reason) => _buildReasonChip(reason)).toList(),
          ),
          const SizedBox(height: 30),
        ],
        if (content['benefits'].isNotEmpty) ...[
          Text(
            'Ce que vous pouvez faire avec FlexyBanq',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 16),
          ...content['benefits'].map((benefit) => _buildBenefitCard(benefit, Icons.check_circle_outline)),
          const SizedBox(height: 30),
        ],
        if (_improvementOptions.isNotEmpty) ...[
          Text(
            'Sélectionnez vos besoins',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _improvementOptions.map((option) {
              final isSelected = selectedImprovements.contains(option);
              return ChoiceChip(
                label: Text(
                  option,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: isSelected ? Colors.white : _primaryColor,
                  ),
                ),
                selected: isSelected,
                selectedColor: _primaryColor,
                backgroundColor: _accentColor.withOpacity(0.1),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      selectedImprovements.add(option);
                    } else {
                      selectedImprovements.remove(option);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
        ],
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(16),
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
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.person_pin_outlined,
                      color: _primaryColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Parlez-nous de vous',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _textColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Domaine d\'activité',
                hint: 'Ex: Développement web, Commerce, Consulting...',
                controller: _workDomainController,
                icon: Icons.work_outline,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'Présentez-vous brièvement',
                hint: 'Décrivez votre activité, vos objectifs, vos besoins spécifiques...',
                controller: _aboutYouController,
                maxLines: 4,
                icon: Icons.edit_outlined,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: _primaryColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Ces informations nous aideront à personnaliser votre expérience',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: _textColor.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _accentColor.withOpacity(0.1),
                _accentColor.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _accentColor.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: _primaryColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Bon à savoir',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'L\'ouverture d\'un compte professionnel est gratuite et peut être réalisée en quelques minutes. Vous bénéficierez immédiatement d\'une IBAN française et d\'une carte de paiement professionnelle.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: _textColor.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: selectedImprovements.isNotEmpty
                ? () => widget.onSubmit(selectedImprovements)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continuer l\'ouverture',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }
}