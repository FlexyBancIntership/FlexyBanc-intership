import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// === Couleurs Globales ===
const Color _primaryColor = Color(0xFF16579D);
const Color _accentColor = Color(0xFF97DAFF);
const Color _placeholderColor = Color(0xFF8DA4C2);
const Color _textColor = Color(0xFF1B1D4D);
const Color _successColor = Color(0xFF4CAF50);
const Color _errorColor = Color(0xFFF44336);
const Color _warningColor = Color(0xFFFF9800);
const Color _infoColor = Color(0xFF2196F3);

// === Extension DateTime ===
extension DateTimeExtension on DateTime {
  String formatRelativeTime() {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.inMinutes < 1) return 'À l\'instant';
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours} h';
    if (diff.inDays < 7) return 'Il y a ${diff.inDays} j';
    return DateFormat('dd/MM/yyyy').format(this);
  }

  String formatFull() => DateFormat('dd MMMM yyyy à HH:mm').format(this);
}

// === Type de Notification ===
enum NotificationType { transaction, alert, security, info }

// === Modèle NotificationItem ===
class NotificationItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? details; // Nouveau : détails complets
  final DateTime time;
  bool isUnread;
  final Color color;
  final NotificationType type;

  NotificationItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.details,
    required this.time,
    this.isUnread = true,
    required this.color,
    required this.type,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is NotificationItem &&
              runtimeType == other.runtimeType &&
              title == other.title &&
              subtitle == other.subtitle &&
              time.millisecondsSinceEpoch == other.time.millisecondsSinceEpoch;

  @override
  int get hashCode => Object.hash(title, subtitle, time);
}

