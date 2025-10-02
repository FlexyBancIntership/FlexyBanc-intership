import 'package:flexybank_intership/Views/Home/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// Modèle de données pour un transfert
class TransferModel {
  final String nom;
  final String montant;
  final String? avatar;
  final String? routingNumber;
  final String? accountNumber;
  final String? currency;
  final String? accountType;
  final DateTime? dateAdded;
  final String transactionType; // 'sent' or 'received'
  final String status; // 'completed', 'pending', 'failed'

  const TransferModel({
    required this.nom,
    required this.montant,
    this.avatar,
    this.routingNumber = '017062169',
    this.accountNumber = '**** 4590',
    this.currency = 'USD',
    this.accountType = 'Checking',
    this.dateAdded,
    this.transactionType = 'sent',
    this.status = 'completed',
  });

  TransferModel copyWith({
    String? nom,
    String? montant,
    String? avatar,
    String? routingNumber,
    String? accountNumber,
    String? currency,
    String? accountType,
    DateTime? dateAdded,
    String? transactionType,
    String? status,
  }) {
    return TransferModel(
      nom: nom ?? this.nom,
      montant: montant ?? this.montant,
      avatar: avatar ?? this.avatar,
      routingNumber: routingNumber ?? this.routingNumber,
      accountNumber: accountNumber ?? this.accountNumber,
      currency: currency ?? this.currency,
      accountType: accountType ?? this.accountType,
      dateAdded: dateAdded ?? this.dateAdded,
      transactionType: transactionType ?? this.transactionType,
      status: status ?? this.status,
    );
  }
}

// Modèle pour un groupe de transferts par date
class TransferGroup {
  final String date;
  final List<TransferModel> transferts;

  const TransferGroup({required this.date, required this.transferts});

  TransferGroup copyWith({String? date, List<TransferModel>? transferts}) {
    return TransferGroup(
      date: date ?? this.date,
      transferts: transferts ?? this.transferts,
    );
  }
}

// Charte graphique mise à jour
class AppColors {
  static const Color primaryColor = Color(0xFF16579D);
  static const Color accentColor = Color(0xFF97DAFF);
  static const Color inputBackground = Color(0xFFE8F2FF);
  static const Color placeholderColor = Color(0xFF8DA4C2);
  static const Color textColor = Color(0xFF1B1D4D);
  static const Color darkBackground = Color(0xFF1C2526);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color goldAccent = Color(0xFFFFD700);
  static const Color premiumGradientStart = Color(0xFF2C3E50);
  static const Color premiumGradientEnd = Color(0xFF4A6741);

  // Background colors
  static const Color backgroundColor = Color(
    0xFFE8F2FF,
  ); // Changed to inputBackground
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color shadowColor = Color(0x1A000000);

  // Transaction specific colors
  static const Color sentColor = Color(0xFFF44336); // Red for sent
  static const Color receivedColor = Color(0xFF4CAF50); // Green for received
  static const Color pendingColor = Color(0xFFFFA000); // Amber for pending
}

class AppDimensions {
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double avatarRadius = 24.0;
  static const double largeAvatarRadius = 40.0;
}

class HistoriqueTransfertsScreen extends StatefulWidget {
  const HistoriqueTransfertsScreen({super.key});

  @override
  State<HistoriqueTransfertsScreen> createState() =>
      _HistoriqueTransfertsScreenState();
}

