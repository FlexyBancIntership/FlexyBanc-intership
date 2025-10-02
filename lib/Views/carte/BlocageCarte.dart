import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BlocageCarte extends StatefulWidget {
  final Map<String, dynamic> card;
  final VoidCallback onConfirm;

  const BlocageCarte({
    super.key,
    required this.card,
    required this.onConfirm,
  });

  @override
  _BlocageCarteState createState() => _BlocageCarteState();
}

class _BlocageCarteState extends State<BlocageCarte> with TickerProviderStateMixin {
  // Align colors with CarteScreen for consistency
  static const Color _primaryColor = Color(0xFF16579D);
  static const Color _accentColor = Color(0xFF97DAFF);
  static const Color _darkBackground = Color(0xFF1C2526);
  static const Color _successColor = Color(0xFF4CAF50);
  static const Color _errorColor = Color(0xFFF44336);
  static const Color _goldAccent = Color(0xFFFFD700);
  static const Color _premiumGradientStart = Color(0xFF2C3E50);
  static const Color _premiumGradientEnd = Color(0xFF4A6741);
  static const Color _inputBackground = Color(0xFFE8F2FF);
  static const Color _placeholderColor = Color(0xFF8DA4C2);
  static const Color _textColor = Color(0xFF1B1D4D);
  static const Color _surfaceColor = Color(0xFFF8F9FA);
  static const Color _textPrimary = Color(0xFF212121);
  static const Color _textSecondary = Color(0xFF757575);
  static const Color _dividerColor = Color(0xFFE0E0E0);

  // State variables
  String _selectedReason = '';
  String _customReason = '';
  bool _isFrozen = false;
  bool _isLoading = false;
  final bool _showReasonDetails = false;

  // Animation controllers
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _cardController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _cardAnimation;

  final List<Map<String, dynamic>> _freezeReasons = [
    {
      'value': 'lost',
      'label': 'Carte perdue',
      'icon': Icons.location_off,
      'description': 'Votre carte a été égarée ou perdue',
      'severity': 'high'
    },
    {
      'value': 'stolen',
      'label': 'Carte volée',
      'icon': Icons.security,
      'description': 'Votre carte a été volée ou compromise',
      'severity': 'critical'
    },
    {
      'value': 'suspicious',
      'label': 'Transactions suspectes',
      'icon': Icons.warning,
      'description': 'Des transactions non autorisées ont été détectées',
      'severity': 'high'
    },
    {
      'value': 'preventive',
      'label': 'Sécurité préventive',
      'icon': Icons.shield,
      'description': 'Mesure de sécurité temporaire',
      'severity': 'medium'
    },
    {
      'value': 'maintenance',
      'label': 'Maintenance technique',
      'icon': Icons.build,
      'description': 'Suspension temporaire pour maintenance',
      'severity': 'low'
    },
    {
      'value': 'other',
      'label': 'Autre raison',
      'icon': Icons.more_horiz,
      'description': 'Spécifiez votre propre motif',
      'severity': 'medium'
    },
  ];

  @override
  void initState() {
    super.initState();
    _isFrozen = widget.card['isFrozen'] ?? false;
    if (_freezeReasons.isNotEmpty) {
      _selectedReason = _freezeReasons[0]['value'];
    }

    // Initialize animations
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _cardController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _cardAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _cardController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _fadeController.forward();
    _cardController.forward(from: 0.0);
    Future.delayed(Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'critical':
        return _errorColor;
      case 'high':
        return Color(0xFFFF9800); // Warning color from original
      case 'medium':
        return _accentColor;
      case 'low':
        return _successColor;
      default:
        return _textSecondary;
    }
  }

