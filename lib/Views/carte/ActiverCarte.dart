import 'package:flexybank_intership/Views/carte/CarteScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:async';

class ActiverCarte extends StatefulWidget {
  final Map<String, dynamic> cardData;

  const ActiverCarte({super.key, required this.cardData});

  @override
  _ActiverCarteState createState() => _ActiverCarteState();
}

class _ActiverCarteState extends State<ActiverCarte> with TickerProviderStateMixin {
  // Theme colors - Enhanced professional palette
  static const Color _primaryColor = Color(0xFF16579D);
  static const Color _accentColor = Color(0xFF97DAFF);
  static const Color _secondaryAccent = Color(0xFF4A90E2);
  static const Color _inputBackground = Color(0xFFE8F2FF);
  static const Color _placeholderColor = Color(0xFF8DA4C2);
  static const Color _textColor = Color(0xFF1B1D4D);
  static const Color _darkBackground = Color(0xFF1C2526);
  static const Color _surfaceColor = Color(0xFFF8FBFF);
  static const Color _shadowColor = Color(0xFF16579D);
  static const Color _successColor = Color(0xFF4CAF50);
  static const Color _warningColor = Color(0xFFFF9800);
  static const Color _errorColor = Color(0xFFF44336);
  static const Color _goldColor = Color(0xFFFFD700);
  static const Color _premiumStart = Color(0xFF2C3E50);
  static const Color _premiumEnd = Color(0xFF4A6741);

  // Authentication and state management
  final LocalAuthentication auth = LocalAuthentication();
  final _formKey = GlobalKey<FormState>();

  // Activation method based on card type
  String get _activationMethod => widget.cardData['activationMethod'] ?? 'expert_validation';
  String get _cardType => widget.cardData['type'] ?? 'Virtuelle';

  // Controllers for different activation methods
  final List<TextEditingController> _codeControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  // Animation controllers
  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late AnimationController _statusAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  // State variables
  bool _isProcessing = false;
  bool _isWaitingForExpert = false;
  bool _isWaitingForNotification = false;
  String _activationStatus = 'pending'; // pending, expert_review, notification_sent, activated, failed
  Timer? _statusCheckTimer;
  int _remainingHours = 48; // hours for expert review simulation

