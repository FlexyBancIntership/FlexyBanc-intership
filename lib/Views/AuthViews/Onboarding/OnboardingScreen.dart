import 'package:flexybank_intership/Views/AuthViews/SignIn/SignInScreen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

/// Écran d'onboarding avec un carrousel de pages pour présenter les fonctionnalités de FlexyBank.
/// Design professionnel et avancé pour une app bancaire mobile : minimaliste, fluide et sécurisant.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  // Contrôleur de page pour naviguer dans les pages d'onboarding
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;
  late AnimationController _buttonAnimationController;
  late AnimationController _textAnimationController;

  // Contrôleurs vidéo pour chaque page
  late List<VideoPlayerController> _videoControllers;
  List<bool> _isVideoInitialized = [];

  // Données d'onboarding : titre, sous-titre, vidéo
  static const List<Map<String, dynamic>> onboardingData = [
    {
      'title': 'Votre avenir bancaire commence ici.',
      'subtitle':
          'Votre solution bancaire digitale sécurisée, accessible partout dans le monde.',
      'video': 'assets/videos/1.mp4',
    },
    {
      'title': 'Gestion complète de vos comptes',
      'subtitle':
          'Visualisation des soldes et des transactions en temps réel. Notifications intelligentes.',
      'video': 'assets/videos/2.mp4',
    },
    {
      'title': 'Transferts & paiements simplifiés',
      'subtitle':
          'Transferts nationaux et internationaux. Paiement de factures et services.',
      'video': 'assets/videos/3.mp4',
    },
    {
      'title': 'Gestion avancée des cartes',
      'subtitle':
          'Création de cartes physiques, virtuelles, ou de voyage. Modification du code PIN, gel temporaire, plafonds personnalisés.',
      'video': 'assets/videos/4.mp4',
    },
    {
      'title': 'Sécurité & Conformité',
      'subtitle':
          'Profitez d\'une plateforme sécurisée avec des protocoles de protection avancés.',
      'video': 'assets/videos/5.mp4',
    },
    {
      'title': 'Services pour les Tunisiens à l\'étranger',
      'subtitle':
          'Ouverture de compte à distance via Bridge API. Transferts internationaux facilités. Gestion multidevises.',
      'video': 'assets/videos/6.mp4',
    },
  ];

  // Palette de couleurs professionnelle pour l'app bancaire
  static const Color _primaryColor = Color(0xFF16579D); // Bleu marine
  static const Color _accentColor = Color(0xFF97DAFF); // Bleu clair
  static const Color _textColor = Color(0xFF1B1D4D); // Texte principal
  static const Color _darkBackground = Color(0xFF1C2526); // Fond foncé
  static const Color _inputBackground = Color(0xFFE8F2FF); // Fond clair
  static const Color _goldAccent = Color(0xFFD4AF37); // Accent or
  static const Color _lightBlue = Color(0xFF7BB3E0); // Bleu moyen

  // Échelle vidéo
  double videoScale = 1;

  @override
  void initState() {
    super.initState();
    _initializeVideoControllers();

    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..repeat(reverse: true);

    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _timer = Timer.periodic(const Duration(seconds: 8), (Timer timer) {
      if (_currentPage < onboardingData.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOutCubic,
      );
      _textAnimationController.reset();
      _textAnimationController.forward();
    });

    _pageController.addListener(() {
      int newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        _pauseAllVideos();
        setState(() {
          _currentPage = newPage;
        });
        _playCurrentVideo();
        _textAnimationController.reset();
        _textAnimationController.forward();
      }
    });
  }

  void _initializeVideoControllers() {
    _videoControllers = [];
    _isVideoInitialized = List.filled(onboardingData.length, false);

    for (int i = 0; i < onboardingData.length; i++) {
      final controller = VideoPlayerController.asset(
        onboardingData[i]['video'],
      );

      controller
          .initialize()
          .then((_) {
            controller.setLooping(true);
            controller.setVolume(0.0);

            if (mounted) {
              setState(() {
                _isVideoInitialized[i] = true;
              });

              if (i == _currentPage) {
                controller.play();
              }
            }
          })
          .catchError((error) {
            print(
              "Error initializing video ${onboardingData[i]['video']}: $error",
            );
          });

      _videoControllers.add(controller);
    }
  }

  void _playCurrentVideo() {
    if (_currentPage < _videoControllers.length &&
        _videoControllers[_currentPage].value.isInitialized) {
      _videoControllers[_currentPage].play();
    }
  }

  void _pauseAllVideos() {
    for (int i = 0; i < _videoControllers.length; i++) {
      if (i != _currentPage && _videoControllers[i].value.isInitialized) {
        _videoControllers[i].pause();
        _videoControllers[i].seekTo(Duration.zero);
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    _buttonAnimationController.dispose();
    _textAnimationController.dispose();
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // PageView pour les pages d'onboarding
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              _pauseAllVideos();
              setState(() {
                _currentPage = page;
              });
              _playCurrentVideo();
            },
            itemCount: onboardingData.length,
            itemBuilder: (context, index) {
              return OnboardingPage(
                title: onboardingData[index]['title']!,
                subtitle: onboardingData[index]['subtitle']!,
                videoController: _videoControllers[index],
                isVideoInitialized: _isVideoInitialized[index],
                videoScale: videoScale,
              );
            },
          ),

          // Dégradation statique principale avec effet de fusion professionnel
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _darkBackground.withOpacity(0.6), // Minimisé
                    _primaryColor.withOpacity(0.7),
                    _accentColor.withOpacity(0.5),
                    _lightBlue.withOpacity(0.6),
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.15),
                    _lightBlue.withOpacity(0.4),
                    _accentColor.withOpacity(0.5),
                    _primaryColor.withOpacity(0.7),
                    _darkBackground.withOpacity(0.6),
                  ],
                  stops: const [
                    0.0,
                    0.1,
                    0.2,
                    0.3,
                    0.45,
                    0.55,
                    0.7,
                    0.8,
                    0.9,
                    1.0,
                  ],
                ),
              ),
            ),
          ),

          // Effet de vignette professionnel pour les bords
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    _darkBackground.withOpacity(0.1),
                    _darkBackground.withOpacity(0.2),
                    _darkBackground.withOpacity(0.4),
                  ],
                  stops: const [0.0, 0.4, 0.6, 0.8, 1.0],
                ),
              ),
            ),
          ),

          // Header avec texte de bienvenue et indicateurs
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Texte de bienvenue statique
                Text(
                  'Bienvenue sur FlexyBank',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 2),
                        blurRadius: 10,
                        color: _primaryColor.withOpacity(0.5),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Indicateurs de page améliorés
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (index) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 600),
                            height: 4,
                            decoration: BoxDecoration(
                              color:
                                  _currentPage == index
                                      ? null
                                      : Colors.white.withOpacity(0.2),
                              gradient:
                                  _currentPage == index
                                      ? LinearGradient(
                                        colors: [_accentColor, _lightBlue],
                                      )
                                      : null,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      _currentPage == index
                                          ? _accentColor.withOpacity(0.4)
                                          : Colors.transparent,
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Titre et sous-titre avec design simplifié et professionnel
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: FadeTransition(
                    opacity: _textAnimationController,
                    child: Column(
                      children: [
                        Text(
                          onboardingData[_currentPage]['title']!,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.2,
                            letterSpacing: 0.3,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 2),
                                blurRadius: 10,
                                color: _primaryColor.withOpacity(0.6),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          onboardingData[_currentPage]['subtitle']!,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.4,
                            letterSpacing: 0.2,
                            shadows: [
                              Shadow(
                                offset: const Offset(0, 1),
                                blurRadius: 6,
                                color: _darkBackground.withOpacity(0.4),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bouton avancé avec contour lumineux et effet glow
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _buttonAnimationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + _buttonAnimationController.value,
                    child: Container(
                      width: 280,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_primaryColor, _accentColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: _accentColor.withOpacity(0.7),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _accentColor.withOpacity(
                              0.3 + _buttonAnimationController.value * 0.2,
                            ),
                            blurRadius:
                                12 + _buttonAnimationController.value * 4,
                            spreadRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: _primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap:
                              () => _navigateTo(context, const SignInScreen()),
                          borderRadius: BorderRadius.circular(28),
                          splashColor: _accentColor.withOpacity(0.4),
                          highlightColor: _lightBlue.withOpacity(0.2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'COMMENCER À EXPLORER',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 1),
                                      blurRadius: 4,
                                      color: _darkBackground.withOpacity(0.3),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedSlide(
                                offset: Offset(
                                  0.2 * _buttonAnimationController.value,
                                  0,
                                ),
                                duration: const Duration(milliseconds: 2000),
                                curve: Curves.easeInOut,
                                child: Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 20,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 1),
                                      blurRadius: 4,
                                      color: _darkBackground.withOpacity(0.3),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigation avec transition fluide
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            ),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOutCubic,
                ),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 1200),
      ),
    );
  }
}

