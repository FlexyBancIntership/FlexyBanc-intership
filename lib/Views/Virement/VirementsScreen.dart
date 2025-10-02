
import 'package:flexybank_intership/Views/Home/bottom_navigation_bar.dart';
import 'package:flexybank_intership/Views/Virement/CardRechargeScreen.dart';
import 'package:flexybank_intership/Views/Virement/HistoriqueTransfertsScreen.dart';
import 'package:flexybank_intership/Views/Virement/PaymentTransferScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'listescreen.dart';

class VirementsScreen extends StatefulWidget {
  const VirementsScreen({super.key});

  @override
  _VirementsScreenState createState() => _VirementsScreenState();
}

class _VirementsScreenState extends State<VirementsScreen>
    with SingleTickerProviderStateMixin {
  // Color palette aligned with HomeScreen
  static const Color _primaryColor = Color(0xFF16579D);
  static const Color _accentColor = Color(0xFF97DAFF);
  static const Color _inputBackground = Color(0xFFE8F2FF);
  static const Color _placeholderColor = Color(0xFF8DA4C2);
  static const Color _textColor = Color(0xFF1B1D4D);
  static const Color _darkBackground = Color(0xFF1C2526);
  static const Color _successColor = Color(0xFF4CAF50);
  static const Color _errorColor = Color(0xFFF44336);
  static const Color _goldAccent = Color(0xFFFFD700);
  static const Color _premiumGradientStart = Color(0xFF2C3E50);
  static const Color _premiumGradientEnd = Color(0xFF4A6741);

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _inputBackground,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: Text(
          'Virements',
          style: TextStyle(
            color: _textColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildTransferContent(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          HapticFeedback.lightImpact();
        },
      ),
    );
  }

  Widget _buildTransferContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF16579D),
                    Color(0xFF97DAFF),
                  ], // Dark blue to light blue
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _primaryColor.withOpacity(0.1)),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.05),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '\$1480.50',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '€1400.30',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '0.95635624',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.arrow_upward,
                          color: _successColor,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          _buildVirementsOption(
            icon: Icons.credit_card_outlined,
            title: 'Chargements des cartes',
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CardRechargeScreen()),
              );
            },
          ),
          SizedBox(height: 12),
          _buildVirementsOption(
            icon: Icons.account_balance_outlined,
            title: 'Virement vers mes comptes',
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentTransferScreen(),
                ),
              );
            },
          ),
          SizedBox(height: 12),
          _buildVirementsOption(
            icon: Icons.person_add_outlined,
            title: 'Virement vers mes bénéficiaires',
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Listescreen()),
              );
            },
          ),
          SizedBox(height: 12),
          _buildVirementsOption(
            icon: Icons.account_balance_outlined,
            title: 'Historique des transferts',
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoriqueTransfertsScreen(),
                ),
              );
            },
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildVirementsOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _primaryColor.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(0.05),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: _primaryColor, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: _primaryColor,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