class _HistoriqueTransfertsScreenState extends State<HistoriqueTransfertsScreen>
    with SingleTickerProviderStateMixin {
  static const int _currentNavigationIndex = 2;

  late final TextEditingController _searchController;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  List<TransferGroup> _filteredTransferts = [];
  bool _isLoading = false;
  final GlobalKey<RefreshIndicatorState> _refreshKey = GlobalKey();

  // Données statiques
  static final List<TransferGroup> _staticTransferts = [
    TransferGroup(
      date: '28 Août',
      transferts: [
        TransferModel(
          nom: 'Yong Tonghyon',
          montant: '-\$10,480.00',
          avatar: 'assets/avatar1.png',
          dateAdded: DateTime(2024, 8, 28),
          transactionType: 'sent',
          status: 'completed',
        ),
        TransferModel(
          nom: 'Lubomír Dvořák',
          montant: '+\$201.50',
          avatar: 'assets/avatar2.png',
          dateAdded: DateTime(2024, 8, 28),
          transactionType: 'received',
          status: 'completed',
        ),
        TransferModel(
          nom: 'Sanne Viscaal',
          montant: '-\$184.00',
          avatar: 'assets/avatar3.png',
          dateAdded: DateTime(2024, 8, 28),
          transactionType: 'sent',
          status: 'pending',
        ),
        TransferModel(
          nom: 'Mathijn Agter',
          montant: '-\$3,000.00',
          avatar: 'assets/avatar4.png',
          dateAdded: DateTime(2024, 8, 28),
          transactionType: 'sent',
          status: 'completed',
        ),
      ],
    ),
    TransferGroup(
      date: '24 Août',
      transferts: [
        TransferModel(
          nom: 'Shirine Dungey',
          montant: '-\$11,400.00',
          avatar: 'assets/avatar5.png',
          dateAdded: DateTime(2024, 8, 24),
          transactionType: 'sent',
          status: 'failed',
        ),
        TransferModel(
          nom: 'Hu Guiying',
          montant: '+\$396.00',
          avatar: 'assets/avatar6.png',
          dateAdded: DateTime(2024, 8, 24),
          transactionType: 'received',
          status: 'completed',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadTransferts();
  }

  void _initializeControllers() {
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _loadTransferts({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _isLoading = true;
      });
    }

    await initializeDateFormatting('fr_FR');

    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _filteredTransferts = _staticTransferts;
        _isLoading = false;
      });
      _animationController.forward(from: 0.0);
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        _filteredTransferts = _staticTransferts;
      } else {
        _filteredTransferts =
            _staticTransferts
                .map(
                  (group) => TransferGroup(
                    date: group.date,
                    transferts:
                        group.transferts
                            .where(
                              (transfer) =>
                                  transfer.nom.toLowerCase().contains(query) ||
                                  transfer.montant.toLowerCase().contains(
                                    query,
                                  ),
                            )
                            .toList(),
                  ),
                )
                .where((group) => group.transferts.isNotEmpty)
                .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _buildAppTheme(context),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor, // Updated background
        appBar: _buildAppBar(context),
        body: _buildBody(),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: 1,
          onTap: (index) {
            HapticFeedback.lightImpact();
          },
        ),
      ),
    );
  }

  ThemeData _buildAppTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      scaffoldBackgroundColor: AppColors.backgroundColor,
      textTheme: GoogleFonts.robotoTextTheme(
        Theme.of(context).textTheme.copyWith(
          headlineSmall: const TextStyle(
            color: AppColors.textColor,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: const TextStyle(
            color: AppColors.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: const TextStyle(
            color: AppColors.placeholderColor,
            fontSize: 14,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          elevation: 2,
        ),
      ),
      colorScheme: const ColorScheme.light().copyWith(
        primary: AppColors.primaryColor,
        error: AppColors.errorColor,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor, // Updated background
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textColor),
        onPressed: () => Navigator.of(context).pop(),
        tooltip: 'Retour',
      ),
      title: Text(
        'Transferts récents',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _SearchBar(controller: _searchController, isLoading: _isLoading),
        Expanded(
          child: RefreshIndicator(
            key: _refreshKey,
            onRefresh: () => _loadTransferts(refresh: true),
            color: AppColors.primaryColor,
            child:
                _isLoading
                    ? const _LoadingView()
                    : _filteredTransferts.isEmpty
                    ? _EmptyStateView(
                      searchQuery: _searchController.text,
                      onClearSearch: () {
                        _searchController.clear();
                      },
                    )
                    : _TransfersList(
                      transferGroups: _filteredTransferts,
                      animation: _fadeAnimation,
                      onTransferTap: _showTransferDetails,
                    ),
          ),
        ),
      ],
    );
  }

  void _handleNavigationTap(int index) {
    // Navigation sera gérée par le CustomBottomNavigationBar
  }

  void _showTransferDetails(TransferModel transfer) {
    HapticFeedback.lightImpact();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) => TransferDetailsBottomSheet(transfer: transfer),
    );
  }
}

