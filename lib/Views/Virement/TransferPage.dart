// TransferPage.dart
import 'package:flexybank_intership/Views/Home/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'SendMoneyPage.dart'; // Import SendMoneyPage

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
}

class TransferPage extends StatefulWidget {
  final String recipientName;

  const TransferPage({super.key, required this.recipientName});

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  String selectedCard = "Carte •••• 4008";
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.inputBackground,
      appBar: AppBar(
        backgroundColor: AppColors.inputBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Virement',
          style: TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Montant
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Text(
                    '1480,50 €',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1,5% ≈ 1,48 € de frais',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.placeholderColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Moyen de paiement
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Section "Payer avec"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payer avec',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.placeholderColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            selectedCard,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.placeholderColor,
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 24),
                  Divider(color: AppColors.accentColor.withOpacity(0.3)),
                  SizedBox(height: 24),

                  // Section "Envoyer à"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Envoyer à',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.placeholderColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        widget.recipientName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 24),
                  Divider(color: AppColors.accentColor.withOpacity(0.3)),
                  SizedBox(height: 24),

                  // Section "Note"
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Note',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.placeholderColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: noteController,
                        decoration: InputDecoration(
                          hintText: 'Écrire une note',
                          hintStyle: TextStyle(
                            color: AppColors.placeholderColor.withOpacity(0.7),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Spacer(),

            // Bouton Continuer
            Container(
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
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              SendMoneyPage(recipient: widget.recipientName),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Continuer le virement',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),

      // ✅ Ajout de la barre de navigation en bas
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 1, // Mets l’index selon l’onglet Virement
        onTap: (index) {
          HapticFeedback.lightImpact();
        },
      ),
    );
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }
}
