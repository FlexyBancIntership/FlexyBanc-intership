import 'package:flexybank_intership/Views/Home/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReasonOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const ReasonOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });
}

class RemplacerScreen extends StatefulWidget {
  final Map<String, dynamic> card;

  const RemplacerScreen({super.key, required this.card});

  @override
  State<RemplacerScreen> createState() => _RemplacerScreenState();
}

class _RemplacerScreenState extends State<RemplacerScreen>
    with SingleTickerProviderStateMixin {
  static const Color _primaryColor = Color(0xFF16579D);
  static const Color _accentColor = Color(0xFF97DAFF);
  static const Color _inputBackground = Color(0xFFE8F2FF);
  static const Color _placeholderColor = Color(0xFF8DA4C2);
  static const Color _textColor = Color(0xFF1B1D4D);
  static const Color _darkBackground = Color(0xFF1C2526);

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String? _selectedReason;

  static const List<ReasonOption> _reasons = [
    ReasonOption(
      id: 'lost',
      title: 'J\'ai perdu ma carte',
      subtitle: 'Votre carte sera immédiatement bloquée',
      icon: Icons.help_outline_rounded,
      iconColor: Colors.orange,
    ),
    ReasonOption(
      id: 'stolen',
      title: 'Ma carte a été volée',
      subtitle: 'Signalement et blocage immédiat',
      icon: Icons.shield_outlined,
      iconColor: Colors.red,
    ),
    ReasonOption(
      id: 'damaged',
      title: 'Ma carte est endommagée',
      subtitle: 'Remplacement pour défaut technique',
      icon: Icons.build_outlined,
      iconColor: Color(0xFF8DA4C2),
    ),
    ReasonOption(
      id: 'not_working',
      title: 'Ma carte ne fonctionne pas',
      subtitle: 'Problème de fonctionnement',
      icon: Icons.error_outline_rounded,
      iconColor: Color(0xFF97DAFF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutQuart),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutQuart),
      ),
    );
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  void _onReasonSelected(ReasonOption reason) {
    setState(() {
      _selectedReason = reason.id;
    });

    HapticFeedback.lightImpact();

    Future.delayed(const Duration(milliseconds: 200), () {
      _showConfirmationDialog(reason);
    });
  }

  void _showConfirmationDialog(ReasonOption reason) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _ConfirmationDialog(reason: reason),
    );
  }

  PreferredSizeWidget _buildProfessionalAppBar() {
    return AppBar(
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
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.refresh_rounded, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Remplacer la carte',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Nouvelle carte',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
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
              _primaryColor.withOpacity(0.8),
              _accentColor.withOpacity(0.6),
              _accentColor,
            ],
          ),
        ),
        child: SafeArea(
          child: SlideTransition(
            position: _slideAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        Text(
                          'Pourquoi souhaitez-vous remplacer votre carte ?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Sélectionnez le motif qui correspond à votre situation',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(
                          24.0,
                          24.0,
                          24.0,
                          80.0,
                        ), // Added bottom padding
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: _placeholderColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          ..._reasons.asMap().entries.map((entry) {
                            final index = entry.key;
                            final reason = entry.value;
                            return AnimatedContainer(
                              duration: Duration(
                                milliseconds: 300 + (index * 100),
                              ),
                              curve: Curves.easeOutQuart,
                              margin: const EdgeInsets.only(bottom: 16),
                              child: _ReasonCard(
                                reason: reason,
                                isSelected: _selectedReason == reason.id,
                                onTap: () => _onReasonSelected(reason),
                              ),
                            );
                          }),
                          SizedBox(height: 20),
                          _buildFooterInfo(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          HapticFeedback.lightImpact();
        },
      ),
    );
  }

  Widget _buildFooterInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _inputBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _primaryColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.security_rounded, color: Colors.green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sécurité garantie',
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Vos données sont protégées et traitées de manière confidentielle',
                  style: TextStyle(color: _placeholderColor, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReasonCard extends StatefulWidget {
  final ReasonOption reason;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReasonCard({
    required this.reason,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ReasonCard> createState() => _ReasonCardState();
}

class _ReasonCardState extends State<_ReasonCard>
    with SingleTickerProviderStateMixin {
  static const Color _primaryColor = Color(0xFF16579D);
  static const Color _accentColor = Color(0xFF97DAFF);
  static const Color _inputBackground = Color(0xFFE8F2FF);
  static const Color _placeholderColor = Color(0xFF8DA4C2);
  static const Color _textColor = Color(0xFF1B1D4D);

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color:
                widget.isSelected
                    ? _primaryColor.withOpacity(0.05)
                    : _inputBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  widget.isSelected
                      ? _primaryColor
                      : _primaryColor.withOpacity(0.1),
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(
                  widget.isSelected ? 0.15 : 0.08,
                ),
                blurRadius: widget.isSelected ? 15 : 10,
                offset: Offset(0, widget.isSelected ? 6 : 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              _buildIcon(),
              const SizedBox(width: 16),
              _buildContent(),
              _buildTrailingIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            widget.isSelected
                ? widget.reason.iconColor.withOpacity(0.15)
                : widget.reason.iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        widget.reason.icon,
        color:
            widget.isSelected
                ? widget.reason.iconColor
                : widget.reason.iconColor.withOpacity(0.8),
        size: 24,
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.reason.title,
            style: TextStyle(
              color: _textColor,
              fontSize: 16,
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.reason.subtitle,
            style: TextStyle(color: _placeholderColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTrailingIcon() {
    return AnimatedRotation(
      turns: widget.isSelected ? 0.5 : 0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              widget.isSelected
                  ? _primaryColor.withOpacity(0.1)
                  : _accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          widget.isSelected
              ? Icons.check_circle_rounded
              : Icons.arrow_forward_ios,
          color: widget.isSelected ? _primaryColor : _placeholderColor,
          size: widget.isSelected ? 24 : 16,
        ),
      ),
    );
  }
}

class _ConfirmationDialog extends StatelessWidget {
  final ReasonOption reason;

  static const Color _primaryColor = Color(0xFF16579D);
  static const Color _accentColor = Color(0xFF97DAFF);
  static const Color _inputBackground = Color(0xFFE8F2FF);
  static const Color _placeholderColor = Color(0xFF8DA4C2);
  static const Color _textColor = Color(0xFF1B1D4D);

  const _ConfirmationDialog({required this.reason});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 30,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogIcon(),
            const SizedBox(height: 16),
            _buildDialogTitle(),
            const SizedBox(height: 8),
            _buildDialogContent(),
            const SizedBox(height: 24),
            _buildDialogActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogIcon() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: reason.iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(reason.icon, color: reason.iconColor, size: 32),
    );
  }

  Widget _buildDialogTitle() {
    return Text(
      'Confirmation',
      style: TextStyle(
        color: _textColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDialogContent() {
    return Text(
      'Vous avez sélectionné :\n"${reason.title}"\n\n${reason.subtitle}',
      style: TextStyle(color: _placeholderColor, fontSize: 14),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDialogActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: _placeholderColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Annuler',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              // Ici vous pouvez ajouter la logique de traitement
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              'Confirmer',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
