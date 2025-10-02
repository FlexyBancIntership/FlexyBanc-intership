
import 'package:flexybank_intership/Views/Activit%C3%A9/ActivityScreen.dart';
import 'package:flexybank_intership/Views/Home/home_screen.dart';
import 'package:flexybank_intership/Views/More/plus_screen.dart';
import 'package:flexybank_intership/Views/Virement/VirementsScreen.dart';
import 'package:flexybank_intership/Views/carte/CarteScreen.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<double>(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF16579D);
    final Color secondaryColor = const Color(0xFF97DAFF);
    final Color backgroundColor = const Color(0xFFF8F9FA);

    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 5),
          ),
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Accueil',
            index: 0,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
          ),
          _buildNavItem(
            icon: Icons.monetization_on_outlined,
            activeIcon: Icons.monetization_on,
            label: 'Virement',
            index: 1,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
          ),
          _buildNavItem(
            icon: Icons.credit_card_outlined,
            activeIcon: Icons.credit_card,
            label: 'Carte',
            index: 2,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
            isCenter: true,
          ),

          _buildNavItem(
            icon: Icons.show_chart_outlined,
            activeIcon: Icons.show_chart,
            label: 'Activité',
            index: 3,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
          ),
          _buildNavItem(
            icon: Icons.menu_outlined,
            activeIcon: Icons.menu,
            label: 'Plus',
            index: 4,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required Color primaryColor,
    required Color secondaryColor,
    bool isCenter = false,
  }) {
    final bool isActive = widget.currentIndex == index;

    return GestureDetector(
      onTap: () {
        if (!isActive) {
          _animationController.forward().then((_) {
            _animationController.reverse();
          });
        }

        widget.onTap(index);
        _navigateToScreen(index);
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.translate(
            offset: isActive ? Offset(0, _slideAnimation.value) : Offset.zero,
            child: Transform.scale(
              scale:
                  isActive && _animationController.isAnimating
                      ? _scaleAnimation.value
                      : 1.0,
              child: SizedBox(
                width: isCenter ? 55 : 45,
                height: 150, // Hauteur fixe pour éviter l'overflow
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize:
                      MainAxisSize.min, // Important pour éviter l'overflow
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isCenter ? 45 : (isActive ? 38 : 32),
                      height: isCenter ? 45 : (isActive ? 38 : 32),
                      decoration: BoxDecoration(
                        color:
                            isActive || isCenter
                                ? primaryColor
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(isCenter ? 22 : 18),
                        gradient:
                            isActive || isCenter
                                ? LinearGradient(
                                  colors: [primaryColor, secondaryColor],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                                : null,
                        boxShadow:
                            isActive || isCenter
                                ? [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.4),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                                : null,
                      ),
                      child: Center(
                        child: Icon(
                          isActive ? activeIcon : icon,
                          color:
                              isActive || isCenter
                                  ? Colors.white
                                  : Colors.grey.shade600,
                          size: isCenter ? 24 : (isActive ? 20 : 18),
                        ),
                      ),
                    ),
                    if (!isCenter) ...[
                      const SizedBox(height: 2),
                      Flexible(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isActive ? 1.0 : 0.7,
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight:
                                  isActive ? FontWeight.bold : FontWeight.w500,
                              color:
                                  isActive
                                      ? primaryColor
                                      : Colors.grey.shade600,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToScreen(int index) {
    Widget screen;
    switch (index) {
      case 0:
        screen = HomeScreen();
        break;
        case 1:
        screen = VirementsScreen();
        break;
      case 2:
        screen = CarteScreen();
        break;
      case 3:
        screen = ActivityScreen();
        break;
      case 4:
        screen = PlusScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
      ),
    );
  }
}
