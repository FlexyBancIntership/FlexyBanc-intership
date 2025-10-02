import 'package:flexybank_intership/Views/Home/bottom_navigation_bar.dart';
import 'package:flexybank_intership/Views/Virement/AddNewContactScreen.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// Data model for recipients
class Recipient {
  final String name;
  final String account;
  final String avatar;
  final Color flagColor;

  Recipient({
    required this.name,
    required this.account,
    required this.avatar,
    required this.flagColor,
  });
}

class Listescreen extends StatefulWidget {
  const Listescreen({super.key});

  @override
  _ListeScreenState createState() => _ListeScreenState();
}

class _ListeScreenState extends State<Listescreen> {
  // Unified color scheme
  static const Color _primaryColor = Color(0xFF16579D);
  static const Color _accentColor = Color(0xFF97DAFF);
  static const Color _inputBackground = Color(0xFFE8F2FF);
  static const Color _placeholderColor = Color(0xFF8DA4C2);
  static const Color _textColor = Color(0xFF1B1D4D);
  static const Color _backgroundColor = Color(0xFFFFFFFF);

  final TextEditingController _searchController = TextEditingController();
  List<Recipient> filteredRecipients = [];
  Timer? _debounce;

  // Sample data for recipients
  final List<Recipient> recipients = [
    Recipient(
      name: 'Harrison Phillips',
      account: 'USD • Account ending in **** 4008',
      avatar: 'H',
      flagColor: Colors.red,
    ),
    Recipient(
      name: 'Rustem Tolstobrov',
      account: 'GBP • Account ending in **** 3240',
      avatar: 'R',
      flagColor: Colors.blue,
    ),
    Recipient(
      name: 'Alicia Puma',
      account: 'EUR • Account ending in **** 5600',
      avatar: 'A',
      flagColor: Colors.yellow,
    ),
    Recipient(
      name: 'Nonieal Joyi',
      account: 'USD • Account ending in **** 8390',
      avatar: 'N',
      flagColor: Colors.red,
    ),
  ];

  @override
  void initState() {
    super.initState();
    filteredRecipients = recipients;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _filterRecipients(_searchController.text);
    });
  }

  void _filterRecipients(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredRecipients = recipients;
      } else {
        filteredRecipients =
            recipients
                .where(
                  (recipient) =>
                      recipient.name.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      recipient.account.toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .toList();
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Transfers',
          style: TextStyle(
            color: _textColor,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.lock, color: _primaryColor),
              onPressed: () {
                _showSnackBar('Secure transfers enabled');
              },
              tooltip: 'Security Info',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: _inputBackground,
              child: Icon(Icons.person, color: _primaryColor),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  label: 'Add new beneficiary',
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddNewContactScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Nouveau bénéficiaire',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _searchController,
                  style: const TextStyle(color: _textColor),
                  decoration: InputDecoration(
                    hintText: 'Rechercher un bénéficiaire...',
                    hintStyle: const TextStyle(color: _placeholderColor),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: _placeholderColor,
                    ),
                    suffixIcon:
                        _searchController.text.isNotEmpty
                            ? IconButton(
                              icon: const Icon(
                                Icons.clear,
                                color: _placeholderColor,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _filterRecipients('');
                              },
                            )
                            : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: _inputBackground,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Les bénéficiaires récents',
                  style: TextStyle(
                    color: _textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: recipients.take(4).length,
                    itemBuilder: (context, index) {
                      final recipient = recipients[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: GestureDetector(
                          onTap:
                              () => _showSnackBar(
                                '${recipient.name} selected for transfer',
                              ),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: _inputBackground,
                                child: Text(
                                  recipient.avatar,
                                  style: const TextStyle(
                                    color: _textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 80,
                                child: Text(
                                  recipient.name.split(' ').first,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: _textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tous les bénéficiaires',
                      style: TextStyle(
                        color: _textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${filteredRecipients.length}',
                        style: const TextStyle(
                          color: _primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (filteredRecipients.isEmpty)
                  const Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: _placeholderColor,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Aucun bénéficiaire trouvé',
                          style: TextStyle(
                            color: _placeholderColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredRecipients.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final recipient = filteredRecipients[index];
                      return AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 300),
                        child: GenericCard(
                          title: recipient.name,
                          subtitle: recipient.account,
                          avatar: recipient.avatar,
                          flagColor: recipient.flagColor,
                          isAccount: false,
                          onTap:
                              () => _showSnackBar(
                                '${recipient.name} selected - Proceed to transfer?',
                              ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          // Navigation logic is handled in CustomBottomNavigationBar
        },
      ),
    );
  }
}

class GenericCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? avatar;
  final Color flagColor;
  final bool isAccount;
  final VoidCallback? onTap;

  // Colors
  static const Color _primaryColor = Color(0xFF16579D);
  static const Color _inputBackground = Color(0xFFE8F2FF);
  static const Color _placeholderColor = Color(0xFF8DA4C2);
  static const Color _textColor = Color(0xFF1B1D4D);

  const GenericCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.avatar,
    required this.flagColor,
    required this.isAccount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: _inputBackground,
                child: Text(
                  avatar ?? '',
                  style: const TextStyle(
                    color: _textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: _textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: flagColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            subtitle,
                            style: const TextStyle(
                              color: _placeholderColor,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: _placeholderColor,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
