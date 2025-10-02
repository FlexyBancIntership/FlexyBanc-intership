import 'package:flexybank_intership/Views/Home/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
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

  // État des notifications
  bool _receiveMessages = true;
  bool _bookingReminders = false;
  bool _couponsPromotions = true;
  bool _jobRegulations = true;
  bool _accountSupport = false;
  bool _upcomingPayments = false;
  bool _regulationsUpdates = true;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _inputBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: _textColor),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: _textColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header avec message d'introduction
                Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_primaryColor, _accentColor.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.2),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                _accentColor.withOpacity(0.8),
                                _primaryColor.withOpacity(0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.notifications_outlined,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Configurez vos notifications',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Personnalisez vos préférences de notification pour ne rien manquer d\'important',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Section des paramètres de notifications
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.white.withOpacity(0.98)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: Offset(0, -6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Paramètres de notifications préférées',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _textColor,
                                letterSpacing: 0.2,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Choisissez les notifications que vous souhaitez recevoir',
                              style: TextStyle(
                                fontSize: 13,
                                color: _placeholderColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Product updates
                      _buildNotificationItem(
                        category: 'Mises à jour produit',
                        title: 'Recevoir les messages de la plateforme',
                        value: _receiveMessages,
                        onChanged: (value) {
                          setState(() {
                            _receiveMessages = value;
                          });
                          HapticFeedback.lightImpact();
                        },
                      ),

                      // Reminders
                      _buildNotificationItem(
                        category: 'Rappels',
                        title: 'Recevoir les rappels de réservation',
                        value: _bookingReminders,
                        onChanged: (value) {
                          setState(() {
                            _bookingReminders = value;
                          });
                          HapticFeedback.lightImpact();
                        },
                      ),

                      // Promotions and tips
                      _buildNotificationItem(
                        category: 'Promotions et conseils',
                        title: 'Recevoir les coupons et promotions',
                        value: _couponsPromotions,
                        onChanged: (value) {
                          setState(() {
                            _couponsPromotions = value;
                          });
                          HapticFeedback.lightImpact();
                        },
                      ),

                      // Policy and community
                      _buildNotificationItem(
                        category: 'Politique et communauté',
                        title:
                            'Recevoir les mises à jour sur les réglementations',
                        value: _jobRegulations,
                        onChanged: (value) {
                          setState(() {
                            _jobRegulations = value;
                          });
                          HapticFeedback.lightImpact();
                        },
                      ),

                      // Account support
                      _buildNotificationItem(
                        category: 'Support compte',
                        title: 'Recevoir les messages concernant',
                        value: _accountSupport,
                        onChanged: (value) {
                          setState(() {
                            _accountSupport = value;
                          });
                          HapticFeedback.lightImpact();
                        },
                      ),

                      // Reminders - Payments
                      _buildNotificationItem(
                        category: 'Rappels',
                        title: 'Paiements à venir',
                        value: _upcomingPayments,
                        onChanged: (value) {
                          setState(() {
                            _upcomingPayments = value;
                          });
                          HapticFeedback.lightImpact();
                        },
                      ),

                      // Policy and community - Regulations
                      _buildNotificationItem(
                        category: 'Politique et communauté',
                        title:
                            'Recevoir les mises à jour sur les réglementations',
                        value: _regulationsUpdates,
                        onChanged: (value) {
                          setState(() {
                            _regulationsUpdates = value;
                          });
                          HapticFeedback.lightImpact();
                        },
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Bouton de sauvegarde
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  width: double.infinity,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _saveNotificationSettings();
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _primaryColor,
                              _accentColor.withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: _primaryColor.withOpacity(0.2),
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Sauvegarder les préférences',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 4,
        onTap: (index) {
          HapticFeedback.lightImpact();
        },
      ),
    );
  }

  Widget _buildNotificationItem({
    required String category,
    required String title,
    required bool value,
    required Function(bool) onChanged,
    bool isLast = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border:
            isLast
                ? null
                : Border(
                  bottom: BorderSide(
                    color: _placeholderColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: TextStyle(
              color: _placeholderColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeThumbColor: _successColor,
                  activeTrackColor: _accentColor.withOpacity(0.8),
                  inactiveThumbColor: _placeholderColor,
                  inactiveTrackColor: _placeholderColor.withOpacity(0.3),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _saveNotificationSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Préférences de notification sauvegardées',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: _successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
