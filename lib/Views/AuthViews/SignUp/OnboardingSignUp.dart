import 'dart:async';
import 'dart:io';
import 'package:flexybank_intership/Views/AuthViews/SignIn/SignInScreen.dart';
import 'package:flexybank_intership/Views/AuthViews/SignUp/ActivityTypeScreen.dart';
import 'package:flexybank_intership/Views/AuthViews/SignUp/ContactExpert.dart';
import 'package:flexybank_intership/Views/AuthViews/SignUp/EmailStep.dart';
import 'package:flexybank_intership/Views/AuthViews/SignUp/EmailVerificationStep.dart';
import 'package:flexybank_intership/Views/AuthViews/SignUp/ImprovementScreen.dart';
import 'package:flexybank_intership/Views/AuthViews/SignUp/Payment.dart';
import 'package:flexybank_intership/Views/AuthViews/SignUp/PaymentPack.dart';
import 'package:flexybank_intership/Views/AuthViews/SignUp/PersonalInfoStep.dart';
import 'package:flexybank_intership/Views/AuthViews/SignUp/PhoneStep.dart';
import 'package:flexybank_intership/Views/AuthViews/SignUp/PhoneVerificationStep.dart';
import 'package:flexybank_intership/Views/AuthViews/SignUp/RendezvousExpert.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


/// Onboarding flow for user sign-up, conditionally showing ActivityTypeScreen based on account type
class OnboardingSignUp extends StatefulWidget {
  final String accountType; // 'personal' or 'enterprise'

  const OnboardingSignUp({super.key, required this.accountType});

  @override
  _OnboardingSignUpState createState() => _OnboardingSignUpState();
}

class _OnboardingSignUpState extends State<OnboardingSignUp> with TickerProviderStateMixin {
  // Controllers and focus nodes
  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _codeControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _phoneCodeControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _phoneFocusNodes = List.generate(4, (_) => FocusNode());
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _idCardController = TextEditingController();

  // State variables
  int _currentStep = 1;
  int get _totalSteps => widget.accountType == 'enterprise' ? 11 : 10; // Dynamic step count
  String? _emailError;
  String? _phoneError;
  String? _firstNameError;
  String? _lastNameError;
  String? _birthDateError;
  String? _idCardError;
  bool _isEmailValid = false;
  bool _isPhoneValid = false;
  bool _isPersonalInfoValid = false;
  bool _isActivityTypeValid = false;
  bool _isImprovementValid = false;
  int _timerSeconds = 60;
  int _phoneTimerSeconds = 60;
  Timer? _timer;
  Timer? _phoneTimer;
  bool _isCodeValid = true;
  bool _isPhoneCodeValid = true;
  File? _idCardImage;
  final ImagePicker _picker = ImagePicker();
  String? _selectedActivityType;
  List<String> _selectedImprovements = [];

  // Country selection
  String _selectedCountry = 'TN';
  String _selectedCountryCode = '+216';
  String _selectedCountryName = 'Tunisie';
  final List<Map<String, String>> _countries = [
    {'name': 'Tunisie', 'code': 'TN', 'dialCode': '+216', 'flag': '🇹🇳'},
    {'name': 'France', 'code': 'FR', 'dialCode': '+33', 'flag': '🇫🇷'},
    {'name': 'Maroc', 'code': 'MA', 'dialCode': '+212', 'flag': '🇲🇦'},
    {'name': 'Algérie', 'code': 'DZ', 'dialCode': '+213', 'flag': '🇩🇿'},
  ];

