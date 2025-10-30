import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English';

  final List<Map<String, dynamic>> _languages = [
    {'name': 'English', 'nativeName': 'English', 'flag': '🇺🇸', 'code': 'en'},
    {'name': 'Spanish', 'nativeName': 'Español', 'flag': '🇪🇸', 'code': 'es'},
    {'name': 'French', 'nativeName': 'Français', 'flag': '🇫🇷', 'code': 'fr'},
    {'name': 'German', 'nativeName': 'Deutsch', 'flag': '🇩🇪', 'code': 'de'},
    {'name': 'Italian', 'nativeName': 'Italiano', 'flag': '🇮🇹', 'code': 'it'},
    {
      'name': 'Portuguese',
      'nativeName': 'Português',
      'flag': '🇵🇹',
      'code': 'pt',
    },
    {'name': 'Russian', 'nativeName': 'Русский', 'flag': '🇷🇺', 'code': 'ru'},
    {'name': 'Chinese', 'nativeName': '中文', 'flag': '🇨🇳', 'code': 'zh'},
    {'name': 'Japanese', 'nativeName': '日本語', 'flag': '🇯🇵', 'code': 'ja'},
    {'name': 'Korean', 'nativeName': '한국어', 'flag': '🇰🇷', 'code': 'ko'},
    {'name': 'Arabic', 'nativeName': 'العربية', 'flag': '🇸🇦', 'code': 'ar'},
    {'name': 'Hindi', 'nativeName': 'हिन्दी', 'flag': '🇮🇳', 'code': 'hi'},
    {'name': 'Urdu', 'nativeName': 'اردو', 'flag': '🇵🇰', 'code': 'ur'},
    {'name': 'Turkish', 'nativeName': 'Türkçe', 'flag': '🇹🇷', 'code': 'tr'},
  ];

  // Helper methods for theme colors
  Color _getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 10, 18, 30)
        : Color(0xFFFAFAFA);
  }

  Color _getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 14, 25, 41)
        : Colors.white;
  }

  Color _getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Color(0xFF1A2B49);
  }

  Color _getSubtitleColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFFB0B0B0)
        : Color(0xFF666B7A);
  }

  Color _getBackButtonColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 14, 25, 41)
        : Color(0xFFF5F5F5);
  }

  Color _getFlagBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 18, 30, 48)
        : Color(0xFFF5F5F5);
  }

  Color _getCheckBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 18, 30, 48)
        : Color(0xFFF5F5F5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),

            // Info Banner
            _buildInfoBanner(),

            // Languages List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                itemCount: _languages.length,
                itemBuilder: (context, index) {
                  return _buildLanguageItem(_languages[index], context);
                },
              ),
            ),

            // Apply Button
            _buildApplyButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _getBackButtonColor(context),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_back,
                color: _getTextColor(context),
                size: 20,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'Language',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _getTextColor(context),
                ),
              ),
            ),
          ),
          SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      margin: EdgeInsets.fromLTRB(18, 16, 18, 0),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B5C8C), Color(0xFF28E3ED)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF28E3ED).withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.translate, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Your Language',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Choose your preferred language',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageItem(
    Map<String, dynamic> language,
    BuildContext context,
  ) {
    final isSelected = _selectedLanguage == language['name'];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedLanguage = language['name'];
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _getCardColor(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color(0xFF28E3ED) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            // Flag
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _getFlagBgColor(context),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(language['flag'], style: TextStyle(fontSize: 28)),
              ),
            ),
            SizedBox(width: 12),
            // Language Names
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language['name'],
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _getTextColor(context),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    language['nativeName'],
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      color: _getSubtitleColor(context),
                    ),
                  ),
                ],
              ),
            ),
            // Check Icon
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [Color(0xFF0B5C8C), Color(0xFF28E3ED)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null,
                color: isSelected ? null : _getCheckBgColor(context),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: isSelected ? Colors.white : _getSubtitleColor(context),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _getCardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Language changed to $_selectedLanguage'),
                backgroundColor: Color(0xFF00D68F),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0B5C8C),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Apply Changes',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.check_circle_outline, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