  // Getters sécurisés pour les données de carte
  String get _safeCardNumber => widget.cardData['number']?.toString() ?? '0000 0000 0000 0000';
  String get _safeHolderName => (widget.cardData['holderName']?.toString() ?? widget.cardData['holder']?.toString() ?? 'TITULAIRE DE CARTE').toUpperCase();
  String get _safeExpiry => widget.cardData['expiry']?.toString() ?? '12/99';
  String get _safeBalance => widget.cardData['balance']?.toString() ?? '0 €';

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkInitialActivationStatus();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _statusAnimationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.easeInOut),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _statusAnimationController, curve: Curves.linear),
    );

    _animationController.forward();
    _cardAnimationController.repeat(reverse: true);
  }

  void _checkInitialActivationStatus() {
    bool isAlreadyActive = widget.cardData['isActive'] == true;

    if (isAlreadyActive) {
      setState(() {
        _activationStatus = 'activated';
      });
      return;
    }

    _startExpertReview();
  }

  Map<String, dynamic> _createSafeCardData({bool isActive = false}) {
    return {
      'type': _cardType,
      'number': _safeCardNumber,
      'holder': _safeHolderName,
      'holderName': _safeHolderName,
      'balance': isActive ? _safeBalance : '0 €',
      'expiry': _safeExpiry,
      'isActive': isActive,
      'isBlocked': false,
      'activationMethod': _activationMethod,
      'pin': '0000',
      'onlinePaymentsEnabled': true,
      'contactlessEnabled': _cardType == 'Physique',
      'magneticStripeEnabled': _cardType == 'Physique',
      'chipTransactionsEnabled': _cardType == 'Physique',
      'mobileWalletEnabled': true,
      'limits': {'daily': 1000.0, 'monthly': 5000.0},
    };
  }

  void _startExpertReview() {
    setState(() {
      _isWaitingForExpert = true;
      _activationStatus = 'expert_review';
      _remainingHours = 48;
    });

    _statusAnimationController.repeat();

    _statusCheckTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _remainingHours = (_remainingHours - 1 / 3600).clamp(0, 48).toInt();
        });

        if (_remainingHours <= 0) {
          timer.cancel();
          _statusAnimationController.stop();
          _completeExpertReview();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _completeExpertReview() {
    if (mounted) {
      setState(() {
        _isWaitingForExpert = false;
        _activationStatus = 'notification_sent';
        _isWaitingForNotification = true;
      });

      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          _sendSecureNotification();
        }
      });
    }
  }

  void _sendSecureNotification() {
    if (mounted) {
      setState(() {
        _isWaitingForNotification = false;
      });

      // Check if the current route is ActiverCarte
      if (ModalRoute.of(context)?.isCurrent == true) {
        _showNotificationDialog();
      } else {
        // Notify CarteScreen to show the dialog
        // We will handle this in CarteScreen
      }
    }
  }

  void _showNotificationDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.white.withOpacity(0.95)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _shadowColor.withOpacity(0.2),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_successColor, _successColor.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _successColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.security_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Code d\'activation reçu',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _textColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Un expert bancaire a validé votre demande.\nVotre code d\'activation sécurisé est prêt.',
                style: TextStyle(
                  fontSize: 14,
                  color: _placeholderColor,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_accentColor.withOpacity(0.1), _primaryColor.withOpacity(0.05)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _primaryColor.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.fingerprint, color: _primaryColor, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Authentifiez-vous pour voir le code d\'activation',
                        style: TextStyle(
                          fontSize: 13,
                          color: _textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: _placeholderColor.withOpacity(0.1),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Plus tard',
                        style: TextStyle(
                          color: _placeholderColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_accentColor, _primaryColor],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: _accentColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _authenticateAndShowCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fingerprint, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Authentifier',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
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
    );
  }

  Future<void> _authenticateAndShowCode() async {
    if (!mounted) return;
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: "Authentifiez-vous pour voir le code d'activation",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: false,
        ),
      );

      if (authenticated && mounted) {
        Navigator.pop(context);
        _showActivationCode();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Échec de l\'authentification'),
            backgroundColor: _errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showActivationCode() {
    if (!mounted) return;

    final activationCode = '248193'; // This would come from the server

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white.withOpacity(0.95)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _shadowColor.withOpacity(0.2),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_goldColor, _goldColor.withOpacity(0.8)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _goldColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.verified_user, color: Colors.white, size: 28),
              ),
              SizedBox(height: 16),
              Text(
                'Code d\'activation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _textColor,
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_inputBackground, _inputBackground.withOpacity(0.5)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _primaryColor.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      activationCode,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: _primaryColor,
                        letterSpacing: 8,
                        fontFamily: 'monospace',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Code valide pendant 10 minutes',
                      style: TextStyle(
                        fontSize: 12,
                        color: _placeholderColor,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_accentColor, _primaryColor],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    for (int i = 0; i < activationCode.length; i++) {
                      _codeControllers[i].text = activationCode[i];
                    }
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Utiliser ce code',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    Timer(Duration(minutes: 10), () {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardAnimationController.dispose();
    _statusAnimationController.dispose();
    _statusCheckTimer?.cancel();
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surfaceColor,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              _primaryColor.withOpacity(0.08),
              _surfaceColor,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildBody(),
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: _accentColor.withOpacity(0.4),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarteScreen(newCard: widget.cardData),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.credit_card, size: 20),
                SizedBox(width: 8),
                Text(
                  'Mon carte',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      leading: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: _shadowColor.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: _textColor, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      title: Text(
        'Activation de carte',
        style: TextStyle(
          color: _textColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
      centerTitle: false,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 16, top: 8, bottom: 8),
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [_accentColor.withOpacity(0.2), _primaryColor.withOpacity(0.1)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _primaryColor.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.security, color: _primaryColor, size: 16),
              SizedBox(width: 4),
              Text(
                'Sécurisé',
                style: TextStyle(
                  color: _primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // La fonction _buildStatusHeader ici ne contient plus le switch et doit être modifiée ou elle peut disparaître selon besoin
          //_buildStatusHeader(),
          SizedBox(height: 32),
          _buildCardPreview(),
          SizedBox(height: 32),
          _buildActivationContent(),
          SizedBox(height: 32),
          if (_activationStatus == 'pending' || (_activationStatus == 'notification_sent' && _codeControllers.any((c) => c.text.isNotEmpty)))
            _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildStatusHeader() {
    // Cette fonction est à modifier ou à retirer vu que le switch est supprimé
    // Ici on retourne par exemple une version très simple statique ou rien :
    return SizedBox.shrink();
  }

  Widget _buildCardPreview() {
    List<Color> cardColors = _getCardColors();
    return AnimatedBuilder(
      animation: _cardAnimationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: cardColors[0].withOpacity(0.3),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: cardColors,
                      ),
                    ),
                  ),
                  _buildCardPatterns(),
                  _buildCardContent(),
                  if (_activationStatus != 'activated') _buildInactiveOverlay(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Color> _getCardColors() {
    switch (_cardType.toLowerCase()) {
      case 'physique':
        return [_premiumStart, _premiumEnd, _darkBackground.withOpacity(0.8)];
      case 'voyage':
        return [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF4834d4)];
      default:
        return [_primaryColor, _primaryColor.withOpacity(0.8), _accentColor.withOpacity(0.6)];
    }
  }

  Widget _buildCardPatterns() {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          bottom: -30,
          left: -30,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          top: 60,
          right: 20,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardContent() {
    return Padding(
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
                    'Carte $_cardType',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'FlexyBanq',
                    style: TextStyle(
                      color: _accentColor.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              Container(
                width: 40,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.3), Colors.white.withOpacity(0.1)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.memory,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            _safeCardNumber,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
              fontFamily: 'monospace',
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TITULAIRE',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _safeHolderName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'EXPIRE FIN',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _safeExpiry,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInactiveOverlay() {
    return GestureDetector(
      onTap: () {
        // Already on activation page, no need to navigate
      },
      child: Container(
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
                if (_activationStatus == 'expert_review') ...[
                  SizedBox(height: 8),
                  Text(
                    'Temps estimé: ${_remainingHours}h',
                    style: TextStyle(
                      color: _placeholderColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivationContent() {
    if (_activationStatus == 'activated') {
      return _buildActivatedInfo();
    } else if (_activationStatus == 'expert_review') {
      return _buildExpertReviewInfo();
    } else if (_activationStatus == 'notification_sent' || _activationStatus == 'pending') {
      return _buildCodeInputSection();
    } else if (_activationStatus == 'failed') {
      return _buildFailedInfo();
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildActivatedInfo() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_successColor.withOpacity(0.1), Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _successColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.check_circle, color: _successColor, size: 48),
          SizedBox(height: 16),
          Text(
            'Activation réussie !',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Votre carte est maintenant active et prête à l\'emploi.',
            style: TextStyle(color: _placeholderColor, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExpertReviewInfo() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_warningColor.withOpacity(0.1), Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _warningColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _statusAnimationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14,
                child: Icon(Icons.hourglass_full, color: _warningColor, size: 48),
              );
            },
          ),
          SizedBox(height: 16),
          Text(
            'Examen par expert',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Votre demande est en cours de validation par un expert bancaire. Cela peut prendre jusqu\'à 24-48 heures.',
            style: TextStyle(color: _placeholderColor, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          LinearProgressIndicator(
            backgroundColor: _warningColor.withOpacity(0.2),
            color: _warningColor,
          ),
        ],
      ),
    );
  }

  Widget _buildFailedInfo() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_errorColor.withOpacity(0.1), Colors.white],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _errorColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: _errorColor, size: 48),
          SizedBox(height: 16),
          Text(
            'Échec de l\'activation',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _textColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Veuillez vérifier le code et réessayer, ou contacter le support.',
            style: TextStyle(color: _placeholderColor, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _activationStatus = 'pending';
              });
            },
            icon: Icon(Icons.refresh, color: _primaryColor),
            label: Text(
              'Réessayer',
              style: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Code d\'activation',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          _activationMethod == 'postal_code'
              ? 'Saisissez le code à 6 chiffres reçu par courrier postal'
              : 'Saisissez le code reçu après validation experte',
          style: TextStyle(
            fontSize: 14,
            color: _placeholderColor,
          ),
        ),
        SizedBox(height: 20),
        Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              return Container(
                width: 48,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _codeControllers[index].text.isNotEmpty
                        ? _primaryColor
                        : Colors.grey.withOpacity(0.3),
                    width: _codeControllers[index].text.isNotEmpty ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _shadowColor.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _codeControllers[index],
                  focusNode: _focusNodes[index],
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    hintText: '•',
                    hintStyle: TextStyle(
                      color: _placeholderColor.withOpacity(0.5),
                      fontSize: 24,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                    if (value.length == 1) {
                      if (index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      } else {
                        _focusNodes[index].unfocus();
                      }
                    } else if (value.isEmpty && index > 0) {
                      _focusNodes[index - 1].requestFocus();
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: TextButton.icon(
            onPressed: () {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_activationMethod == 'postal_code'
                        ? 'Un nouveau code sera envoyé par courrier postal'
                        : 'Demande de nouvelle validation experte envoyée'),
                    backgroundColor: _primaryColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            icon: Icon(Icons.refresh, color: _primaryColor, size: 18),
            label: Text(
              _activationMethod == 'postal_code'
                  ? 'Demander un nouveau code postal'
                  : 'Demander une nouvelle validation',
              style: TextStyle(
                color: _primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    final bool isCodeComplete = _codeControllers.every((controller) => controller.text.isNotEmpty);

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        boxShadow: isCodeComplete && !_isProcessing
            ? [
          BoxShadow(
            color: _accentColor.withOpacity(0.4),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: (!_isProcessing && isCodeComplete) ? _activateCard : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isCodeComplete ? _accentColor : _placeholderColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isProcessing
            ? SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCodeComplete ? Icons.check_circle_outline : Icons.lock_outline,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              isCodeComplete ? 'Activer ma carte' : 'Complétez le code',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _activateCard() {
    if (!mounted) return;

    if (_formKey.currentState!.validate()) {
      bool allFieldsFilled = _codeControllers.every((controller) => controller.text.isNotEmpty);

      if (!allFieldsFilled) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.warning, color: Colors.white),
                SizedBox(width: 8),
                Text('Veuillez remplir tous les champs du code'),
              ],
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      setState(() {
        _isProcessing = true;
      });

      Future.delayed(Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _isProcessing = false;
            _activationStatus = 'activated';
          });

          final activatedCard = _createSafeCardData(isActive: true);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Carte activée !',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _textColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Votre carte est maintenant prête à être utilisée',
                    style: TextStyle(
                      fontSize: 14,
                      color: _placeholderColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarteScreen(newCard: activatedCard),
                        ),
                            (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Continuer'),
                  ),
                ],
              ),
            ),
          );
        }
      });
    }
  }
}
