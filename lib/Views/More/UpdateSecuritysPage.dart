import 'package:flexybank_intership/Views/Home/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A page for updating user security settings, including password and security question.
class UpdateSecurityPage extends StatefulWidget {
  const UpdateSecurityPage({super.key});

  @override
  State<UpdateSecurityPage> createState() => _UpdateSecurityPageState();
}

class _UpdateSecurityPageState extends State<UpdateSecurityPage> {
  // Color constants
  static const Color _primaryColor = Color(0xFF16579D);
  static const Color _accentColor = Color(0xFF97DAFF);
  static const Color _inputBackground = Color(0xFFE8F2FF);
  static const Color _placeholderColor = Color(0xFF8DA4C2);
  static const Color _textColor = Color(0xFF1B1D4D);
  static const Color _successColor = Color(0xFF4CAF50);
  static const Color _errorColor = Color(0xFFF44336);
  static const Color _premiumGradientStart = Color(0xFF2C3E50);

  // Text controllers
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _securityAnswerController =
      TextEditingController();

  // State variables
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _securityAnswerError;
  String _selectedSecurityQuestion = 'Le nom de votre père';

  // Security questions list
  final List<String> _securityQuestions = [
    'Le nom de votre père',
    'Le nom de votre mère',
    'Votre ville de naissance',
    'Le nom de votre premier animal de compagnie',
    'Votre couleur préférée',
    'Le nom de votre meilleur ami d\'enfance',
  ];