  Future<void> _confirmAction() async {
    setState(() {
      _isLoading = true;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Simulate API call
    await Future.delayed(Duration(milliseconds: 1500));

    setState(() {
      _isLoading = false;
    });

    widget.onConfirm();
    Navigator.pop(context, true);

    // Enhanced feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _isFrozen ? Icons.check_circle : Icons.ac_unit,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                _isFrozen ? 'Carte dégelée avec succès' : 'Carte gelée avec succès',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: _isFrozen ? _successColor : _accentColor,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: Column(
            children: [
              _buildModernHeader(),
              Expanded(
                child: AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _slideAnimation.value * 100),
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color: _surfaceColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, -5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35),
                          ),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(24),
                            child: FadeTransition(
                              opacity: _fadeAnimation,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildStatusIndicator(),
                                  SizedBox(height: 24),
                                  _buildTitle(),
                                  SizedBox(height: 24),
                                  _buildEnhancedCardPreview(),
                                  SizedBox(height: 32),
                                  if (!_isFrozen) _buildAdvancedReasonSelection(),
                                  if (!_isFrozen) SizedBox(height: 32),
                                  _buildSecurityInfo(),
                                  SizedBox(height: 32),
                                  _buildActionButtons(),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Gestion de carte',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _isFrozen ? 'Dégeler la carte' : 'Geler la carte',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _isFrozen ? Icons.ac_unit_outlined : Icons.security,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isFrozen
              ? [_errorColor.withOpacity(0.1), _errorColor.withOpacity(0.05)]
              : [_successColor.withOpacity(0.1), _successColor.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isFrozen ? _errorColor.withOpacity(0.3) : _successColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _isFrozen ? _errorColor : _successColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _isFrozen ? Icons.ac_unit : Icons.verified_user,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isFrozen ? 'Carte actuellement gelée' : 'Carte active',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _isFrozen
                      ? 'Toutes les transactions sont suspendues'
                      : 'Toutes les fonctions sont opérationnelles',
                  style: TextStyle(
                    fontSize: 14,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _isFrozen ? 'Dégeler votre carte bancaire' : 'Geler votre carte bancaire',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: _textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _accentColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: _accentColor,
                size: 20,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  _isFrozen
                      ? 'Le dégel réactivera immédiatement toutes les fonctionnalités de votre carte.'
                      : 'Le gel suspend temporairement toutes les transactions tout en préservant votre solde.',
                  style: TextStyle(
                    fontSize: 14,
                    color: _textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedCardPreview() {
    bool isFrozen = _isFrozen;
    String cardType = widget.card['type'] ?? 'Virtuelle';
    List<Color> cardGradient;
    Color accentColorCard;

    switch (cardType) {
      case 'Physique':
        cardGradient = isFrozen
            ? [Colors.grey.withOpacity(0.6), Colors.grey.withOpacity(0.4)]
            : [_premiumGradientStart, _premiumGradientEnd, _darkBackground.withOpacity(0.8)];
        accentColorCard = _goldAccent;
        break;
      case 'Voyage':
        cardGradient = isFrozen
            ? [Colors.grey.withOpacity(0.6), Colors.grey.withOpacity(0.4)]
            : [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF4834d4)];
        accentColorCard = Color(0xFFddd6fe);
        break;
      default:
        cardGradient = isFrozen
            ? [Colors.grey.withOpacity(0.6), Colors.grey.withOpacity(0.4)]
            : [_primaryColor.withOpacity(0.9), _accentColor.withOpacity(0.8), _darkBackground.withOpacity(0.7)];
        accentColorCard = _accentColor;
        break;
    }

    return AnimatedBuilder(
      animation: _cardAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _cardAnimation.value,
          child: Container(
            height: 200, // Aligned height with CarteScreen
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: cardGradient,
              ),
              borderRadius: BorderRadius.circular(20), // Aligned shape (radius 20 like CarteScreen)
              boxShadow: [
                BoxShadow(
                  color: isFrozen ? Colors.grey.withOpacity(0.3) : _primaryColor.withOpacity(0.4),
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
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Background pattern - Enhanced for professionalism
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CustomPaint(
                      painter: CardPatternPainter(
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
                // Card content - Aligned with CarteScreen structure for advanced design
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
                                colors: isFrozen
                                    ? [Colors.grey, Colors.grey.shade600]
                                    : [accentColorCard.withOpacity(0.9), accentColorCard],
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
                        _maskedCardNumber(widget.card['number'] ?? '**** **** **** ****'),
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
                                  widget.card['balance'] ?? '0 €',
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
                                widget.card['expiry'] ?? '12/99',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                      () {
                                    String holderName = widget.card['holder'] ?? 'CARDHOLDER';
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
                // Frozen overlay effect - Enhanced with more professional opacity and icon
                if (isFrozen)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.ac_unit,
                                color: Colors.white.withOpacity(0.8),
                                size: 60,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'GELÉE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
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
          ),
        );
      },
    );
  }

  String _maskedCardNumber(String number) {
    String cleaned = number.replaceAll(' ', '');
    if (cleaned.length < 4) return '**** **** **** ****';
    String last4 = cleaned.substring(cleaned.length - 4);
    return '**** **** **** $last4';
  }

  Widget _buildAdvancedReasonSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.assignment,
              color: _primaryColor,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              'Motif du gel',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),

        // Reason cards
        ...(_freezeReasons.map((reason) => _buildReasonCard(reason)).toList()),

        // Custom reason input
        if (_selectedReason == 'other') ...[
          SizedBox(height: 16),
          _buildCustomReasonInput(),
        ],
      ],
    );
  }

  Widget _buildReasonCard(Map<String, dynamic> reason) {
    bool isSelected = _selectedReason == reason['value'];
    Color severityColor = _getSeverityColor(reason['severity']);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReason = reason['value'];
        });
        HapticFeedback.selectionClick();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? severityColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? severityColor : _dividerColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: severityColor.withOpacity(0.2),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? severityColor : severityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                reason['icon'],
                color: isSelected ? Colors.white : severityColor,
                size: 20,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reason['label'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? severityColor : _textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    reason['description'],
                    style: TextStyle(
                      fontSize: 13,
                      color: _textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: severityColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomReasonInput() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _accentColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: _accentColor.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit, color: _accentColor, size: 20),
              SizedBox(width: 8),
              Text(
                'Motif personnalisé',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          TextField(
            onChanged: (value) {
              setState(() {
                _customReason = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Saisissez le motif de gel de votre carte...',
              hintStyle: TextStyle(color: _textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: _accentColor, width: 2),
              ),
              contentPadding: EdgeInsets.all(16),
              filled: true,
              fillColor: _surfaceColor,
            ),
            style: TextStyle(
              fontSize: 14,
              color: _textPrimary,
            ),
            maxLines: 3,
            maxLength: 250,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityInfo() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _dividerColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: _accentColor,
                size: 24,
              ),
              SizedBox(width: 12),
              Text(
                'Informations financières',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          _buildInfoRow('Solde actuel', widget.card['balance'], Icons.account_balance),
          _buildInfoDivider(),
          _buildInfoRow('Limite quotidienne', '2 500 TND', Icons.credit_card),
          _buildInfoDivider(),
          _buildInfoRow('Dernière transaction', 'Aujourd\'hui 14:30', Icons.history),

          SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isFrozen
                    ? [_successColor.withOpacity(0.1), _successColor.withOpacity(0.05)]
                    : [Color(0xFFFF9800).withOpacity(0.1), Color(0xFFFF9800).withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  _isFrozen ? Icons.lock_open : Icons.lock,
                  color: _isFrozen ? _successColor : Color(0xFFFF9800),
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isFrozen
                        ? 'Le dégel restaurera l\'accès complet à votre compte.'
                        : 'Le gel bloquera tous les paiements et retraits.',
                    style: TextStyle(
                      fontSize: 14,
                      color: _textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: _textSecondary,
            size: 18,
          ),
          SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: _textSecondary,
            ),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoDivider() {
    return Divider(
      color: _dividerColor,
      thickness: 1,
      height: 1,
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Primary action button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _confirmAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isFrozen ? _successColor : _errorColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: _isLoading ? 0 : 8,
              shadowColor: (_isFrozen ? _successColor : _errorColor).withOpacity(0.4),
            ),
            child: _isLoading
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  'Traitement en cours...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isFrozen ? Icons.lock_open : Icons.ac_unit,
                  size: 20,
                ),
                SizedBox(width: 12),
                Text(
                  _isFrozen ? 'Confirmer le dégel' : 'Confirmer le gel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),

        // Secondary action button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: _textSecondary,
              side: BorderSide(color: _dividerColor, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Annuler',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        SizedBox(height: 20),

        // Help section
        GestureDetector(
          onTap: () {
            _showHelpDialog();
          },
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.help_outline,
                  color: _accentColor,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Besoin d\'aide ? Contactez le support',
                  style: TextStyle(
                    color: _accentColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.support_agent, color: _primaryColor),
              SizedBox(width: 12),
              Text(
                'Support client',
                style: TextStyle(
                  color: _textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildContactOption(
                'Appelez-nous',
                '+216 70 123 456',
                Icons.phone,
                _successColor,
              ),
              SizedBox(height: 12),
              _buildContactOption(
                'Chat en ligne',
                'Disponible 24h/24',
                Icons.chat,
                _accentColor,
              ),
              SizedBox(height: 12),
              _buildContactOption(
                'Email',
                'support@banque.tn',
                Icons.email,
                Color(0xFFFF9800),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Fermer',
                style: TextStyle(color: _primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildContactOption(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: _textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardPatternPainter extends CustomPainter {
  final Color color;

  CardPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw geometric pattern - Enhanced for more advanced look
    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 6; j++) {
        final rect = Rect.fromLTWH(
          i * (size.width / 10),
          j * (size.height / 6),
          size.width / 10,
          size.height / 6,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(6)),
          paint,
        );
      }
    }

    // Draw diagonal lines - More lines for complexity
    for (int i = 0; i < 20; i++) {
      canvas.drawLine(
        Offset(i * 20.0, 0),
        Offset(i * 20.0 - size.height, size.height),
        paint..strokeWidth = 0.4,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}