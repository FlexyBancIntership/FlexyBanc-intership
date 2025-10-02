
import 'package:flexybank_intership/Views/Activit%C3%A9/ActivityScreen.dart';
import 'package:flexybank_intership/Views/Home/bottom_navigation_bar.dart' as HomeNav;
import 'package:flexybank_intership/Views/Home/home_screen.dart' as Home;
import 'package:flexybank_intership/Views/More/plus_screen.dart' as MoreScreen;
import 'package:flexybank_intership/Views/carte/ActiverCarte.dart';
import 'package:flexybank_intership/Views/carte/BlocageCarte.dart';
import 'package:flexybank_intership/Views/carte/NouvelleCarte.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:async';

import 'LimitsScreen.dart';
import 'RemplacerScreen.dart';

class CarteScreen extends StatefulWidget {
  final Map<String, dynamic>? newCard;
  const CarteScreen({super.key, this.newCard});

  @override
  _CarteScreenState createState() => _CarteScreenState();
}

class _CarteScreenState extends State<CarteScreen>
    with TickerProviderStateMixin {
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

  final PageController _pageController = PageController();
  int _currentCardIndex = 0;
  final String _typeToShow = ''; // 'pin' ou 'number'

  final LocalAuthentication auth = LocalAuthentication();

  List<Map<String, dynamic>> cards = [
    {
      'type': 'Virtuelle',
      'number': '1234 5678 9012 3456',
      'holder': 'CARDHOLDER NAME',
      'balance': '51,630,650 €',
      'expiry': '08/30',
      'isBlocked': false,
      'isActive': true,
      'pin': '1234',
      'onlinePaymentsEnabled': true,
      'contactlessEnabled': false,
      'magneticStripeEnabled': false,
      'chipTransactionsEnabled': false,
      'mobileWalletEnabled': true,
      'limits': {'daily': 1000.0, 'monthly': 5000.0},
    },
    {
      'type': 'Physique',
      'number': '9876 5432 1098 7654',
      'holder': 'CARDHOLDER NAME',
      'balance': '10,000 €',
      'expiry': '12/25',
      'isBlocked': false,
      'isActive': true,
      'pin': '5678',
      'onlinePaymentsEnabled': true,
      'contactlessEnabled': true,
      'magneticStripeEnabled': true,
      'chipTransactionsEnabled': true,
      'mobileWalletEnabled': true,
      'limits': {'daily': 2000.0, 'monthly': 10000.0},
    },
    {
      'type': 'Voyage',
      'number': '1111 2222 3333 4444',
      'holder': 'CARDHOLDER NAME',
      'balance': '5,000 €',
      'expiry': '06/26',
      'isBlocked': false,
      'isActive': true,
      'pin': '9012',
      'onlinePaymentsEnabled': true,
      'contactlessEnabled': false,
      'magneticStripeEnabled': false,
      'chipTransactionsEnabled': false,
      'mobileWalletEnabled': true,
      'limits': {'daily': 1500.0, 'monthly': 7500.0},
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.newCard != null) {
      _addNewCard(widget.newCard!);
    }
  }

  void _addNewCard(Map<String, dynamic> newCard) {
    final newCardWithSettings = <String, dynamic>{
      'type': newCard['type']?.toString() ?? 'Virtuelle',
      'number': newCard['number']?.toString() ?? '0000 0000 0000 0000',
      'holder':
          (newCard['holder']?.toString() ??
                  newCard['holderName']?.toString() ??
                  'CARDHOLDER NAME')
              .toUpperCase(),
      'balance': newCard['balance']?.toString() ?? '0 €',
      'expiry': newCard['expiry']?.toString() ?? '12/99',
      'isBlocked': false,
      'isActive': newCard['isActive'] == true,
      'pin': newCard['pin']?.toString() ?? '0000',
      'onlinePaymentsEnabled': newCard['onlinePaymentsEnabled'] ?? true,
      'contactlessEnabled':
          newCard['contactlessEnabled'] ?? (newCard['type'] == 'Physique'),
      'magneticStripeEnabled':
          newCard['magneticStripeEnabled'] ?? (newCard['type'] == 'Physique'),
      'chipTransactionsEnabled':
          newCard['chipTransactionsEnabled'] ?? (newCard['type'] == 'Physique'),
      'mobileWalletEnabled': newCard['mobileWalletEnabled'] ?? true,
      'limits': newCard['limits'] ?? {'daily': 1000.0, 'monthly': 5000.0},
    };

    setState(() {
      cards.add(newCardWithSettings);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _pageController.hasClients) {
        _pageController.animateToPage(
          cards.length - 1,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _maskedCardNumber(String? number) {
    if (number == null || number.isEmpty) return '****';
    String cleaned = number.replaceAll(' ', '');
    if (cleaned.length < 4) return '****';
    String last4 = cleaned.substring(cleaned.length - 4);
    return '**** **** **** $last4';
  }

  String _getSafeCardValue(
    Map<String, dynamic> card,
    String key, [
    String defaultValue = '',
  ]) {
    final value = card[key];
    if (value == null) return defaultValue;
    return value.toString();
  }

  Future<void> _showPinOrNumberDialog(String type) async {
    if (cards[_currentCardIndex]['isBlocked'] ||
        !cards[_currentCardIndex]['isActive']) {
      _showBlockedOrInactiveCardDialog();
      return;
    }

    try {
      bool authenticated = await auth.authenticate(
        localizedReason:
            type == 'pin'
                ? "Authentifiez-vous pour afficher le PIN"
                : "Authentifiez-vous pour afficher le numéro de carte",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: false,
        ),
      );

      if (authenticated) {
        String result =
            type == 'pin'
                ? _getSafeCardValue(cards[_currentCardIndex], 'pin', '0000')
                : _getSafeCardValue(
                  cards[_currentCardIndex],
                  'number',
                  '0000 0000 0000 0000',
                );
        _showAuthResultDialog(type, result);
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Échec de l\'authentification'),
          backgroundColor: _errorColor,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAuthResultDialog(String type, String result) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.check_circle, color: _successColor, size: 24),
                SizedBox(width: 8),
                Text(
                  type == 'pin' ? 'Code PIN' : 'Numéro de carte',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _inputBackground,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _primaryColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    result,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: _textColor,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Information affichée de manière sécurisée',
                  style: TextStyle(
                    fontSize: 12,
                    color: _placeholderColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  foregroundColor: _primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: Text('Fermer'),
              ),
            ],
          ),
    );

    Timer(Duration(seconds: 10), () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  void _toggleCardBlock(int cardIndex) {
    setState(() {
      cards[cardIndex]['isBlocked'] = !cards[cardIndex]['isBlocked'];
    });
  }

  void _navigateToBlocage() async {
    if (!cards[_currentCardIndex]['isActive']) {
      _showBlockedOrInactiveCardDialog();
      return;
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BlocageCarte(
              card: cards[_currentCardIndex],
              onConfirm: () => _toggleCardBlock(_currentCardIndex),
            ),
      ),
    );
    if (result == true) {}
  }

  void _editCardHolderName() {
    if (cards[_currentCardIndex]['isBlocked'] ||
        !cards[_currentCardIndex]['isActive']) {
      _showBlockedOrInactiveCardDialog();
      return;
    }
    final TextEditingController controller = TextEditingController(
      text: _getSafeCardValue(
        cards[_currentCardIndex],
        'holder',
        'CARDHOLDER NAME',
      ),
    );
    String? errorMessage;
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  insetPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                  ), // ajusté ici
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 10,
                  backgroundColor: Colors.transparent,
                  content: Container(
                    width:
                        MediaQuery.of(context).size.width *
                        0.9, // largeur popup réduite à 75%
                    padding: EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ), // padding réduit
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Colors.white.withOpacity(0.97)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.12),
                          blurRadius: 24,
                          spreadRadius: 1,
                          offset: Offset(0, 6),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 36,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _accentColor,
                                    _primaryColor.withOpacity(0.85),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: _accentColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Modifier le nom',
                                    style: TextStyle(
                                      fontSize: 18, // réduit de 22
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                      color: _textColor,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Carte ${_getSafeCardValue(cards[_currentCardIndex], 'type', 'Standard')}',
                                    style: TextStyle(
                                      fontSize: 13, // réduit de 15
                                      color: _placeholderColor,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20), // réduit de 28
                        Text(
                          'Nom du titulaire de la carte',
                          style: TextStyle(
                            fontSize: 13, // réduit de 15
                            fontWeight: FontWeight.w700,
                            color: _textColor,
                            letterSpacing: 0.4,
                          ),
                        ),
                        SizedBox(height: 10), // réduit de 12
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              18,
                            ), // légèrement réduits sur les coins
                            boxShadow: [
                              BoxShadow(
                                color: _primaryColor.withOpacity(0.10),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            controller: controller,
                            style: TextStyle(
                              fontSize: 15, // réduit de 17
                              fontWeight: FontWeight.w700,
                              color: _textColor,
                              letterSpacing: 1.0,
                            ),
                            textCapitalization: TextCapitalization.characters,
                            maxLength: 26,
                            decoration: InputDecoration(
                              hintText: 'Entrez le nom complet',
                              hintStyle: TextStyle(
                                color: _placeholderColor.withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5,
                              ),
                              prefixIcon: Container(
                                margin: EdgeInsets.all(8), // réduit de 10
                                decoration: BoxDecoration(
                                  color: _accentColor.withOpacity(
                                    0.20,
                                  ), // un peu plus léger
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.person_rounded,
                                  color: _primaryColor,
                                  size: 20, // réduit de 22
                                ),
                              ),
                              filled: true,
                              fillColor: _inputBackground,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                  color: _primaryColor.withOpacity(0.10),
                                  width: 1.2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                  color: _primaryColor,
                                  width: 2.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                  color: _errorColor,
                                  width: 1.2,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                  color: _errorColor,
                                  width: 2.5,
                                ),
                              ),
                              errorText: errorMessage,
                              counterText: '',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                            onChanged: (value) {
                              setDialogState(() {
                                if (value.trim().isEmpty) {
                                  errorMessage = 'Le nom ne peut pas être vide';
                                } else if (value.trim().length < 2) {
                                  errorMessage =
                                      'Le nom doit contenir au moins 2 caractères';
                                } else {
                                  errorMessage = null;
                                }
                              });
                            },
                          ),
                        ),
                        if (errorMessage != null) ...[
                          SizedBox(height: 10), // réduit de 12
                          Row(
                            children: [
                              Icon(
                                Icons.error_rounded,
                                color: _errorColor,
                                size: 16, // réduit de 18
                              ),
                              SizedBox(width: 8), // réduit de 10
                              Expanded(
                                child: Text(
                                  errorMessage!,
                                  style: TextStyle(
                                    color: _errorColor,
                                    fontSize: 12, // réduit de 13
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        SizedBox(height: 26), // réduit de 32
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 44, // réduit de 52
                                child: TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: TextButton.styleFrom(
                                    backgroundColor: _placeholderColor
                                        .withOpacity(0.12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      side: BorderSide(
                                        color: _placeholderColor.withOpacity(
                                          0.35,
                                        ),
                                        width: 1.2,
                                      ),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Annuler',
                                    style: TextStyle(
                                      color: _placeholderColor,
                                      fontSize: 10, // réduit de 14
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 44, // réduit de 52
                                child: ElevatedButton(
                                  onPressed:
                                      errorMessage == null
                                          ? () {
                                            String newName =
                                                controller.text.trim();
                                            if (newName.isNotEmpty) {
                                              setState(() {
                                                cards[_currentCardIndex]['holder'] =
                                                    newName.toUpperCase();
                                              });
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.check_circle,
                                                        color: Colors.white,
                                                        size: 18,
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        'Nom modifié avec succès',
                                                      ),
                                                    ],
                                                  ),
                                                  backgroundColor:
                                                      _successColor,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                  ),
                                                  duration: Duration(
                                                    seconds: 3,
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                          : null,
                                  style: ButtonStyle(
                                    backgroundColor:
                                        WidgetStateProperty.resolveWith<
                                          Color
                                        >((states) {
                                          if (states.contains(
                                            WidgetState.disabled,
                                          )) {
                                            return _placeholderColor
                                                .withOpacity(0.5);
                                          }
                                          return Colors.transparent;
                                        }),
                                    elevation: WidgetStateProperty.all(0),
                                    padding: WidgetStateProperty.all(
                                      EdgeInsets.zero,
                                    ),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient:
                                          errorMessage == null
                                              ? LinearGradient(
                                                colors: [
                                                  _accentColor,
                                                  _primaryColor,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              )
                                              : LinearGradient(
                                                colors: [
                                                  _placeholderColor.withOpacity(
                                                    0.5,
                                                  ),
                                                  _placeholderColor,
                                                ],
                                              ),
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow:
                                          errorMessage == null
                                              ? [
                                                BoxShadow(
                                                  color: _accentColor
                                                      .withOpacity(0.35),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 3),
                                                ),
                                              ]
                                              : [],
                                    ),
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.save_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Enregistrer',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12, // réduit de 14
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
          ),
    );
  }

  void _replaceCard() {
    if (cards[_currentCardIndex]['isBlocked'] ||
        !cards[_currentCardIndex]['isActive']) {
      _showBlockedOrInactiveCardDialog();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RemplacerScreen(card: cards[_currentCardIndex]),
      ),
    );
  }

  void _manageLimits() {
    if (cards[_currentCardIndex]['isBlocked'] ||
        !cards[_currentCardIndex]['isActive']) {
      _showBlockedOrInactiveCardDialog();
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LimitsScreen()),
    );
  }

  void _showBlockedOrInactiveCardDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.block, color: _errorColor, size: 24),
                SizedBox(width: 8),
                Text(
                  cards[_currentCardIndex]['isBlocked']
                      ? 'Carte bloquée'
                      : 'Carte non activée',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            content: Text(
              cards[_currentCardIndex]['isBlocked']
                  ? 'Cette carte est actuellement bloquée. Veuillez la débloquer pour utiliser cette fonction.'
                  : 'Cette carte n\'est pas encore activée. Veuillez attendre la validation par un expert.',
              style: TextStyle(fontSize: 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Fermer', style: TextStyle(fontSize: 14)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (cards[_currentCardIndex]['isBlocked']) {
                    _navigateToBlocage();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ActiverCarte(
                              cardData: cards[_currentCardIndex],
                            ),
                      ),
                    );
                  }
                },
                child: Text(
                  cards[_currentCardIndex]['isBlocked']
                      ? 'Débloquer'
                      : 'Vérifier l\'activation',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
    );
  }

  PreferredSizeWidget _buildProfessionalAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: _primaryColor,
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _primaryColor,
              _primaryColor.withOpacity(0.9),
              _accentColor.withOpacity(0.3),
            ],
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.2),
                  Colors.white.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mes Cartes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                '${cards.length} carte${cards.length > 1 ? 's' : ''} disponible${cards.length > 1 ? 's' : ''}',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _accentColor.withOpacity(0.9),
                _accentColor.withOpacity(0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: _accentColor.withOpacity(0.4),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NouvelleCarte()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_card_rounded, color: Colors.white, size: 20),
                    SizedBox(width: 6),
                    Text(
                      'Ajouter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildProfessionalAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _primaryColor,
              _primaryColor.withOpacity(0.85),
              _accentColor.withOpacity(0.7),
              _accentColor.withOpacity(0.9),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 24),
                  _buildCardCarousel(),
                  _buildPaginationDots(),
                  _buildActionButtons(),
                  SizedBox(height: 200),
                ],
              ),
              _buildCardManagementSheet(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: HomeNav.CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => Home.HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => CarteScreen()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ActivityScreen()),
            );
          } else if (index == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => MoreScreen.PlusScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildCardCarousel() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentCardIndex = index;
          });
        },
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: _buildCreditCard(cards[index]),
          );
        },
      ),
    );
  }

  Widget _buildCreditCard(Map<String, dynamic> card) {
    bool isBlocked = card['isBlocked'] ?? false;
    bool isActive = card['isActive'] ?? true;
    String cardType = _getSafeCardValue(card, 'type', 'Standard');

    List<Color> cardGradient;
    Color accentColorCard;
    switch (cardType) {
      case 'Physique':
        cardGradient =
            isBlocked || !isActive
                ? [Colors.grey.withOpacity(0.6), Colors.grey.withOpacity(0.4)]
                : [
                  _premiumGradientStart,
                  _premiumGradientEnd,
                  _darkBackground.withOpacity(0.8),
                ];
        accentColorCard = _goldAccent;
        break;
      case 'Voyage':
        cardGradient =
            isBlocked || !isActive
                ? [Colors.grey.withOpacity(0.6), Colors.grey.withOpacity(0.4)]
                : [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF4834d4)];
        accentColorCard = Color(0xFFddd6fe);
        break;
      default:
        cardGradient =
            isBlocked || !isActive
                ? [Colors.grey.withOpacity(0.6), Colors.grey.withOpacity(0.4)]
                : [
                  _primaryColor.withOpacity(0.9),
                  _accentColor.withOpacity(0.8),
                  _darkBackground.withOpacity(0.7),
                ];
        accentColorCard = _accentColor;
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (!isActive && !isBlocked) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActiverCarte(cardData: card),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: cardGradient,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color:
                  isBlocked || !isActive
                      ? Colors.grey.withOpacity(0.3)
                      : _primaryColor.withOpacity(0.4),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Carte $cardType',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'FlexyBanq',
                            style: TextStyle(
                              color: accentColorCard.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 40,
                        height: 28,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:
                                isBlocked || !isActive
                                    ? [Colors.grey, Colors.grey.shade600]
                                    : [
                                      accentColorCard.withOpacity(0.9),
                                      accentColorCard,
                                    ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.credit_card_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    _maskedCardNumber(_getSafeCardValue(card, 'number')),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.5,
                      fontFamily: 'monospace',
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Solde disponible',
                              style: TextStyle(
                                color: accentColorCard.withOpacity(0.8),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.3,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              _getSafeCardValue(card, 'balance', '0 €'),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Expire le',
                            style: TextStyle(
                              color: accentColorCard.withOpacity(0.8),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _getSafeCardValue(card, 'expiry', '12/99'),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              () {
                                String holderName = _getSafeCardValue(
                                  card,
                                  'holder',
                                  'CARDHOLDER',
                                );
                                return holderName.length > 15
                                    ? '${holderName.substring(0, 15)}...'
                                    : holderName;
                              }(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isBlocked)
              Positioned(
                top: 15,
                right: 15,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade600, Colors.red.shade400],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.4),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.block, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text(
                        'BLOQUÉE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (!isActive)
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock, color: _errorColor, size: 24),
                        SizedBox(height: 8),
                        Text(
                          'En attente d\'activation',
                          style: TextStyle(
                            color: _errorColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Appuyez pour vérifier',
                          style: TextStyle(
                            color: _placeholderColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationDots() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          cards.length,
          (index) => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: _currentCardIndex == index ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              gradient:
                  _currentCardIndex == index
                      ? LinearGradient(
                        colors: [Colors.white, Colors.white.withOpacity(0.8)],
                      )
                      : null,
              color:
                  _currentCardIndex == index
                      ? null
                      : Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(4),
              boxShadow:
                  _currentCardIndex == index
                      ? [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.3),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ]
                      : null,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    bool isCurrentCardBlocked = cards[_currentCardIndex]['isBlocked'] ?? false;
    bool isCurrentCardActive = cards[_currentCardIndex]['isActive'] ?? true;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            Icons.lock_outline_rounded,
            'Code PIN',
            onTap: () => _showPinOrNumberDialog('pin'),
            isEnabled: !isCurrentCardBlocked && isCurrentCardActive,
          ),
          _buildActionButton(
            Icons.credit_card_outlined,
            'Numéro',
            onTap: () => _showPinOrNumberDialog('number'),
            isEnabled: !isCurrentCardBlocked && isCurrentCardActive,
          ),
          _buildActionButton(
            isCurrentCardBlocked ? Icons.lock_open_rounded : Icons.lock_rounded,
            isCurrentCardBlocked ? 'Dégel' : 'Geler',
            onTap: _navigateToBlocage,
            isEnabled: isCurrentCardActive,
            isSpecial: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    IconData icon,
    String label, {
    VoidCallback? onTap,
    bool isEnabled = true,
    bool isSpecial = false,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    isEnabled
                        ? (isSpecial
                            ? [
                              _goldAccent.withOpacity(0.9),
                              _goldAccent.withOpacity(0.7),
                            ]
                            : [
                              _accentColor.withOpacity(0.9),
                              _accentColor.withOpacity(0.7),
                            ])
                        : [
                          _accentColor.withOpacity(0.3),
                          _accentColor.withOpacity(0.2),
                        ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow:
                  isEnabled
                      ? [
                        BoxShadow(
                          color: (isSpecial ? _goldAccent : _accentColor)
                              .withOpacity(0.3),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ]
                      : null,
            ),
            child: Icon(
              icon,
              color: isEnabled ? Colors.white : Colors.white.withOpacity(0.5),
              size: 26,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isEnabled ? Colors.white : Colors.white.withOpacity(0.5),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCardManagementSheet() {
    bool isCurrentCardBlocked = cards[_currentCardIndex]['isBlocked'] ?? false;
    bool isCurrentCardActive = cards[_currentCardIndex]['isActive'] ?? true;
    return DraggableScrollableSheet(
      initialChildSize: 0.32,
      minChildSize: 0.32,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.white.withOpacity(0.98)],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: Offset(0, -6),
              ),
            ],
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _placeholderColor.withOpacity(0.6),
                            _placeholderColor.withOpacity(0.3),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _primaryColor.withOpacity(0.1),
                              _accentColor.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.settings_rounded,
                          color: _primaryColor,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Gérer la carte',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _textColor,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildManagementOption(
                    icon: Icons.edit_rounded,
                    title: 'Modifier nom',
                    subtitle:
                        isCurrentCardBlocked || !isCurrentCardActive
                            ? isCurrentCardBlocked
                                ? 'Carte bloquée'
                                : 'Carte non activée'
                            : 'Personnaliser le nom du titulaire',
                    onTap:
                        isCurrentCardBlocked || !isCurrentCardActive
                            ? null
                            : _editCardHolderName,
                    isEnabled: !isCurrentCardBlocked && isCurrentCardActive,
                  ),
                  _buildManagementOption(
                    icon: Icons.refresh_rounded,
                    title: 'Remplacer carte',
                    subtitle:
                        isCurrentCardBlocked || !isCurrentCardActive
                            ? isCurrentCardBlocked
                                ? 'Carte bloquée'
                                : 'Carte non activée'
                            : 'Commander une carte de remplacement',
                    onTap:
                        isCurrentCardBlocked || !isCurrentCardActive
                            ? null
                            : _replaceCard,
                    isEnabled: !isCurrentCardBlocked && isCurrentCardActive,
                  ),
                  _buildManagementOption(
                    icon: Icons.speed_rounded,
                    title: 'Limites & Plafonds',
                    subtitle:
                        isCurrentCardBlocked || !isCurrentCardActive
                            ? isCurrentCardBlocked
                                ? 'Carte bloquée'
                                : 'Carte non activée'
                            : 'Consulter et modifier les limites',
                    onTap:
                        isCurrentCardBlocked || !isCurrentCardActive
                            ? null
                            : _manageLimits,
                    isEnabled: !isCurrentCardBlocked && isCurrentCardActive,
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _successColor.withOpacity(0.1),
                              _successColor.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.toggle_on_rounded,
                          color: _successColor,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Fonctionnalités',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _textColor,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildFeatureToggle(
                    title: 'Paiements en ligne',
                    subtitle: 'Achats sur internet et applications',
                    icon: Icons.shopping_cart_outlined,
                    value:
                        cards[_currentCardIndex]['onlinePaymentsEnabled'] ??
                        true,
                    onChanged:
                        isCurrentCardBlocked || !isCurrentCardActive
                            ? null
                            : (value) {
                              setState(() {
                                cards[_currentCardIndex]['onlinePaymentsEnabled'] =
                                    value;
                              });
                            },
                    isEnabled: !isCurrentCardBlocked && isCurrentCardActive,
                  ),
                  _buildFeatureToggle(
                    title: 'Paiement sans contact',
                    subtitle: 'Transactions NFC et contactless',
                    icon: Icons.contactless_rounded,
                    value:
                        cards[_currentCardIndex]['contactlessEnabled'] ?? false,
                    onChanged:
                        isCurrentCardBlocked || !isCurrentCardActive
                            ? null
                            : (value) {
                              setState(() {
                                cards[_currentCardIndex]['contactlessEnabled'] =
                                    value;
                              });
                            },
                    isEnabled:
                        !isCurrentCardBlocked &&
                        isCurrentCardActive &&
                        _getSafeCardValue(cards[_currentCardIndex], 'type') ==
                            'Physique',
                  ),
                  _buildFeatureToggle(
                    title: 'Transactions par puce',
                    subtitle: 'Paiements avec code PIN',
                    icon: Icons.credit_card_rounded,
                    value:
                        cards[_currentCardIndex]['chipTransactionsEnabled'] ??
                        false,
                    onChanged:
                        isCurrentCardBlocked || !isCurrentCardActive
                            ? null
                            : (value) {
                              setState(() {
                                cards[_currentCardIndex]['chipTransactionsEnabled'] =
                                    value;
                              });
                            },
                    isEnabled:
                        !isCurrentCardBlocked &&
                        isCurrentCardActive &&
                        _getSafeCardValue(cards[_currentCardIndex], 'type') ==
                            'Physique',
                  ),
                  _buildFeatureToggle(
                    title: 'Bande magnétique',
                    subtitle: 'Paiements par glissement',
                    icon: Icons.swipe_rounded,
                    value:
                        cards[_currentCardIndex]['magneticStripeEnabled'] ??
                        false,
                    onChanged:
                        isCurrentCardBlocked || !isCurrentCardActive
                            ? null
                            : (value) {
                              setState(() {
                                cards[_currentCardIndex]['magneticStripeEnabled'] =
                                    value;
                              });
                            },
                    isEnabled:
                        !isCurrentCardBlocked &&
                        isCurrentCardActive &&
                        _getSafeCardValue(cards[_currentCardIndex], 'type') ==
                            'Physique',
                  ),
                  _buildFeatureToggle(
                    title: 'Portefeuille mobile',
                    subtitle: 'Apple Pay, Google Pay, Samsung Pay',
                    icon: Icons.phone_android_rounded,
                    value:
                        cards[_currentCardIndex]['mobileWalletEnabled'] ?? true,
                    onChanged:
                        isCurrentCardBlocked || !isCurrentCardActive
                            ? null
                            : (value) {
                              setState(() {
                                cards[_currentCardIndex]['mobileWalletEnabled'] =
                                    value;
                              });
                            },
                    isEnabled: !isCurrentCardBlocked && isCurrentCardActive,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildManagementOption({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool isEnabled = true,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                isEnabled
                    ? [_inputBackground, _inputBackground.withOpacity(0.7)]
                    : [
                      _inputBackground.withOpacity(0.5),
                      _inputBackground.withOpacity(0.3),
                    ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _primaryColor.withOpacity(isEnabled ? 0.15 : 0.05),
            width: 1.5,
          ),
          boxShadow:
              isEnabled
                  ? [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.08),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors:
                      isEnabled
                          ? [
                            _accentColor.withOpacity(0.2),
                            _primaryColor.withOpacity(0.15),
                          ]
                          : [
                            _placeholderColor.withOpacity(0.1),
                            _placeholderColor.withOpacity(0.05),
                          ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isEnabled ? _primaryColor : _placeholderColor,
                size: 22,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isEnabled ? _textColor : _placeholderColor,
                      letterSpacing: 0.1,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          isEnabled
                              ? _placeholderColor
                              : _placeholderColor.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    isEnabled
                        ? _accentColor.withOpacity(0.1)
                        : _placeholderColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color:
                    isEnabled
                        ? _primaryColor
                        : _placeholderColor.withOpacity(0.6),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureToggle({
    required String title,
    required bool value,
    String? subtitle,
    IconData? icon,
    ValueChanged<bool>? onChanged,
    bool isEnabled = true,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _inputBackground.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _primaryColor.withOpacity(0.08), width: 1),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color:
                    isEnabled
                        ? (value
                            ? _successColor.withOpacity(0.15)
                            : _placeholderColor.withOpacity(0.1))
                        : _placeholderColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color:
                    isEnabled
                        ? (value ? _successColor : _placeholderColor)
                        : _placeholderColor.withOpacity(0.6),
                size: 18,
              ),
            ),
            SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isEnabled ? _textColor : _placeholderColor,
                    letterSpacing: 0.1,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          isEnabled
                              ? _placeholderColor
                              : _placeholderColor.withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: isEnabled ? onChanged : null,
              activeThumbColor: _successColor,
              activeTrackColor: _successColor.withOpacity(0.3),
              inactiveThumbColor: _placeholderColor.withOpacity(0.8),
              inactiveTrackColor: _placeholderColor.withOpacity(0.2),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
