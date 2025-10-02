import 'package:flexybank_intership/Views/Home/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateSettingsPage extends StatefulWidget {
  const UpdateSettingsPage({super.key});

  @override
  _UpdateSettingsPageState createState() => _UpdateSettingsPageState();
}

class _UpdateSettingsPageState extends State<UpdateSettingsPage>
    with SingleTickerProviderStateMixin {
  // Color constants
  static const Color _primaryColor = Color(0xFF16579D);
  static const Color _accentColor = Color(0xFF97DAFF);
  static const Color _backgroundColor = Color(0xFFF1F5F9);
  static const Color _surfaceColor = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF1B1D4D);
  static const Color _textSecondary = Color(0xFF475569);
  static const Color _textMuted = Color(0xFF94A3B8);
  static const Color _successColor = Color(0xFF10B981);
  static const Color _errorColor = Color(0xFFEF4444);
  static const Color _borderColor = Color(0xFFE2E8F0);

  // Controllers for text fields
  final TextEditingController _cashWithdrawalController = TextEditingController(
    text: '15000',
  );
  final TextEditingController _privateTransactionController =
      TextEditingController(text: '5000');
  final TextEditingController _onlinePaymentController = TextEditingController(
    text: '3000',
  );
  final TextEditingController _inStorePurchaseController =
      TextEditingController(text: '1000');
  final TextEditingController _onlinePurchaseController = TextEditingController(
    text: '2000',
  );

  // Error states
  final Map<String, String?> _errors = {
    'cashWithdrawal': null,
    'privateTransaction': null,
    'onlinePayment': null,
    'inStorePurchase': null,
    'onlinePurchase': null,
  };

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  // Validation logic
  String? _validateInput(String? value, String field) {
    if (value == null || value.isEmpty) {
      return 'Ce champ ne peut pas être vide';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Veuillez entrer un nombre valide';
    }
    if (number <= 0) {
      return 'La limite doit être supérieure à 0';
    }
    return null;
  }

  bool _validateAllFields() {
    setState(() {
      _errors['cashWithdrawal'] = _validateInput(
        _cashWithdrawalController.text,
        'cashWithdrawal',
      );
      _errors['privateTransaction'] = _validateInput(
        _privateTransactionController.text,
        'privateTransaction',
      );
      _errors['onlinePayment'] = _validateInput(
        _onlinePaymentController.text,
        'onlinePayment',
      );
      _errors['inStorePurchase'] = _validateInput(
        _inStorePurchaseController.text,
        'inStorePurchase',
      );
      _errors['onlinePurchase'] = _validateInput(
        _onlinePurchaseController.text,
        'onlinePurchase',
      );
    });
    return !_errors.values.any((error) => error != null);
  }

  Future<void> _showSuccessDialog(BuildContext context) async {
    try {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              backgroundColor: _surfaceColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: _successColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Succès',
                    style: TextStyle(
                      color: _textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              content: Text(
                'Les limites de paiement ont été mises à jour avec succès.',
                style: TextStyle(color: _textSecondary),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Return to PaymentLimitsPage
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: _primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
      );
    } catch (e) {
      print('Error in dialog: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Une erreur s\'est produite. Veuillez réessayer.',
            style: TextStyle(color: _surfaceColor),
          ),
          backgroundColor: _errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: _backgroundColor,
        appBar: AppBar(
          backgroundColor: _surfaceColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: _textPrimary,
              size: 20,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Mettre à jour les limites',
            style: TextStyle(
              color: _textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Modifier les limites de paiement',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ajustez les limites pour chaque type de transaction',
                style: TextStyle(
                  fontSize: 14,
                  color: _textMuted,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),

              // Cash withdrawals
              _buildLimitField(
                label: 'Retraits en espèces',
                controller: _cashWithdrawalController,
                icon: Icons.atm,
                error: _errors['cashWithdrawal'],
              ),
              const SizedBox(height: 16),

              // Private transactions
              _buildLimitField(
                label: 'Transactions privées',
                controller: _privateTransactionController,
                icon: Icons.lock,
                error: _errors['privateTransaction'],
              ),
              const SizedBox(height: 16),

              // Online payments
              _buildLimitField(
                label: 'Paiements en ligne',
                controller: _onlinePaymentController,
                icon: Icons.wifi,
                error: _errors['onlinePayment'],
              ),
              const SizedBox(height: 16),

              // One-time purchase in store
              _buildLimitField(
                label: 'Achat unique en magasin',
                controller: _inStorePurchaseController,
                icon: Icons.store,
                error: _errors['inStorePurchase'],
              ),
              const SizedBox(height: 16),

              // One-time purchase online
              _buildLimitField(
                label: 'Achat unique en ligne',
                controller: _onlinePurchaseController,
                icon: Icons.computer,
                error: _errors['onlinePurchase'],
              ),
              const SizedBox(height: 32),

              // Save button
              ScaleTransition(
                scale: _buttonScaleAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryColor, _accentColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      _animationController.forward().then(
                        (_) => _animationController.reverse(),
                      );
                      if (_validateAllFields()) {
                        await _showSuccessDialog(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Veuillez corriger les erreurs avant de sauvegarder',
                              style: TextStyle(color: _surfaceColor),
                            ),
                            backgroundColor: _errorColor,
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: Text(
                      'Enregistrer les modifications',
                      style: TextStyle(
                        color: _surfaceColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 4, // Same index as in CardSelectionScreen
          onTap: (index) {
            HapticFeedback.lightImpact();
            // Add navigation logic for bottom bar
          },
        ),
      ),
    );
  }

  Widget _buildLimitField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    String? error,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _borderColor.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: error != null ? _errorColor : _borderColor,
          width: error != null ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _textMuted, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: _textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              hintText: 'Entrez la limite (EUR)',
              hintStyle: TextStyle(color: _textMuted.withOpacity(0.6)),
              prefixIcon: const Icon(Icons.euro, color: _textMuted),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: _backgroundColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              errorText: error,
              errorStyle: TextStyle(color: _errorColor, fontSize: 12),
            ),
            style: TextStyle(
              fontSize: 16,
              color: _textPrimary,
              fontWeight: FontWeight.w600,
            ),
            onChanged: (value) {
              setState(() {
                _errors[label.toLowerCase().replaceAll(
                  ' ',
                  '',
                )] = _validateInput(value, label);
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cashWithdrawalController.dispose();
    _privateTransactionController.dispose();
    _onlinePaymentController.dispose();
    _inStorePurchaseController.dispose();
    _onlinePurchaseController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