// Widget pour l'avatar utilisateur
class _UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Avatar utilisateur',
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.transparent,
          child: const Icon(
            Icons.person,
            color: AppColors.primaryColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}

// Widget pour la barre de recherche
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;

  const _SearchBar({required this.controller, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.defaultPadding),
      child: TextField(
        controller: controller,
        enabled: !isLoading,
        decoration: InputDecoration(
          hintText: 'Rechercher un transfert...',
          hintStyle: TextStyle(color: AppColors.placeholderColor),
          prefixIcon: Icon(Icons.search, color: AppColors.placeholderColor),
          suffixIcon:
              controller.text.isNotEmpty
                  ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: controller.clear,
                    color: AppColors.placeholderColor,
                  )
                  : null,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
            borderSide: const BorderSide(
              color: AppColors.primaryColor,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
        ),
        style: const TextStyle(color: AppColors.textColor, fontSize: 16),
        textInputAction: TextInputAction.search,
      ),
    );
  }
}

// Widget pour l'état de chargement
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
            semanticsLabel: 'Chargement en cours',
          ),
          SizedBox(height: AppDimensions.defaultPadding),
          Text(
            'Chargement des transferts...',
            style: TextStyle(color: AppColors.textColor),
          ),
        ],
      ),
    );
  }
}

// Widget pour l'état vide
class _EmptyStateView extends StatelessWidget {
  final String searchQuery;
  final VoidCallback onClearSearch;

