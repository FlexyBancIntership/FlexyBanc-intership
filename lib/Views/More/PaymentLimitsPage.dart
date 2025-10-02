import 'package:flexybank_intership/Views/Home/bottom_navigation_bar.dart';
import 'package:flexybank_intership/Views/More/UpdateSettingsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentLimitsPage extends StatefulWidget {
  const PaymentLimitsPage({super.key});

  @override
  _PaymentLimitsPageState createState() => _PaymentLimitsPageState();
}

class _PaymentLimitsPageState extends State<PaymentLimitsPage>
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

  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: _textPrimary, size: 20),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Limites de paiement',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Setup limits section title
                    Row(
                      children: [
                        Icon(Icons.settings, color: _textMuted, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Configurer les limites',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: _textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Consultez et ajustez vos limites de paiement',
                      style: TextStyle(
                        fontSize: 14,
                        color: _textMuted,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Cash withdrawals
                    _buildLimitCard(
                      icon: Icons.atm,
                      title: 'Retraits en espèces',
                      current: '8.950',
                      limit: '15.000',
                      progress: 0.6,
                    ),
                    const SizedBox(height: 16),

                    // Private transactions
                    _buildLimitCard(
                      icon: Icons.lock,
                      title: 'Transactions privées',
                      current: '4.650',
                      limit: '5.000',
                      progress: 0.93,
                    ),
                    const SizedBox(height: 16),

                    // Online payments
                    _buildLimitCard(
                      icon: Icons.wifi,
                      title: 'Paiements en ligne',
                      current: '850',
                      limit: '3.000',
                      progress: 0.283,
                    ),
                    const SizedBox(height: 16),

                    // One-time purchase in store
                    _buildLimitCard(
                      icon: Icons.store,
                      title: 'Achat unique en magasin',
                      current: null,
                      limit: '1.000',
                      progress: null,
                    ),
                    const SizedBox(height: 16),

                    // One-time purchase online
                    _buildLimitCard(
                      icon: Icons.computer,
                      title: 'Achat unique en ligne',
                      current: null,
                      limit: '2.000',
                      progress: null,
                    ),
                  ],
                ),
              ),
            ),

            // Update Settings button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ScaleTransition(
                scale: Tween<double>(begin: 1.0, end: 0.95).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: Curves.easeInOut,
                  ),
                ),
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
                    onPressed: () {
                      _animationController.forward().then(
                        (_) => _animationController.reverse(),
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpdateSettingsPage(),
                        ),
                      );
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
                      'Mettre à jour les paramètres',
                      style: TextStyle(
                        color: _surfaceColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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

  Widget _buildLimitCard({
    required IconData icon,
    required String title,
    String? current,
    required String limit,
    double? progress,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _textMuted, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: _textMuted,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (current != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$current EUR',
                  style: TextStyle(
                    fontSize: 16,
                    color: _textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$limit EUR',
                  style: TextStyle(
                    fontSize: 16,
                    color: _accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: _accentColor.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ] else ...[
            Text(
              'Limite de montant',
              style: TextStyle(
                fontSize: 14,
                color: _textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '$limit EUR',
                style: TextStyle(
                  fontSize: 16,
                  color: _accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
