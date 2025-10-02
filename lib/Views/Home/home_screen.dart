
import 'package:flexybank_intership/Views/Activit%C3%A9/ActivityScreen.dart';
import 'package:flexybank_intership/Views/More/AccountPage.dart';
import 'package:flexybank_intership/Views/Virement/CardRechargeScreen.dart';
import 'package:flexybank_intership/Views/Virement/ListeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'NotificationScreen.dart';
import 'bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Unified color palette for professional design
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

  final PageController _accountPageController = PageController();
  int _currentAccountIndex = 0;
  final bool _hasNotifications = true; // Simulate notifications

  // Account data (without savings account)
  final List<Map<String, dynamic>> accounts = [
    {
      'name': 'Principal',
      'currency': 'DT',
      'balance': '2,540.75',
      'type': 'Main',
      'gradient': [_primaryColor, _accentColor.withOpacity(0.8)],
    },
    {
      'name': 'Entreprise',
      'currency': 'DT',
      'balance': '15,300.00',
      'type': 'Business',
      'gradient': [_premiumGradientStart, _premiumGradientEnd],
    },
  ];

  // Quick actions tailored to each account
  Map<String, List<Map<String, dynamic>>> accountActions = {};

  // Transactions linked to each account
  Map<String, List<Map<String, dynamic>>> accountTransactions = {};

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupAccountActions();
    _setupAccountTransactions();
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

  void _setupAccountActions() {
    accountActions = {
      'Principal': [
        {
          'icon': Icons.add_rounded,
          'title': 'Rechargement',
          'color': _successColor,
          'gradient': [_successColor, _successColor.withOpacity(0.7)],
          'onTap': (BuildContext context) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CardRechargeScreen()),
            );
          },
        },
        {
          'icon': Icons.phone_android_rounded,
          'title': 'Paiement mobile',
          'color': _accentColor,
          'gradient': [_accentColor, _primaryColor.withOpacity(0.8)],
        },
        {
          'icon': Icons.send_rounded,
          'title': 'Virement',
          'color': _primaryColor,
          'gradient': [_primaryColor, _primaryColor.withOpacity(0.7)],
          'onTap': (BuildContext context) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Listescreen()),
            );
          },
        },
        {
          'icon': Icons.qr_code_scanner_rounded,
          'title': 'QR Pay',
          'color': _goldAccent,
          'gradient': [_goldAccent, _goldAccent.withOpacity(0.7)],
        },
      ],
      'Entreprise': [
        {
          'icon': Icons.business_rounded,
          'title': 'Facturation',
          'color': _premiumGradientStart,
          'gradient': [_premiumGradientStart, _premiumGradientEnd],
        },
        {
          'icon': Icons.receipt_long_rounded,
          'title': 'Comptabilité',
          'color': _goldAccent,
          'gradient': [_goldAccent, _goldAccent.withOpacity(0.7)],
        },
        {
          'icon': Icons.send_rounded,
          'title': 'Virement',
          'color': _primaryColor,
          'gradient': [_primaryColor, _primaryColor.withOpacity(0.7)],
          'onTap': (BuildContext context) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Listescreen()),
            );
          },
        },
        {
          'icon': Icons.analytics_rounded,
          'title': 'Statistiques',
          'color': _accentColor,
          'gradient': [_accentColor, _primaryColor.withOpacity(0.8)],
        },
      ],
    };
  }

  void _setupAccountTransactions() {
    accountTransactions = {
      'Principal': [
        {
          'icon': Icons.shopping_cart_rounded,
          'title': 'Carrefour',
          'subtitle': '20/08/2025',
          'amount': '-85 DT',
          'color': _errorColor,
          'isDebit': true,
        },
        {
          'icon': Icons.phone_android_rounded,
          'title': 'Ooredoo',
          'subtitle': '19/08/2025',
          'amount': '-15 DT',
          'color': _errorColor,
          'isDebit': true,
        },
        {
          'icon': Icons.local_taxi_rounded,
          'title': 'Uber',
          'subtitle': '18/08/2025',
          'amount': '-25 DT',
          'color': _errorColor,
          'isDebit': true,
        },
        {
          'icon': Icons.restaurant_rounded,
          'title': 'Restaurant',
          'subtitle': '17/08/2025',
          'amount': '-50 DT',
          'color': _errorColor,
          'isDebit': true,
        },
        {
          'icon': Icons.shopping_bag_rounded,
          'title': 'Amazon',
          'subtitle': '16/08/2025',
          'amount': '-120 DT',
          'color': _errorColor,
          'isDebit': true,
        },
      ],
      'Entreprise': [
        {
          'icon': Icons.business_rounded,
          'title': 'Facturation Client XYZ',
          'subtitle': '19/08/2025',
          'amount': '+2,500 DT',
          'color': _successColor,
          'isDebit': false,
        },
        {
          'icon': Icons.account_balance_rounded,
          'title': 'Virement reçu',
          'subtitle': '17/08/2025',
          'amount': '+500 DT',
          'color': _successColor,
          'isDebit': false,
        },
        {
          'icon': Icons.payment_rounded,
          'title': 'Paiement fournisseur',
          'subtitle': '18/08/2025',
          'amount': '-300 DT',
          'color': _errorColor,
          'isDebit': true,
        },
        {
          'icon': Icons.business_center_rounded,
          'title': 'Investissement',
          'subtitle': '16/08/2025',
          'amount': '+1,000 DT',
          'color': _successColor,
          'isDebit': false,
        },
        {
          'icon': Icons.attach_money_rounded,
          'title': 'Salaire employé',
          'subtitle': '15/08/2025',
          'amount': '-800 DT',
          'color': _errorColor,
          'isDebit': true,
        },
      ],
    };
  }

  @override
  void dispose() {
    _animationController.dispose();
    _accountPageController.dispose();
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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_darkBackground, _darkBackground.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _primaryColor.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccountPage()),
                    );
                  },
                  child: Image.asset(
                    'assets/prb.jpg',
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 24,
                        ),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bonjour, Oussema',
                    style: TextStyle(
                      color: _placeholderColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Text(
                    'Mes Comptes',
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _primaryColor.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _primaryColor.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NotificationScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      Icon(
                        Icons.notifications_outlined,
                        color: _primaryColor,
                        size: 22,
                      ),
                      if (_hasNotifications)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _errorColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.white, width: 1),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Account Balance Card
                  _buildAccountBalanceCard(),
                  const SizedBox(height: 24),

                  // Manage Accounts Button
                  _buildAccountsButton(),
                  const SizedBox(height: 24),

                  // Quick Actions
                  _buildQuickActions(),
                  const SizedBox(height: 24),

                  // Transactions Section
                  _buildTransactionsSection(),
                  const SizedBox(height: 24),

                  // Quick Stats Card
                  _buildQuickStatsCard(),
                  const SizedBox(height: 24),

                  // Customization Tip
                  _buildCustomizationTip(),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          HapticFeedback.lightImpact();
        },
      ),
    );
  }

  Widget _buildAccountBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: accounts[_currentAccountIndex]['gradient'],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Account Carousel
          SizedBox(
            height: 100,
            child: PageView.builder(
              controller: _accountPageController,
              onPageChanged: (index) {
                setState(() {
                  _currentAccountIndex = index;
                });
                HapticFeedback.lightImpact();
              },
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${account['name']} • ${account['currency']}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${account['balance']} ${account['currency']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Account Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              accounts.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentAccountIndex == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                      _currentAccountIndex == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountsButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => HapticFeedback.lightImpact(),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _primaryColor.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 6),
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
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: _primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Gérer mes comptes',
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
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
      ),
    );
  }

  Widget _buildQuickActions() {
    final currentActions =
        accountActions[accounts[_currentAccountIndex]['name']] ?? [];

    return Column(
      children: [
        Row(
          children: [
            const Icon(Icons.flash_on_rounded, color: _primaryColor, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Actions rapides',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _textColor,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children:
              currentActions.map((action) => _buildActionCard(action)).toList(),
        ),
      ],
    );
  }

  Widget _buildActionCard(Map<String, dynamic> action) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          HapticFeedback.lightImpact();
          if (action.containsKey('onTap')) {
            action['onTap'](context);
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _primaryColor.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: action['gradient']),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(action['icon'], color: Colors.white, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                action['title'],
                style: const TextStyle(
                  color: _textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsSection() {
    final currentTransactions =
        accountTransactions[accounts[_currentAccountIndex]['name']] ?? [];

    return Column(
      children: [
        Row(
          children: [
            const Icon(
              Icons.receipt_long_rounded,
              color: _primaryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Transactions récentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _textColor,
                letterSpacing: 0.2,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => ActivityScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _primaryColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'Voir tout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...currentTransactions
            .take(4)
            .map(
              (transaction) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _primaryColor.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: (transaction['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        transaction['icon'],
                        color: transaction['color'],
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction['title'],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _textColor,
                              letterSpacing: 0.1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transaction['subtitle'],
                            style: const TextStyle(
                              fontSize: 12,
                              color: _placeholderColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      transaction['amount'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color:
                            transaction['isDebit']
                                ? _errorColor
                                : _successColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
            ,
      ],
    );
  }

  Widget _buildQuickStatsCard() {
    final currentTransactions =
        accountTransactions[accounts[_currentAccountIndex]['name']] ?? [];
    double totalIncome = 0;
    double totalExpense = 0;

    for (var transaction in currentTransactions) {
      final amountStr = transaction['amount'].replaceAll(RegExp(r'[^\d.]'), '');
      final amount = double.parse(amountStr);
      if (transaction['isDebit']) {
        totalExpense += amount;
      } else {
        totalIncome += amount;
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryColor.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.analytics_rounded,
                color: _primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Aperçu mensuel',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _textColor,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Revenus',
                      style: TextStyle(
                        fontSize: 12,
                        color: _placeholderColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+${totalIncome.toStringAsFixed(0)} DT',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _successColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: _placeholderColor.withOpacity(0.3),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dépenses',
                      style: TextStyle(
                        fontSize: 12,
                        color: _placeholderColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '-${totalExpense.toStringAsFixed(0)} DT',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _errorColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomizationTip() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryColor.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [_accentColor, _primaryColor]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.swipe_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Navigation intuitive',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _textColor,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Glissez horizontalement pour naviguer entre vos comptes',
                  style: TextStyle(
                    fontSize: 13,
                    color: _placeholderColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => HapticFeedback.lightImpact(),
                  child: const Text(
                    'Découvrir les fonctionnalités',
                    style: TextStyle(
                      fontSize: 14,
                      color: _primaryColor,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => HapticFeedback.lightImpact(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _placeholderColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: _placeholderColor,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