  const _EmptyStateView({
    required this.searchQuery,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final isSearching = searchQuery.isNotEmpty;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.largePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.search_off : Icons.receipt_long_outlined,
              size: 80,
              color: AppColors.placeholderColor,
            ),
            const SizedBox(height: AppDimensions.defaultPadding),
            Text(
              isSearching
                  ? 'Aucun transfert trouvé'
                  : 'Aucun transfert disponible',
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.smallPadding),
            Text(
              isSearching
                  ? 'Essayez avec un autre terme de recherche'
                  : 'Vos transferts récents apparaîtront ici une fois effectués',
              style: const TextStyle(
                color: AppColors.placeholderColor,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            if (isSearching) ...[
              const SizedBox(height: AppDimensions.defaultPadding),
              ElevatedButton(
                onPressed: onClearSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  foregroundColor: AppColors.primaryColor,
                ),
                child: const Text('Effacer la recherche'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Widget pour la liste des transferts
class _TransfersList extends StatelessWidget {
  final List<TransferGroup> transferGroups;
  final Animation<double> animation;
  final Function(TransferModel) onTransferTap;

  const _TransfersList({
    required this.transferGroups,
    required this.animation,
    required this.onTransferTap,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.defaultPadding,
        ),
        itemCount: transferGroups.length,
        itemBuilder: (context, index) {
          final group = transferGroups[index];
          return _TransferGroupWidget(
            group: group,
            onTransferTap: onTransferTap,
          );
        },
      ),
    );
  }
}

// Widget pour un groupe de transferts
class _TransferGroupWidget extends StatelessWidget {
  final TransferGroup group;
  final Function(TransferModel) onTransferTap;

  const _TransferGroupWidget({
    required this.group,
    required this.onTransferTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppDimensions.defaultPadding,
            bottom: AppDimensions.smallPadding,
            left: AppDimensions.smallPadding,
          ),
          child: Text(
            group.date,
            style: const TextStyle(
              color: AppColors.placeholderColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...group.transferts.asMap().entries.map((entry) {
          int idx = entry.key;
          TransferModel transfer = entry.value;
          return AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(milliseconds: 300 + (idx * 100)),
            child: _TransferItem(
              transfer: transfer,
              onTap: () => onTransferTap(transfer),
            ),
          );
        }),
      ],
    );
  }
}

// Widget pour un élément de transfert
class _TransferItem extends StatelessWidget {
  final TransferModel transfer;
  final VoidCallback onTap;

  const _TransferItem({required this.transfer, required this.onTap});

  Color _getAmountColor() {
    if (transfer.transactionType == 'received') return AppColors.receivedColor;
    if (transfer.status == 'pending') return AppColors.pendingColor;
    if (transfer.status == 'failed') return AppColors.errorColor;
    return AppColors.sentColor;
  }

  IconData _getStatusIcon() {
    switch (transfer.status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'failed':
        return Icons.error_outline;
      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: AppDimensions.smallPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      elevation: 2,
      shadowColor: AppColors.shadowColor,
      child: ListTile(
        onTap: onTap,
        leading: _TransferAvatar(avatarPath: transfer.avatar),
        title: Text(
          transfer.nom,
          style: const TextStyle(
            color: AppColors.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Icon(_getStatusIcon(), size: 14, color: _getAmountColor()),
            const SizedBox(width: 4),
            Text(
              transfer.status.capitalize(),
              style: const TextStyle(
                color: AppColors.placeholderColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: Text(
          transfer.montant,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _getAmountColor(),
          ),
        ),
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }
}

// Extension for capitalize
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

// Widget pour l'avatar d'un transfert
class _TransferAvatar extends StatelessWidget {
  final String? avatarPath;

  const _TransferAvatar({this.avatarPath});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: AppDimensions.avatarRadius,
      backgroundColor: Colors.white,
      backgroundImage: avatarPath != null ? AssetImage(avatarPath!) : null,
      onBackgroundImageError:
          avatarPath != null
              ? (exception, stackTrace) {
                // Log l'erreur si nécessaire
              }
              : null,
      child:
          avatarPath == null
              ? Icon(
                Icons.person,
                color: AppColors.primaryColor,
                size: AppDimensions.avatarRadius,
              )
              : null,
    );
  }
}

// Bottom sheet pour les détails du transfert
class TransferDetailsBottomSheet extends StatelessWidget {
  final TransferModel transfer;

  const TransferDetailsBottomSheet({required this.transfer, super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.8,
      builder:
          (context, scrollController) => Container(
            padding: const EdgeInsets.all(AppDimensions.defaultPadding),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimensions.defaultPadding),
              ),
            ),
            child: ListView(
              controller: scrollController,
              children: [
                _buildDragHandle(),
                const SizedBox(height: AppDimensions.defaultPadding),
                _buildHeader(context),
                const SizedBox(height: AppDimensions.largePadding),
                _buildUserInfo(context),
                const SizedBox(height: AppDimensions.largePadding),
                _buildAccountDetails(context),
                const SizedBox(height: AppDimensions.largePadding),
                _buildTransferButton(context),
              ],
            ),
          ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.placeholderColor,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return const Text(
      'Détails du destinataire',
      style: TextStyle(
        color: AppColors.textColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        child: Column(
          children: [
            _TransferAvatar(avatarPath: transfer.avatar),
            const SizedBox(height: AppDimensions.defaultPadding),
            Text(
              transfer.nom,
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.smallPadding),
            Text(
              transfer.dateAdded != null
                  ? 'Ajouté le ${_formatDate(transfer.dateAdded!)}'
                  : 'Ajouté le 29 Avril, 2022',
              style: const TextStyle(
                color: AppColors.placeholderColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountDetails(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.defaultPadding),
        child: Column(
          children: [
            _buildDetailRow(
              context,
              'Numéro de routage',
              transfer.routingNumber ?? 'N/A',
              canCopy: true,
            ),
            _buildDetailRow(
              context,
              'Compte',
              transfer.accountNumber ?? 'N/A',
              canCopy: true,
            ),
            _buildDetailRow(context, 'Devise', transfer.currency ?? 'N/A'),
            _buildDetailRow(
              context,
              'Type de compte',
              transfer.accountType ?? 'N/A',
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value, {
    bool isLast = false,
    bool canCopy = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppDimensions.smallPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.placeholderColor,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (canCopy) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Icons.content_copy,
                    size: 16,
                    color: AppColors.primaryColor,
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copié dans le presse-papiers'),
                      ),
                    );
                  },
                  tooltip: 'Copier',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransferButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () => _handleTransfer(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.send, size: 20, color: Colors.white),
        label: const Text(
          'Effectuer un transfert',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _handleTransfer(BuildContext context) {
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transfert initié vers ${transfer.nom}'),
        backgroundColor: AppColors.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMMM, yyyy', 'fr_FR').format(date);
  }
}
