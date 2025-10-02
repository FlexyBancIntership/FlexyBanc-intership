
import 'package:flexybank_intership/Views/AuthViews/SignIn/SignInScreen.dart';
import 'package:flexybank_intership/Views/Home/bottom_navigation_bar.dart';
import 'package:flexybank_intership/Views/More/AccountPage.dart';
import 'package:flexybank_intership/Views/More/AgencyMapScreen.dart';
import 'package:flexybank_intership/Views/More/CardSelectionScreen.dart';
import 'package:flexybank_intership/Views/More/HelpSupportScreen.dart';
import 'package:flexybank_intership/Views/More/Notification.dart';
import 'package:flexybank_intership/Views/More/PaymentLimitsPage.dart';
import 'package:flexybank_intership/Views/More/SecurityPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Constants for consistent styling
class AppColors {
  static const Color primaryColor = Color(0xFF16579D);
  static const Color accentColor = Color(0xFF97DAFF);
  static const Color inputBackground = Color(0xFFE8F2FF);
  static const Color placeholderColor = Color(0xFF8DA4C2);
  static const Color textColor = Color(0xFF1B1D4D);
  static const Color errorColor = Color(0xFFF44336);
  static const Color successColor = Color(0xFF4CAF50);
}

class AppDimensions {
  static const double buttonWidth = double.infinity;
  static const double buttonHeight = 50.0;
  static const double cardElevation = 6.0;
  static const double borderRadius = 12.0;
}

class PlusScreen extends StatefulWidget {
  const PlusScreen({super.key});

  @override
  _PlusScreenState createState() => _PlusScreenState();
}

class _PlusScreenState extends State<PlusScreen> with TickerProviderStateMixin {
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
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

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
      backgroundColor: AppColors.inputBackground,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: [
                _buildAccountSettingsSection(),
                const SizedBox(height: 20),
                _buildContactSection(),
                const SizedBox(height: 20),
                _buildLogoutButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
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

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80.0),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Plus',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Paramètres et services',
                        style: TextStyle(
                          color: AppColors.placeholderColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildIconContainer(Icons.settings),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSettingsSection() {
    return _buildSection(
      title: 'Paramètres du compte',
      subtitle: 'Gérez vos préférences et la sécurité de votre compte',
      items: [
        _MenuItem(
          icon: Icons.person_outline,
          title: 'Informations du compte',
          subtitle: 'Mettez à jour vos informations personnelles',
          onTap: () => _navigateTo(context, const AccountPage()),
        ),
        _MenuItem(
          icon: Icons.qr_code,
          title: 'QR Code de mon compte',
          subtitle: 'Partagez votre compte via QR Code',
          onTap: () => _navigateTo(context, CardSelectionScreen()),
        ),
        _MenuItem(
          icon: Icons.notifications_none,
          title: 'Notifications',
          subtitle: 'Configurez vos alertes',
          onTap: () => _navigateTo(context, NotificationsScreen()),
        ),
        _MenuItem(
          icon: Icons.security,
          title: 'Sécurité et confidentialité',
          subtitle: 'Protégez votre compte',
          onTap: () => _navigateTo(context, const SecurityPage()),
        ),
        _MenuItem(
          icon: Icons.business_outlined,
          title: 'Paramètres professionnels',
          subtitle: 'Limites paiement et outils professionnels',
          onTap: () => _navigateTo(context, const PaymentLimitsPage()),
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return _buildSection(
      title: 'Contact',
      subtitle: 'Besoin d\'aide ? Contactez notre équipe',
      items: [
        _MenuItem(
          icon: Icons.phone_outlined,
          title: 'Nous contacter',
          subtitle: 'Appelez notre service client',
          onTap: () => _navigateTo(context, HelpSupportScreen()),
        ),
        _MenuItem(
          icon: Icons.location_on_outlined,
          title: 'Nos agences',
          subtitle: 'Localisez nos agences et points de service',
          onTap: () => _showLocationDialog(context),
          isLast: true,
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required List<_MenuItem> items,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white.withOpacity(0.98)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.placeholderColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ...items.map(
            (item) => _buildMenuItem(
              icon: item.icon,
              title: item.title,
              subtitle: item.subtitle,
              onTap: item.onTap,
              isLast: item.isLast,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            border:
                isLast
                    ? null
                    : Border(
                      bottom: BorderSide(
                        color: AppColors.placeholderColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
          ),
          child: Row(
            children: [
              _buildIconContainer(icon),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                        letterSpacing: 0.1,
                      ),
                      semanticsLabel: title,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.placeholderColor,
                        fontWeight: FontWeight.w500,
                      ),
                      semanticsLabel: subtitle,
                    ),
                  ],
                ),
              ),
              _buildArrowIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor.withOpacity(0.1),
            AppColors.accentColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      child: Icon(icon, color: AppColors.primaryColor, size: 22),
    );
  }

  Widget _buildArrowIcon() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.primaryColor,
        size: 14,
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: _buildActionButton(
        icon: Icons.logout,
        title: 'Se déconnecter',
        color: Colors.white,
        backgroundGradient: LinearGradient(
          colors: [AppColors.errorColor, AppColors.errorColor.withOpacity(0.8)],
        ),
        onTap: () {
          HapticFeedback.lightImpact();
          _navigateTo(context, const SignInScreen(), removeUntil: true);
        },
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required Color color,
    required LinearGradient backgroundGradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        child: Container(
          width: AppDimensions.buttonWidth,
          height: AppDimensions.buttonHeight,
          decoration: BoxDecoration(
            gradient: backgroundGradient,
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                  letterSpacing: 0.3,
                ),
                semanticsLabel: title,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildIconContainer(Icons.location_on),
                    const SizedBox(width: 12),
                    const Text(
                      'Nos agences',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textColor,
                        letterSpacing: 0.2,
                      ),
                      semanticsLabel: 'Nos agences',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Trouvez l\'agence la plus proche de vous',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.placeholderColor,
                    fontWeight: FontWeight.w500,
                  ),
                  semanticsLabel: 'Trouvez l\'agence la plus proche de vous',
                ),
                const SizedBox(height: 16),
                _buildLocationOption(
                  title: 'Centre-ville Tunis',
                  address: 'Avenue Habib Bourguiba, 1001 Tunis',
                  distance: '2,5 km',
                ),
                const SizedBox(height: 12),
                _buildLocationOption(
                  title: 'La Marsa',
                  address: 'Rue de la Plage, 2078 La Marsa',
                  distance: '15 km',
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
                _navigateTo(context, AgencyMapScreen());
              },
              child: const Text(
                'Voir plus',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              child: const Text(
                'Fermer',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLocationOption({
    required String title,
    required String address,
    required String distance,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.inputBackground,
            AppColors.inputBackground.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.successColor.withOpacity(0.2),
                  AppColors.successColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            ),
            child: const Icon(
              Icons.place,
              color: AppColors.successColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                    letterSpacing: 0.1,
                  ),
                  semanticsLabel: title,
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.placeholderColor,
                    fontWeight: FontWeight.w500,
                  ),
                  semanticsLabel: address,
                ),
                const SizedBox(height: 4),
                Text(
                  distance,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.successColor,
                    fontWeight: FontWeight.w600,
                  ),
                  semanticsLabel: distance,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateTo(
    BuildContext context,
    Widget page, {
    bool removeUntil = false,
  }) {
    try {
      if (removeUntil) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => page),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur de navigation: $e')));
    }
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isLast;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isLast = false,
  });
}