/// Page individuelle d'onboarding avec vidéo et effet de fusion
class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final VideoPlayerController? videoController;
  final bool isVideoInitialized;
  final double videoScale;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    this.videoController,
    required this.isVideoInitialized,
    this.videoScale = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1C2526),
      child: Stack(
        children: [
          // Vidéo avec effet de fusion subtil
          if (videoController != null && isVideoInitialized)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Stack(
                  children: [
                    // Vidéo principale
                    Transform.scale(
                      scale: videoScale,
                      child: AspectRatio(
                        aspectRatio: videoController!.value.aspectRatio,
                        child: VideoPlayer(videoController!),
                      ),
                    ),

                    // Dégradation radiale pour fondre les bords
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: 1.2,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              const Color(0xFF1C2526).withOpacity(0.15),
                              const Color(0xFF1C2526).withOpacity(0.3),
                            ],
                            stops: const [0.0, 0.7, 0.9, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // Dégradation linéaire verticale en bas
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Colors.transparent,
                              const Color(0xFF1C2526).withOpacity(0.2),
                              const Color(0xFF1C2526).withOpacity(0.4),
                            ],
                            stops: const [0.0, 0.6, 0.8, 0.9, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Placeholder si la vidéo n'est pas initialisée
          if (videoController == null || !isVideoInitialized)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF97DAFF)),
              ),
            ),
        ],
      ),
    );
  }
}