  @override
  void initState() {
    super.initState();
    // Add listeners for real-time validation
    _newPasswordController.addListener(_validateNewPassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
    _securityAnswerController.addListener(_validateSecurityAnswer);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _securityAnswerController.dispose();
    super.dispose();
  }

  /// Validates the new password in real-time
  void _validateNewPassword() {
    setState(() {
      if (_newPasswordController.text.isEmpty) {
        _passwordError = 'Veuillez saisir votre nouveau mot de passe';
      } else if (_newPasswordController.text.length < 6) {
        _passwordError = 'Le mot de passe doit contenir au moins 6 caractères';
      } else {
        _passwordError = null;
      }
    });
  }

  /// Validates the confirm password field in real-time
  void _validateConfirmPassword() {
    setState(() {
      if (_confirmPasswordController.text != _newPasswordController.text) {
        _confirmPasswordError = 'Les mots de passe ne correspondent pas';
      } else {
        _confirmPasswordError = null;
      }
    });
  }

  /// Validates the security answer field
  void _validateSecurityAnswer() {
    setState(() {
      if (_securityAnswerController.text.isEmpty) {
        _securityAnswerError = 'Veuillez saisir une réponse';
      } else {
        _securityAnswerError = null;
      }
    });
  }

  /// Displays a snackbar with the given message and background color
  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Validates all fields before submission
  bool _validateForm() {
    bool isValid = true;
    if (_currentPasswordController.text.isEmpty) {
      _showSnackBar('Veuillez saisir votre mot de passe actuel', _errorColor);
      isValid = false;
    }
    if (_passwordError != null ||
        _confirmPasswordError != null ||
        _securityAnswerError != null) {
      isValid = false;
    }
    return isValid;
  }

  /// Simulates an API call to update security settings
  Future<void> _updateSecurity() async {
    if (!_validateForm()) return;

    setState(() => _isLoading = true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      _showSnackBar(
        'Paramètres de sécurité mis à jour avec succès',
        _successColor,
      );
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      _showSnackBar('Erreur lors de la mise à jour : $e', _errorColor);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Builds a password input field with toggleable visibility
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool obscureText,
    required VoidCallback toggleVisibility,
    String? errorText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: errorText != null ? _errorColor : _inputBackground,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 12),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: _placeholderColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(
              color: _textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: _placeholderColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              errorText: errorText,
              suffixIcon: IconButton(
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: _placeholderColor,
                  size: 20,
                ),
                onPressed: toggleVisibility,
              ),
            ),
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          ),
        ],
      ),
    );
  }

  /// Builds the security question dropdown
  Widget _buildSecurityQuestionDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _inputBackground),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 12),
            child: Text(
              'Question de sécurité',
              style: TextStyle(
                fontSize: 12,
                color: _placeholderColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          DropdownButtonFormField<String>(
            initialValue: _selectedSecurityQuestion,
            style: TextStyle(
              color: _textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            items:
                _securityQuestions.map((question) {
                  return DropdownMenuItem<String>(
                    value: question,
                    child: SizedBox(
                      width:
                          MediaQuery.of(context).size.width -
                          100, // Limit width to prevent overflow
                      child: Text(
                        question,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedSecurityQuestion = newValue!;
              });
            },
            dropdownColor: Colors.white,
            icon: Icon(Icons.keyboard_arrow_down, color: _placeholderColor),
          ),
        ],
      ),
    );
  }

  /// Builds the security answer input field
  Widget _buildSecurityAnswerField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _securityAnswerError != null ? _errorColor : _inputBackground,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 12),
            child: Text(
              'Réponse',
              style: TextStyle(
                fontSize: 12,
                color: _placeholderColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextFormField(
            controller: _securityAnswerController,
            style: TextStyle(
              color: _textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Saisissez votre réponse',
              hintStyle: TextStyle(color: _placeholderColor),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              errorText: _securityAnswerError,
            ),
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _updateSecurity(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _inputBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: _textColor, size: 20),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
          tooltip: 'Retour',
        ),
        title: const Text(
          'Mettre à jour la sécurité',
          style: TextStyle(
            color: _textColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Password section header
                  const Text(
                    'Changer le mot de passe',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Current password field
                  _buildPasswordField(
                    controller: _currentPasswordController,
                    label: 'Mot de passe actuel',
                    hint: 'Saisissez votre mot de passe actuel',
                    obscureText: _obscureCurrentPassword,
                    toggleVisibility:
                        () => setState(
                          () =>
                              _obscureCurrentPassword =
                                  !_obscureCurrentPassword,
                        ),
                    errorText: null,
                  ),

                  // New password field
                  _buildPasswordField(
                    controller: _newPasswordController,
                    label: 'Nouveau mot de passe',
                    hint: 'Saisissez votre nouveau mot de passe',
                    obscureText: _obscureNewPassword,
                    toggleVisibility:
                        () => setState(
                          () => _obscureNewPassword = !_obscureNewPassword,
                        ),
                    errorText: _passwordError,
                  ),

                  // Confirm password field
                  _buildPasswordField(
                    controller: _confirmPasswordController,
                    label: 'Confirmer le mot de passe',
                    hint: 'Confirmez votre nouveau mot de passe',
                    obscureText: _obscureConfirmPassword,
                    toggleVisibility:
                        () => setState(
                          () =>
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword,
                        ),
                    errorText: _confirmPasswordError,
                  ),

                  const SizedBox(height: 32),

                  // Security question section header
                  const Text(
                    'Question de sécurité',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _textColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Security question dropdown
                  _buildSecurityQuestionDropdown(),

                  // Security answer field
                  _buildSecurityAnswerField(),

                  const SizedBox(height: 32),

                  // Security tips
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _inputBackground),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: _primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Conseils de sécurité',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _textColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '• Utilisez au moins 6 caractères\n'
                          '• Mélangez lettres, chiffres et symboles\n'
                          '• Évitez les informations personnelles\n'
                          '• Ne partagez jamais vos identifiants',
                          style: TextStyle(
                            fontSize: 12,
                            color: _placeholderColor,
                            height: 1.5,
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Save button with animation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateSecurity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: _isLoading ? 0 : 2,
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                        : const Text(
                          'Enregistrer les modifications',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          HapticFeedback.lightImpact();
          // Add navigation logic for bottom bar
        },
      ),
    );
  }
}