// === Écran Notifications ===
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> with TickerProviderStateMixin {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      icon: Icons.payment_rounded,
      title: 'Paiement reçu',
      subtitle: 'Vous avez reçu un paiement de 500 DT de Client XYZ.',
      details: 'Montant : 500 DT\nClient : Client XYZ\nDate : 15/04/2025 à 14:30\nStatut : Confirmé',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      isUnread: true,
      color: _successColor,
      type: NotificationType.transaction,
    ),
    NotificationItem(
      icon: Icons.warning_rounded,
      title: 'Alerte de solde bas',
      subtitle: 'Votre solde sur le compte Principal est inférieur à 100 DT.',
      details: 'Compte : Compte Principal\nSolde actuel : 85 DT\nDevise : TND\nDate : 15/04/2025 à 10:15',
      time: DateTime.now().subtract(const Duration(hours: 3)),
      isUnread: true,
      color: _errorColor,
      type: NotificationType.alert,
    ),
    NotificationItem(
      icon: Icons.security_rounded,
      title: 'Tentative de connexion',
      subtitle: 'Une nouvelle connexion a été détectée depuis un appareil inconnu.',
      details: 'Appareil : Samsung Galaxy S24\nIP : 192.168.1.105\nLieu : Tunis\nDate : 14/04/2025 à 22:03',
      time: DateTime.now().subtract(const Duration(days: 1)),
      isUnread: false,
      color: _primaryColor,
      type: NotificationType.security,
    ),
    NotificationItem(
      icon: Icons.update_rounded,
      title: 'Mise à jour disponible',
      subtitle: 'Une nouvelle version de l\'application est disponible.',
      details: 'Version : v2.4.0\nTaille : 45 MB\nFonctionnalités : Notifications push, Dark mode, Sécurité renforcée',
      time: DateTime.now().subtract(const Duration(days: 2)),
      isUnread: false,
      color: _accentColor,
      type: NotificationType.info,
    ),
    NotificationItem(
      icon: Icons.account_balance_rounded,
      title: 'Virement effectué',
      subtitle: 'Virement de 200 DT vers le compte Épargne réussi.',
      details: 'Montant : 200 DT\nBénéficiaire : Compte Épargne\nRéférence : VR20250413001\nDate : 13/04/2025 à 09:45',
      time: DateTime.now().subtract(const Duration(days: 3)),
      isUnread: false,
      color: _successColor,
      type: NotificationType.transaction,
    ),
  ];

  final ValueNotifier<NotificationType?> _filterType = ValueNotifier(null);
  final ValueNotifier<String> _searchQuery = ValueNotifier('');
  bool _isSearching = false;
  final bool _isLoading = false;

  // === Marquer toutes comme lues ===
  void _markAllAsRead() {
    HapticFeedback.lightImpact();
    final unread = _notifications.where((n) => n.isUnread).toList();
    if (unread.isEmpty) return;

    for (final n in _notifications) {
      n.isUnread = false;
    }
    setState(() {});
    _showSnackBar('✅ ${unread.length} notification(s) marquée(s) comme lue(s)');
  }

  // === Afficher détails dans un BottomSheet avec design plus cool ===
  void _showDetails(NotificationItem item) {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 24),
                Hero(
                  tag: 'notification-icon-${item.hashCode}',
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [item.color, item.color.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: item.color.withOpacity(0.4),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(item.icon, size: 36, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.title,
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  item.time.formatFull(),
                  style: GoogleFonts.openSans(fontSize: 14, color: _placeholderColor),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Détails',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Text(
                      item.details ?? 'Aucun détail disponible.',
                      style: GoogleFonts.openSans(
                        fontSize: 16,
                        height: 1.6,
                        color: _textColor.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.color,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (item.isUnread) {
                      item.isUnread = false;
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: Text(
                    'Fermer',
                    style: GoogleFonts.roboto(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // === SnackBar utilitaire ===
  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // === Filtre combiné (type + recherche) ===
  List<NotificationItem> get filteredNotifications {
    final query = _searchQuery.value.toLowerCase();
    final type = _filterType.value;

    return _notifications.where((item) {
      final matchesSearch = query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.subtitle.toLowerCase().contains(query);
      final matchesType = type == null || item.type == type;
      return matchesSearch && matchesType;
    }).toList();
  }

  // === Grouper par date ===
  Map<String, List<NotificationItem>> get grouped {
    final map = <String, List<NotificationItem>>{};
    final now = DateTime.now();

    for (final item in filteredNotifications) {
      final days = now.difference(item.time).inDays;
      final key = days == 0 ? 'Aujourd’hui' : days == 1 ? 'Hier' : 'Plus tôt';
      map.putIfAbsent(key, () => []).add(item);
    }
    return map;
  }

  // === Barre de recherche animée ===
  Widget _buildSearchField() {
    return ValueListenableBuilder<String>(
      valueListenable: _searchQuery,
      builder: (context, query, _) {
        return TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Rechercher...',
            border: InputBorder.none,
            hintStyle: GoogleFonts.openSans(color: _placeholderColor),
          ),
          style: GoogleFonts.openSans(color: _textColor),
          onChanged: (value) => _searchQuery.value = value,
        );
      },
    );
  }

  // === Filtres par type (icônes colorées) ===
  Widget _buildFilterRow() {
    return ValueListenableBuilder<NotificationType?>(
      valueListenable: _filterType,
      builder: (context, selectedType, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: NotificationType.values.map((type) {
              IconData icon;
              Color color;
              String label;

              switch (type) {
                case NotificationType.transaction:
                  icon = Icons.payment;
                  color = _successColor;
                  label = "Transactions";
                case NotificationType.alert:
                  icon = Icons.warning;
                  color = _errorColor;
                  label = "Alertes";
                case NotificationType.security:
                  icon = Icons.security;
                  color = _primaryColor;
                  label = "Sécurité";
                case NotificationType.info:
                  icon = Icons.info;
                  color = _accentColor;
                  label = "Info";
              }

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FilterChip(
                  avatar: Icon(icon, size: 18, color: selectedType == type ? Colors.white : color),
                  label: Text(label, style: TextStyle(fontSize: 13, color: selectedType == type ? Colors.white : color)),
                  selected: selectedType == type,
                  onSelected: (bool selected) {
                    HapticFeedback.selectionClick();
                    _filterType.value = selected ? type : null;
                  },
                  backgroundColor: color.withOpacity(0.1),
                  selectedColor: color,
                  checkmarkColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // === Carte de notification avec Hero pour animation ===
  Widget _buildNotificationCard(NotificationItem item) {
    return Dismissible(
      key: ValueKey(item.hashCode),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: _errorColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete, color: _errorColor, size: 30),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        HapticFeedback.heavyImpact();
        final removed = item;
        _notifications.remove(item);
        _showSnackBar('Notification supprimée');
      },
      child: GestureDetector(
        onTap: () => _showDetails(item),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: item.isUnread ? Border.all(color: item.color.withOpacity(0.4), width: 1.5) : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Icône avec Hero
                Hero(
                  tag: 'notification-icon-${item.hashCode}',
                  child: Stack(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [item.color.withOpacity(0.3), item.color.withOpacity(0.1)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: item.color.withOpacity(0.2),
                              blurRadius: 6,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(item.icon, size: 26, color: item.color),
                      ),
                      if (item.isUnread)
                        Positioned(
                          top: -3,
                          right: -3,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: _errorColor,
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Texte
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: item.isUnread ? FontWeight.w700 : FontWeight.w600,
                          color: _textColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.subtitle,
                        style: GoogleFonts.openSans(
                          fontSize: 13.5,
                          color: _placeholderColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.time.formatRelativeTime(),
                        style: GoogleFonts.openSans(
                          fontSize: 11,
                          color: _placeholderColor.withOpacity(0.8),
                        ),
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
  }

  // === État vide ===
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off, size: 80, color: _placeholderColor.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            'Aucune notification',
            style: GoogleFonts.roboto(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _textColor.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aucun élément ne correspond à vos critères.',
            style: GoogleFonts.openSans(color: _placeholderColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = this.grouped;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: _isSearching
            ? _buildSearchField()
            : Text(
          'Notifications',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: _textColor,
          ),
        ),
        actions: _isSearching
            ? [
          IconButton(
            icon: const Icon(Icons.clear, color: _primaryColor),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchQuery.value = '';
              });
            },
          ),
        ]
            : [
          IconButton(
            icon: const Icon(Icons.search, color: _primaryColor),
            onPressed: () {
              HapticFeedback.lightImpact();
              setState(() {
                _isSearching = true;
              });
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildFilterRow(),
          ),
          if (grouped.isEmpty)
            SliverFillRemaining(
              child: _buildEmptyState(),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final keys = grouped.keys.toList();
                  final key = keys[index];
                  final items = grouped[key]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 16, bottom: 12),
                        child: Text(
                          key,
                          style: GoogleFonts.roboto(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: _textColor.withOpacity(0.85),
                          ),
                        ),
                      ),
                      ...items.map(_buildNotificationCard),
                    ],
                  );
                },
                childCount: grouped.length,
              ),
            ),
          if (_isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator(color: _primaryColor)),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _primaryColor,
        elevation: 8,
        onPressed: _notifications.any((n) => n.isUnread) ? _markAllAsRead : null,
        tooltip: 'Tout marquer comme lu',
        child: const Icon(Icons.mark_email_read_rounded, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}