  // Animation controllers
  late AnimationController _buttonAnimationController;
  late AnimationController _codeAnimationController;
  late AnimationController _timerAnimationController;
  late Animation<double> _buttonScaleAnimation;
  late Animation<double> _codeScaleAnimation;
  late Animation<Color?> _buttonColorAnimation;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateEmail);
    _phoneController.addListener(_validatePhone);
    _firstNameController.addListener(_validatePersonalInfo);
    _lastNameController.addListener(_validatePersonalInfo);
    _birthDateController.addListener(_validatePersonalInfo);
    _idCardController.addListener(_validatePersonalInfo);
    _initializeAnimations();
  }

  /// Initializes animations for button scaling and color transitions
  void _initializeAnimations() {
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _codeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _timerAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonAnimationController, curve: Curves.easeInOut),
    );
    _codeScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _codeAnimationController, curve: Curves.elasticOut),
    );
    _buttonColorAnimation = ColorTween(
      begin: const Color(0xFFF5F6FA),
      end: const Color(0xFF0B356A),
    ).animate(CurvedAnimation(parent: _buttonAnimationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthDateController.dispose();
    _idCardController.dispose();
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var controller in _phoneCodeControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var node in _phoneFocusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    _phoneTimer?.cancel();
    _buttonAnimationController.dispose();
    _codeAnimationController.dispose();
    _timerAnimationController.dispose();
    super.dispose();
  }

  /// Validates email input
  void _validateEmail() {
    final email = _emailController.text.trim();
    setState(() {
      if (email.isEmpty) {
        _emailError = 'Veuillez entrer votre email';
        _isEmailValid = false;
        _buttonAnimationController.reverse();
      } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
        _emailError = 'Veuillez entrer un email valide';
        _isEmailValid = false;
        _buttonAnimationController.reverse();
      } else if (email.length > 254) {
        _emailError = 'L\'email est trop long';
        _isEmailValid = false;
        _buttonAnimationController.reverse();
      } else {
        _emailError = null;
        _isEmailValid = true;
        _buttonAnimationController.forward();
      }
    });
  }

  /// Validates phone input
  void _validatePhone() {
    final phone = _phoneController.text.trim();
    setState(() {
      if (phone.isEmpty) {
        _phoneError = 'Veuillez entrer votre numéro de téléphone';
        _isPhoneValid = false;
        _buttonAnimationController.reverse();
      } else if (phone.length < 8) {
        _phoneError = 'Le numéro doit contenir au moins 8 chiffres';
        _isPhoneValid = false;
        _buttonAnimationController.reverse();
      } else if (phone.length > 15) {
        _phoneError = 'Le numéro est trop long';
        _isPhoneValid = false;
        _buttonAnimationController.reverse();
      } else if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
        _phoneError = 'Le numéro ne doit contenir que des chiffres';
        _isPhoneValid = false;
        _buttonAnimationController.reverse();
      } else {
        _phoneError = null;
        _isPhoneValid = true;
        _buttonAnimationController.forward();
      }
    });
  }

  /// Validates personal information inputs
  void _validatePersonalInfo() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final birthDate = _birthDateController.text.trim();
    final idCard = _idCardController.text.trim();

    setState(() {
      if (firstName.isEmpty) {
        _firstNameError = 'Veuillez entrer votre prénom';
      } else if (firstName.length < 2) {
        _firstNameError = 'Le prénom doit contenir au moins 2 caractères';
      } else if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(firstName)) {
        _firstNameError = 'Le prénom ne doit contenir que des lettres';
      } else {
        _firstNameError = null;
      }

      if (lastName.isEmpty) {
        _lastNameError = 'Veuillez entrer votre nom';
      } else if (lastName.length < 2) {
        _lastNameError = 'Le nom doit contenir au moins 2 caractères';
      } else if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(lastName)) {
        _lastNameError = 'Le nom ne doit contenir que des lettres';
      } else {
        _lastNameError = null;
      }

      if (birthDate.isEmpty) {
        _birthDateError = 'Veuillez entrer votre date de naissance';
      } else if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(birthDate)) {
        _birthDateError = 'Format: JJ/MM/AAAA';
      } else {
        _birthDateError = null;
      }

      if (idCard.isEmpty) {
        _idCardError = 'Veuillez entrer votre numéro de carte d\'identité';
      } else if (idCard.length < 8) {
        _idCardError = 'Le numéro doit contenir au moins 8 caractères';
      } else {
        _idCardError = null;
      }

      _isPersonalInfoValid = _firstNameError == null &&
          _lastNameError == null &&
          _birthDateError == null &&
          _idCardError == null &&
          firstName.isNotEmpty &&
          lastName.isNotEmpty &&
          birthDate.isNotEmpty &&
          idCard.isNotEmpty &&
          _idCardImage != null;

      if (_isPersonalInfoValid) {
        _buttonAnimationController.forward();
      } else {
        _buttonAnimationController.reverse();
      }
    });
  }

  /// Validates activity type selection
  void _validateActivityType() {
    setState(() {
      _isActivityTypeValid = _selectedActivityType != null;
      if (_isActivityTypeValid) {
        _buttonAnimationController.forward();
      } else {
        _buttonAnimationController.reverse();
      }
    });
  }

  /// Validates improvement selection
  void _validateImprovement() {
    setState(() {
      _isImprovementValid = _selectedImprovements.isNotEmpty;
      if (_isImprovementValid) {
        _buttonAnimationController.forward();
      } else {
        _buttonAnimationController.reverse();
      }
    });
  }

  /// Validates email verification code
  void _validateCode() {
    final allFilled = _codeControllers.every((c) => c.text.isNotEmpty);
    setState(() {
      if (allFilled && _isCodeValid) {
        _buttonAnimationController.forward();
      } else {
        _buttonAnimationController.reverse();
      }
    });
  }

  /// Validates phone verification code
  void _validatePhoneCode() {
    final allFilled = _phoneCodeControllers.every((c) => c.text.isNotEmpty);
    setState(() {
      if (allFilled && _isPhoneCodeValid) {
        _buttonAnimationController.forward();
      } else {
        _buttonAnimationController.reverse();
      }
    });
  }

  /// Starts the email verification timer
  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _timerSeconds = 60;
      _isCodeValid = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          _isCodeValid = false;
          _buttonAnimationController.reverse();
          timer.cancel();
        }
      });
    });
  }

  /// Starts the phone verification timer
  void _startPhoneTimer() {
    _phoneTimer?.cancel();
    setState(() {
      _phoneTimerSeconds = 60;
      _isPhoneCodeValid = true;
    });
    _phoneTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_phoneTimerSeconds > 0) {
          _phoneTimerSeconds--;
        } else {
          _isPhoneCodeValid = false;
          _buttonAnimationController.reverse();
          timer.cancel();
        }
      });
    });
  }

  /// Opens image picker for ID card upload
  Future<void> _pickImage() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              Text(
                'Sélectionner une image',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFF0B356A)),
                title: const Text('Prendre une photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    setState(() {
                      _idCardImage = File(image.path);
                    });
                    _validatePersonalInfo();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF0B356A)),
                title: const Text('Choisir dans la galerie'),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (image != null) {
                    setState(() {
                      _idCardImage = File(image.path);
                    });
                    _validatePersonalInfo();
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  /// Shows country selection bottom sheet
  Future<void> _showCountrySelector() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Text(
                      'Sélectionner un pays',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _countries.length,
                  itemBuilder: (context, index) {
                    final country = _countries[index];
                    final isSelected = country['code'] == _selectedCountry;

                    return ListTile(
                      leading: Text(
                        country['flag']!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(
                        country['name']!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? const Color(0xFF0B356A) : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        country['dialCode']!,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: const Color(0xFF8DA4C2),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Color(0xFF97DAFF))
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedCountry = country['code']!;
                          _selectedCountryCode = country['dialCode']!;
                          _selectedCountryName = country['name']!;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Opens date picker for birth date
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 18 * 365)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0B356A),
              onPrimary: Colors.white,
              surface: Color(0xFFFFFFFF),
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text =
        "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
      _validatePersonalInfo();
    }
  }

  /// Navigates to the previous step, adjusting for account type
  void _goToPreviousStep() {
    setState(() {
      if (_currentStep > 1) {
        if (widget.accountType == 'personal' && _currentStep == 6) {
          _currentStep = 5; // Skip ActivityTypeScreen
        } else {
          _currentStep--;
        }
      }
    });
  }

  /// Handles Google Sign-In
  void _handleGoogleSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connexion avec Google en cours...'),
        backgroundColor: Color(0xFF0B356A),
      ),
    );
    setState(() {
      _currentStep = 3;
    });
  }

  /// Completes onboarding and navigates to SignInScreen
  void _completeOnboarding() {
    try {
      Navigator.of(context, rootNavigator: true).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur de navigation: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: List.generate(_totalSteps, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: index < _currentStep ? const Color(0xFF97DAFF) : const Color(0xFF8DA4C2).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              if (_currentStep == 1)
                EmailStep(
                  emailController: _emailController,
                  emailError: _emailError,
                  isEmailValid: _isEmailValid,
                  onNext: () {
                    setState(() {
                      _currentStep = 2;
                      _startTimer();
                    });
                  },
                  onGoogleSignIn: _handleGoogleSignIn,
                  buttonScaleAnimation: _buttonScaleAnimation,
                  onSubmitted: (_) {
                    if (_isEmailValid) {
                      setState(() {
                        _currentStep = 2;
                        _startTimer();
                      });
                    }
                  },
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                  onBack: _goToPreviousStep,
                ),
              if (_currentStep == 2)
                EmailVerificationStep(
                  codeControllers: _codeControllers,
                  focusNodes: _focusNodes,
                  email: _emailController.text,
                  timerSeconds: _timerSeconds,
                  isCodeValid: _isCodeValid,
                  onNext: () {
                    setState(() {
                      _currentStep = 3;
                    });
                  },
                  onResend: () {
                    _startTimer();
                    for (var controller in _codeControllers) {
                      controller.clear();
                    }
                    _focusNodes[0].requestFocus();
                  },
                  buttonScaleAnimation: _buttonScaleAnimation,
                  codeScaleAnimation: _codeScaleAnimation,
                  timerAnimationController: _timerAnimationController,
                  onCodeChanged: (value) {
                    _validateCode();
                    if (value.isNotEmpty) {
                      _codeAnimationController.forward().then((_) {
                        _codeAnimationController.reverse();
                      });
                      final index = _codeControllers.indexWhere((c) => c.text == value);
                      if (index < 3) {
                        _focusNodes[index + 1].requestFocus();
                      }
                    } else {
                      final index = _codeControllers.indexWhere((c) => c.text.isEmpty);
                      if (index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                    }
                  },
                ),
              if (_currentStep == 3)
                PhoneStep(
                  phoneController: _phoneController,
                  phoneError: _phoneError,
                  isPhoneValid: _isPhoneValid,
                  onNext: () {
                    setState(() {
                      _currentStep = 4;
                      _startPhoneTimer();
                    });
                  },
                  onCountrySelector: _showCountrySelector,
                  selectedCountry: _selectedCountry,
                  selectedCountryCode: _selectedCountryCode,
                  countries: _countries,
                  buttonScaleAnimation: _buttonScaleAnimation,
                  onSubmitted: (_) {
                    if (_isPhoneValid) {
                      setState(() {
                        _currentStep = 4;
                        _startPhoneTimer();
                      });
                    }
                  },
                ),
              if (_currentStep == 4)
                PhoneVerificationStep(
                  phoneCodeControllers: _phoneCodeControllers,
                  phoneFocusNodes: _phoneFocusNodes,
                  phoneNumber: _phoneController.text,
                  countryCode: _selectedCountryCode,
                  phoneTimerSeconds: _phoneTimerSeconds,
                  isPhoneCodeValid: _isPhoneCodeValid,
                  onNext: () {
                    setState(() {
                      _currentStep = 5;
                    });
                  },
                  onResend: () {
                    _startPhoneTimer();
                    for (var controller in _phoneCodeControllers) {
                      controller.clear();
                    }
                    _phoneFocusNodes[0].requestFocus();
                  },
                  buttonScaleAnimation: _buttonScaleAnimation,
                  codeScaleAnimation: _codeScaleAnimation,
                  timerAnimationController: _timerAnimationController,
                  onCodeChanged: (value) {
                    _validatePhoneCode();
                    if (value.isNotEmpty) {
                      _codeAnimationController.forward().then((_) {
                        _codeAnimationController.reverse();
                      });
                      final index = _phoneCodeControllers.indexWhere((c) => c.text == value);
                      if (index < 3) {
                        _phoneFocusNodes[index + 1].requestFocus();
                      }
                    } else {
                      final index = _phoneCodeControllers.indexWhere((c) => c.text.isEmpty);
                      if (index > 0) {
                        _phoneFocusNodes[index - 1].requestFocus();
                      }
                    }
                  },
                ),
              if (_currentStep == 5)
                PersonalInfoStep(
                  firstNameController: _firstNameController,
                  lastNameController: _lastNameController,
                  birthDateController: _birthDateController,
                  idCardController: _idCardController,
                  firstNameError: _firstNameError,
                  lastNameError: _lastNameError,
                  birthDateError: _birthDateError,
                  idCardError: _idCardError,
                  isPersonalInfoValid: _isPersonalInfoValid,
                  idCardImage: _idCardImage,
                  onComplete: () {
                    setState(() {
                      _currentStep = widget.accountType == 'enterprise' ? 6 : 6; // Both go to step 6
                    });
                  },
                  onSelectDate: _selectDate,
                  onPickImage: _pickImage,
                  buttonScaleAnimation: _buttonScaleAnimation,
                ),
              if (_currentStep == 6 && widget.accountType == 'enterprise')
                ActivityTypeScreen(
                  onNext: (selectedType) {
                    setState(() {
                      _selectedActivityType = selectedType;
                      _validateActivityType();
                      _currentStep = 7;
                    });
                  },
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                  onBack: _goToPreviousStep,
                ),
              if (_currentStep == 6 && widget.accountType == 'personal' || _currentStep == 7 && widget.accountType == 'enterprise')
                ImprovementScreen(
                  activityType: _selectedActivityType ?? 'Compte Personnel',
                  onSubmit: (selectedImprovements) {
                    setState(() {
                      _selectedImprovements = selectedImprovements;
                      _validateImprovement();
                      _currentStep = widget.accountType == 'enterprise' ? 8 : 7;
                    });
                  },
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                  onBack: _goToPreviousStep,
                ),
              if (_currentStep == 7 && widget.accountType == 'personal' || _currentStep == 8 && widget.accountType == 'enterprise')
                PaymentPack(
                  onTrialSelected: () {
                    setState(() {
                      _currentStep = widget.accountType == 'enterprise' ? 10 : 9;
                    });
                  },
                  onPackSelected: (selectedPack) {
                    setState(() {
                      _currentStep = widget.accountType == 'enterprise' ? 9 : 8;
                    });
                  },
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                  onBack: _goToPreviousStep,
                ),
              if (_currentStep == 8 && widget.accountType == 'personal' || _currentStep == 9 && widget.accountType == 'enterprise')
                Payment(
                  selectedPack: 'Selected Pack',
                  onPaymentComplete: () {
                    setState(() {
                      _currentStep = widget.accountType == 'enterprise' ? 10 : 9;
                    });
                  },
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                  onBack: _goToPreviousStep,
                ),
              if (_currentStep == 9 && widget.accountType == 'personal' || _currentStep == 10 && widget.accountType == 'enterprise')
                ContactExpert(
                  onContinue: () {
                    setState(() {
                      _currentStep = widget.accountType == 'enterprise' ? 11 : 10;
                    });
                  },
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                  onBack: _goToPreviousStep,
                ),
              if (_currentStep == 10 && widget.accountType == 'personal' || _currentStep == 11 && widget.accountType == 'enterprise')
                RendezvousExpert(
                  onComplete: _completeOnboarding,
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                  onBack: _goToPreviousStep,
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}