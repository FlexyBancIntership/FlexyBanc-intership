import 'package:flexybank_intership/Views/Home/bottom_navigation_bar.dart' as HomeNav;
import 'package:flexybank_intership/Views/Home/home_screen.dart';
import 'package:flexybank_intership/Views/More/plus_screen.dart' as MoreScreen;
import 'package:flexybank_intership/Views/carte/CarteScreen.dart';
import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> with TickerProviderStateMixin {
  // Palette de couleurs alignée avec CarteScreen
  static const Color _primaryColor = Color(0xFF16579D); // Bleu principal de CarteScreen
  static const Color _accentColor = Color(0xFF97DAFF);  // Accent bleu clair de CarteScreen
  static const Color _backgroundColor = Color(0xFFF1F5F9);
  static const Color _surfaceColor = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF1B1D4D);  // Aligné avec textColor de CarteScreen
  static const Color _textSecondary = Color(0xFF475569);
  static const Color _textMuted = Color(0xFF94A3B8);
  static const Color _successColor = Color(0xFF10B981);
  static const Color _errorColor = Color(0xFFEF4444);
  static const Color _borderColor = Color(0xFFE2E8F0);

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String? _selectedActivityId;
  String _selectedFilter = 'Tous';
  DateTimeRange? _selectedDateRange;
  DateTimeRange? _tempDateRange; // Temporary range for date picker
  final bool _isFilterExpanded = false;

  final List<String> _filterOptions = [
    'Tous', 'Utilities', 'Tech', 'Service', 'Divertissement'
  ];

  final List<Map<String, dynamic>> _activities = [
    // Transactions Tech
    {
      'type': 'Abonnement',
      'site': 'Google Workspace',
      'amount': '10.00',
      'date': '2025-07-30',
      'icon': Icons.work_outline,
      'reference': 'GWS-001',
      'description': 'Abonnement mensuel Google Workspace Business',
      'category': 'Tech',
      'status': 'completed'
    },
    {
      'type': 'Service Cloud',
      'site': 'AWS',
      'amount': '45.20',
      'date': '2025-07-28',
      'icon': Icons.cloud,
      'reference': 'AWS-002',
      'description': 'Services Amazon Web Services - Hébergement',
      'category': 'Tech',
      'status': 'completed'
    },
    {
      'type': 'Abonnement',
      'site': 'GitHub Copilot',
      'amount': '10.00',
      'date': '2025-07-25',
      'icon': Icons.code,
      'reference': 'GH-003',
      'description': 'Abonnement GitHub Copilot Developer',
      'category': 'Tech',
      'status': 'completed'
    },
    {
      'type': 'Service',
      'site': 'ChatGPT Plus',
      'amount': '20.00',
      'date': '2025-07-20',
      'icon': Icons.chat_bubble_outline,
      'reference': 'GPT-004',
      'description': 'Service ChatGPT Plus - IA Assistant',
      'category': 'Tech',
      'status': 'completed'
    },
    {
      'type': 'Abonnement',
      'site': 'Canva Pro',
      'amount': '12.95',
      'date': '2025-07-18',
      'icon': Icons.design_services,
      'reference': 'CNV-005',
      'description': 'Abonnement Canva Pro Design',
      'category': 'Tech',
      'status': 'completed'
    },


    // Transactions Utilities
    {
      'type': 'Facture',
      'site': 'STEG',
      'amount': '85.50',
      'date': '2025-07-29',
      'icon': Icons.electrical_services,
      'reference': 'STEG-006',
      'description': 'Facture électricité - Juillet 2025',
      'category': 'Utilities',
      'status': 'completed'
    },
    {
      'type': 'Facture',
      'site': 'SONEDE',
      'amount': '32.75',
      'date': '2025-07-27',
      'icon': Icons.water_drop,
      'reference': 'SON-007',
      'description': 'Facture eau - Juillet 2025',
      'category': 'Utilities',
      'status': 'completed'
    },
    {
      'type': 'Facture',
      'site': 'Gaz de Tunisie',
      'amount': '28.90',
      'date': '2025-07-26',
      'icon': Icons.local_fire_department,
      'reference': 'GAZ-008',
      'description': 'Facture gaz naturel - Juillet 2025',
      'category': 'Utilities',
      'status': 'completed'
    },
    {
      'type': 'Facture',
      'site': 'Tunisie Telecom',
      'amount': '45.20',
      'date': '2025-07-24',
      'icon': Icons.phone,
      'reference': 'TT-009',
      'description': 'Facture Internet et téléphone fixe',
      'category': 'Utilities',
      'status': 'completed'
    },

    // Transactions Divertissement
    {
      'type': 'Abonnement',
      'site': 'Netflix',
      'amount': '15.99',
      'date': '2025-07-31',
      'icon': Icons.movie,
      'reference': 'NET-010',
      'description': 'Abonnement Netflix Premium',
      'category': 'Divertissement',
      'status': 'completed'
    },
    {
      'type': 'Abonnement',
      'site': 'Spotify',
      'amount': '9.99',
      'date': '2025-07-23',
      'icon': Icons.music_note,
      'reference': 'SPT-011',
      'description': 'Abonnement Spotify Premium',
      'category': 'Divertissement',
      'status': 'completed'
    },
    {
      'type': 'Abonnement',
      'site': 'Disney+',
      'amount': '8.99',
      'date': '2025-07-22',
      'icon': Icons.video_library,
      'reference': 'DIS-012',
      'description': 'Abonnement Disney+ Streaming',
      'category': 'Divertissement',
      'status': 'completed'
    },
    {
      'type': 'Achat',
      'site': 'PlayStation Store',
      'amount': '59.99',
      'date': '2025-07-21',
      'icon': Icons.sports_esports,
      'reference': 'PS-013',
      'description': 'Achat jeu vidéo - Dernière sortie',
      'category': 'Divertissement',
      'status': 'completed'
    },

    // Transactions Service
    {
      'type': 'Service',
      'site': 'Uber',
      'amount': '18.50',
      'date': '2025-07-30',
      'icon': Icons.local_taxi,
      'reference': 'UBR-014',
      'description': 'Course Uber - Transport urbain',
      'category': 'Service',
      'status': 'completed'
    },
    {
      'type': 'Service',
      'site': 'Deliveroo',
      'amount': '24.75',
      'date': '2025-07-28',
      'icon': Icons.delivery_dining,
      'reference': 'DEL-015',
      'description': 'Livraison repas - Restaurant',
      'category': 'Service',
      'status': 'completed'
    },
    {
      'type': 'Service',
      'site': 'Carrefour',
      'amount': '67.30',
      'date': '2025-07-26',
      'icon': Icons.shopping_cart,
      'reference': 'CAR-016',
      'description': 'Courses alimentaires - Supermarché',
      'category': 'Service',
      'status': 'completed'
    },
    {
      'type': 'Service',
      'site': 'Pharmacie Centrale',
      'amount': '15.40',
      'date': '2025-07-25',
      'icon': Icons.local_pharmacy,
      'reference': 'PH-017',
      'description': 'Médicaments et produits de santé',
      'category': 'Service',
      'status': 'completed'
    },
    {
      'type': 'Service',
      'site': 'Station Shell',
      'amount': '45.00',
      'date': '2025-07-24',
      'icon': Icons.local_gas_station,
      'reference': 'SHL-018',
      'description': 'Plein essence - Carburant',
      'category': 'Service',
      'status': 'completed'
    },

    // Transactions plus anciennes pour tester les filtres de date
    {
      'type': 'Abonnement',
      'site': 'Microsoft 365',
      'amount': '12.00',
      'date': '2025-06-15',
      'icon': Icons.business,
      'reference': 'MS-019',
      'description': 'Abonnement Microsoft 365 Personal',
      'category': 'Tech',
      'status': 'completed'
    },
    {
      'type': 'Facture',
      'site': 'STEG',
      'amount': '78.20',
      'date': '2025-06-28',
      'icon': Icons.electrical_services,
      'reference': 'STEG-020',
      'description': 'Facture électricité - Juin 2025',
      'category': 'Utilities',
      'status': 'completed'
    },
    {
      'type': 'Service',
      'site': 'Monoprix',
      'amount': '89.45',
      'date': '2025-06-20',
      'icon': Icons.shopping_bag,
      'reference': 'MON-021',
      'description': 'Courses hebdomadaires - Supermarché',
      'category': 'Service',
      'status': 'completed'
    },
    {
      'type': 'Abonnement',
      'site': 'YouTube Premium',
      'amount': '11.99',
      'date': '2025-05-22',
      'icon': Icons.play_circle,
      'reference': 'YT-022',
      'description': 'Abonnement YouTube Premium',
      'category': 'Divertissement',
      'status': 'completed'

    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredActivities {
    List<Map<String, dynamic>> filtered = _activities.where((activity) {
      if (_selectedFilter != 'Tous' && !activity['category'].toString().contains(_selectedFilter)) {
        return false;
      }

      if (_selectedDateRange != null) {
        final activityDate = DateTime.parse(activity['date']);
        return activityDate.isAfter(_selectedDateRange!.start.subtract(const Duration(days: 1))) &&
            activityDate.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
      }

      return true;
    }).toList();

    for (int i = 0; i < filtered.length; i++) {
      filtered[i] = Map<String, dynamic>.from(filtered[i]);
      filtered[i]['id'] = i.toString();
    }

    return filtered;
  }

  double get _totalAmount {
    return _filteredActivities.fold<double>(0.0, (sum, activity) => sum + double.parse(activity['amount']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildCompactHeader(),
              _buildQuickStats(),
              _buildFilterChips(),
              Expanded(child: _buildActivitiesList()),
            ],
          ),
        ),

      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: HomeNav.CustomBottomNavigationBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => CarteScreen()),
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

  Widget _buildCompactHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      decoration: BoxDecoration(
        color: _surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mes Activités',
                  style: TextStyle(
                    color: _textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_filteredActivities.length} transactions',
                  style: TextStyle(
                    color: _textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_balance_wallet,
              color: _primaryColor,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [

          Expanded(
            child: _buildStatItem(
              'Total dépensé',
              '${_totalAmount.toStringAsFixed(2)} €',
              Icons.trending_up,
            ),

          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withOpacity(0.3),
          ),

          Expanded(
            child: _buildStatItem(
              'Cette période',
              '${_filteredActivities.length}',
              Icons.receipt_long,

            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.9), size: 16),
            const SizedBox(width: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(

        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _filterOptions.length,
              itemBuilder: (context, index) {
                final option = _filterOptions[index];
                final isSelected = _selectedFilter == option;
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(
                      option,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : _textSecondary,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedFilter = option);
                    },
                    backgroundColor: _surfaceColor,
                    selectedColor: _primaryColor,
                    checkmarkColor: Colors.white,
                    side: BorderSide(
                      color: isSelected ? _primaryColor : _borderColor,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _borderColor),
            ),
            child: IconButton(
              onPressed: _showFilterOptions,
              icon: Icon(Icons.tune, color: _primaryColor, size: 20),
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              padding: EdgeInsets.zero,

            ),
          ),
        ],
      ),
    );
  }


  Widget _buildActivitiesList() {
    if (_filteredActivities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _textMuted.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 48,
                color: _textMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune transaction',
              style: TextStyle(
                color: _textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Modifiez vos filtres',
              style: TextStyle(
                color: _textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      itemCount: _filteredActivities.length,
      itemBuilder: (context, index) {
        final activity = _filteredActivities[index];
        return _buildActivityCard(activity, index);
      },
    );
  }

  Widget _buildActivityCard(Map<String, dynamic> activity, int index) {
    final date = DateTime.parse(activity['date']);
    final isSelected = _selectedActivityId == activity['id'];
    final amount = double.parse(activity['amount']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? _primaryColor : _borderColor,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedActivityId = isSelected ? null : activity['id'];
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(activity['category']).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        activity['icon'],
                        color: _getCategoryColor(activity['category']),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(activity['category']).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  activity['category'],
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: _getCategoryColor(activity['category']),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${date.day}/${date.month}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            activity['site'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            activity['type'],
                            style: TextStyle(
                              fontSize: 12,
                              color: _textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${amount.toStringAsFixed(2)} €',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _successColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _successColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isSelected) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _backgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, size: 14, color: _textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              'Détails',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          activity['description'],
                          style: TextStyle(
                            fontSize: 12,
                            color: _textSecondary,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Réf: ${activity['reference']}',
                          style: TextStyle(
                            fontSize: 11,
                            color: _textMuted,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          Icons.picture_as_pdf,
                          'PDF',
                          _primaryColor,
                              () => _generatePDF(activity),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildActionButton(
                          Icons.delete_outline,
                          'Supprimer',
                          _errorColor,
                              () => _showDeleteConfirmation(activity),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),

          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color, VoidCallback onPressed) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(

                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _generateGlobalPDF,
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
      elevation: 6,
      icon: const Icon(Icons.picture_as_pdf, size: 20),
      label: const Text(
        'Rapport PDF',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _borderColor,
                borderRadius: BorderRadius.circular(2),

              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Options de filtrage',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildFilterActionButton(
                    Icons.date_range,
                    'Période',
                        () {
                      Navigator.pop(context);
                      _showDateRangePicker();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFilterActionButton(
                    Icons.clear,
                    'Réinitialiser',
                        () {
                      Navigator.pop(context);
                      setState(() {
                        _selectedFilter = 'Tous';
                        _selectedDateRange = null;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showDateRangePicker() {
    // Initialize temp range with current selection or null
    _tempDateRange = _selectedDateRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [

                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    border: Border(bottom: BorderSide(color: _borderColor, width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sélectionner une période',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: _textSecondary, size: 24),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],

                  ),
                ),
                // Date Picker
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: SfDateRangePicker(
                      selectionMode: DateRangePickerSelectionMode.range,
                      initialSelectedRange: _tempDateRange != null
                          ? PickerDateRange(_tempDateRange!.start, _tempDateRange!.end)
                          : null,
                      minDate: DateTime(2020, 1, 1),
                      maxDate: DateTime.now(),
                      selectionColor: _primaryColor,
                      rangeSelectionColor: _primaryColor.withOpacity(0.2),
                      todayHighlightColor: _accentColor,
                      headerStyle: DateRangePickerHeaderStyle(
                        textStyle: TextStyle(
                          color: _textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: _surfaceColor,
                      ),
                      monthCellStyle: DateRangePickerMonthCellStyle(
                        textStyle: TextStyle(color: _textPrimary, fontSize: 14),
                        disabledDatesTextStyle: TextStyle(color: _textMuted.withOpacity(0.5)),
                        todayTextStyle: TextStyle(color: _accentColor, fontWeight: FontWeight.w600),
                        weekendTextStyle: TextStyle(color: _textSecondary),
                      ),
                      yearCellStyle: DateRangePickerYearCellStyle(
                        textStyle: TextStyle(color: _textPrimary, fontSize: 14),
                        disabledDatesTextStyle: TextStyle(color: _textMuted.withOpacity(0.5)),
                        todayTextStyle: TextStyle(color: _accentColor, fontWeight: FontWeight.w600),
                      ),
                      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                        if (args.value is PickerDateRange) {
                          final PickerDateRange range = args.value;

                          // Update the temp range immediately when selection changes
                          if (range.startDate != null && range.endDate != null) {
                            setModalState(() {
                              _tempDateRange = DateTimeRange(
                                start: range.startDate!,
                                end: range.endDate!,
                              );
                            });
                          } else if (range.startDate != null && range.endDate == null) {
                            // When only start date is selected, clear temp range
                            setModalState(() {
                              _tempDateRange = null;
                            });
                          }
                        }
                      },
                    ),
                  ),
                ),
                // Action Buttons
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    border: Border(top: BorderSide(color: _borderColor, width: 1)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: _borderColor),
                            ),
                          ),
                          child: Text(
                            'Annuler',
                            style: TextStyle(
                              color: _textSecondary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _tempDateRange != null
                              ? () {
                            // Apply the selected date range
                            setState(() {
                              _selectedDateRange = _tempDateRange;
                            });
                            Navigator.pop(context);

                            // Show confirmation message
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Période sélectionnée: ${_tempDateRange!.start.day}/${_tempDateRange!.start.month} - ${_tempDateRange!.end.day}/${_tempDateRange!.end.month}',
                                ),
                                backgroundColor: _successColor,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                margin: const EdgeInsets.all(16),
                              ),
                            );
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _tempDateRange != null ? _primaryColor : _textMuted,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: _tempDateRange != null ? 2 : 0,
                          ),
                          child: Text(
                            'Valider',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
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

  Widget _buildFilterActionButton(IconData icon, String label, VoidCallback onTap) {
    return Material(
      color: _primaryColor.withOpacity(0.08),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: _primaryColor, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _primaryColor,
                ),

              ),
            ],
          ),

        ),
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: _errorColor, size: 24),
            const SizedBox(width: 8),
            const Text('Supprimer'),
          ],
        ),
        content: Text(
          'Supprimer cette transaction définitivement ?',
          style: TextStyle(color: _textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler', style: TextStyle(color: _textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteActivity(activity['id']);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _errorColor,
              foregroundColor: Colors.white,

            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }


  void _deleteActivity(String activityId) {

    setState(() {
      final index = _activities.indexWhere((activity) => activity['reference'] ==
          _filteredActivities[int.parse(activityId)]['reference']);
      if (index != -1) {
        _activities.removeAt(index);
      }
      _selectedActivityId = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Transaction supprimée'),
        backgroundColor: _successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }


  Future<void> _generatePDF(Map<String, dynamic> activity) async {
    final pdf = pw.Document();
    final date = DateTime.parse(activity['date']);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(24),
                decoration: pw.BoxDecoration(
                  gradient: pw.LinearGradient(
                    colors: [
                      PdfColor.fromHex('#16579D'),
                      PdfColor.fromHex('#97DAFF'),
                    ],
                  ),
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'DÉTAIL TRANSACTION',
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Référence: ${activity['reference']}',
                      style: pw.TextStyle(fontSize: 14, color: PdfColors.white),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 32),
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#F8FAFC'),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Column(
                  children: [
                    _buildPDFInfoRow('Fournisseur', activity['site']),
                    pw.SizedBox(height: 12),
                    _buildPDFInfoRow('Type', activity['type']),
                    pw.SizedBox(height: 12),
                    _buildPDFInfoRow('Montant', '${activity['amount']} €'),
                    pw.SizedBox(height: 12),
                    _buildPDFInfoRow('Date', '${date.day}/${date.month}/${date.year}'),
                    pw.SizedBox(height: 12),
                    _buildPDFInfoRow('Catégorie', activity['category']),
                  ],
                ),
              ),
              pw.SizedBox(height: 24),
              pw.Text(
                'Description',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                activity['description'],
                style: pw.TextStyle(fontSize: 12, color: PdfColor.fromHex('#64748B')),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Transaction_${activity['reference']}.pdf',
    );
  }

  pw.Widget _buildPDFInfoRow(String label, String value) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 12,
            color: PdfColor.fromHex('#64748B'),
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<void> _generateGlobalPDF() async {
    final pdf = pw.Document();
    final activities = _filteredActivities;
    final totalAmount = _totalAmount;
    final currentDate = DateTime.now();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // En-tête
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(24),
              decoration: pw.BoxDecoration(
                gradient: pw.LinearGradient(
                  colors: [
                    PdfColor.fromHex('#16579D'),
                    PdfColor.fromHex('#97DAFF'),
                  ],
                ),
                borderRadius: pw.BorderRadius.circular(12),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'RAPPORT GLOBAL DES TRANSACTIONS',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Filtre: $_selectedFilter',
                    style: pw.TextStyle(fontSize: 12, color: PdfColors.white),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 24),

            // Statistiques
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#F8FAFC'),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  _buildPDFStatCard('Transactions', '${activities.length}'),
                  _buildPDFStatCard('Total', '${totalAmount.toStringAsFixed(2)} €'),
                  _buildPDFStatCard('Moyenne',
                      activities.isNotEmpty ? '${(totalAmount / activities.length).toStringAsFixed(2)} €' : '0.00 €'),
                ],
              ),
            ),
            pw.SizedBox(height: 24),

            // Liste des transactions
            pw.Text(
              'DÉTAIL DES TRANSACTIONS',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('#16579D'),
              ),
            ),
            pw.SizedBox(height: 12),

            pw.Table(
              border: pw.TableBorder.all(color: PdfColor.fromHex('#E2E8F0')),
              columnWidths: {
                0: const pw.FlexColumnWidth(2),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FlexColumnWidth(1.5),
                3: const pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColor.fromHex('#F1F5F9')),
                  children: [
                    _buildTableHeader('Fournisseur'),
                    _buildTableHeader('Description'),
                    _buildTableHeader('Montant'),
                    _buildTableHeader('Date'),
                  ],
                ),
                ...activities.map((activity) {
                  final date = DateTime.parse(activity['date']);
                  return pw.TableRow(
                    children: [
                      _buildTableCell(activity['site']),
                      _buildTableCell(activity['description']),
                      _buildTableCell('${activity['amount']} €', isAmount: true),
                      _buildTableCell('${date.day}/${date.month}/${date.year}'),
                    ],
                  );
                }),
              ],
            ),

            pw.SizedBox(height: 32),

            // Pied de page
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border(top: pw.BorderSide(color: PdfColor.fromHex('#E2E8F0'))),
              ),
              child: pw.Text(
                'Document généré le ${currentDate.day}/${currentDate.month}/${currentDate.year} - FlexyBanq',
                style: pw.TextStyle(fontSize: 10, color: PdfColor.fromHex('#64748B')),
                textAlign: pw.TextAlign.center,
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Rapport_Global_${currentDate.day}${currentDate.month}${currentDate.year}.pdf',
    );
  }

  pw.Widget _buildPDFStatCard(String title, String value) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromHex('#16579D'),
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 10,
            color: PdfColor.fromHex('#64748B'),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildTableHeader(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: PdfColor.fromHex('#16579D'),
        ),
      ),
    );
  }

  pw.Widget _buildTableCell(String text, {bool isAmount = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          color: isAmount ? PdfColor.fromHex('#10B981') : PdfColor.fromHex('#0F172A'),
          fontWeight: isAmount ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'tech':
        return const Color(0xFF8B5CF6);
      case 'utilities':
        return const Color(0xFF06B6D4);
      case 'divertissement':
        return const Color(0xFFEF4444);
      case 'service':
        return const Color(0xFF10B981);
      default:
        return _primaryColor;
    }
  }
}

