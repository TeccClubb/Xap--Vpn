import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _faqs = [
    {
      'question': 'How do I connect to VPN?',
      'answer':
          'Simply tap the connect button on the home screen. The app will automatically select the best server for you.',
      'icon': Icons.wifi,
      'color': Color(0xFF0B5C8C),
    },
    {
      'question': 'Why is my connection slow?',
      'answer':
          'Try switching to a different server location closer to you. You can also change the protocol in settings for better speed.',
      'icon': Icons.speed,
      'color': Color(0xFFFF9500),
    },
    {
      'question': 'How do I change server location?',
      'answer':
          'Go to the Countries tab and select your preferred server location from the list of available countries.',
      'icon': Icons.public,
      'color': Color(0xFF00D68F),
    },
    {
      'question': 'What is Kill Switch?',
      'answer':
          'Kill Switch automatically blocks your internet connection if the VPN disconnects, protecting your data from exposure.',
      'icon': Icons.security,
      'color': Color(0xFFFF3B30),
    },
    {
      'question': 'How to upgrade to Premium?',
      'answer':
          'Tap on "Try Premium" button or go to Settings > Subscription to view and purchase premium plans.',
      'icon': Icons.upgrade,
      'color': Color(0xFF5E5CE6),
    },
    {
      'question': 'Is my data encrypted?',
      'answer':
          'Yes! We use military-grade 256-bit AES encryption to protect all your data and online activities.',
      'icon': Icons.lock,
      'color': Color(0xFF007AFF),
    },
  ];

  final List<Map<String, dynamic>> _contactOptions = [
    {
      'title': 'Email Support',
      'subtitle': 'support@xapvpn.com',
      'icon': Icons.email_outlined,
      'color': Color(0xFF0B5C8C),
    },
    {
      'title': 'Live Chat',
      'subtitle': 'Chat with our team',
      'icon': Icons.chat_bubble_outline,
      'color': Color(0xFF00D68F),
    },
    {
      'title': 'Call Us',
      'subtitle': '+1 (800) 123-4567',
      'icon': Icons.phone_outlined,
      'color': Color(0xFF5E5CE6),
    },
    {
      'title': 'FAQs',
      'subtitle': 'Find quick answers',
      'icon': Icons.help_outline,
      'color': Color(0xFFFF9500),
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  Color _getDividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2A2A2A)
        : Color(0xFFF0F0F0);
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

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),

                    // Welcome Card
                    _buildWelcomeCard(),

                    SizedBox(height: 24),

                    // Search Bar
                    _buildSearchBar(context),

                    SizedBox(height: 24),

                    // Contact Options
                    _buildSectionTitle('Contact Us', context),
                    SizedBox(height: 12),
                    _buildContactOptions(context),

                    SizedBox(height: 24),

                    // FAQs
                    _buildSectionTitle('Frequently Asked Questions', context),
                    SizedBox(height: 12),
                    _buildFAQs(context),

                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
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
                'Help & Support',
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

  Widget _buildWelcomeCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B5C8C), Color(0xFF28E3ED)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF28E3ED).withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.support_agent, color: Colors.white, size: 32),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We\'re Here to Help!',
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Get assistance 24/7 from our support team',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
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

  Widget _buildSearchBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      padding: EdgeInsets.symmetric(horizontal: 14),
      height: 48,
      decoration: BoxDecoration(
        color: _getCardColor(context),
        borderRadius: BorderRadius.circular(12),
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
          Icon(Icons.search, color: _getSubtitleColor(context), size: 22),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                color: _getTextColor(context),
              ),
              decoration: InputDecoration(
                hintText: 'Search for help...',
                hintStyle: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  color: _getSubtitleColor(context),
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _getTextColor(context),
        ),
      ),
    );
  }

  Widget _buildContactOptions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
        ),
        itemCount: _contactOptions.length,
        itemBuilder: (context, index) {
          final option = _contactOptions[index];
          return GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening ${option['title']}...'),
                  backgroundColor: Color(0xFF00D68F),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _getCardColor(context),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: option['color'].withOpacity(isDark ? 0.2 : 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      option['icon'],
                      color: option['color'],
                      size: 22,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    option['title'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _getTextColor(context),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    option['subtitle'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 10,
                      color: _getSubtitleColor(context),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFAQs(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: _getCardColor(context),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: _faqs.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> faq = entry.value;

          return Column(
            children: [
              _buildFAQItem(faq, context),
              if (index < _faqs.length - 1)
                Padding(
                  padding: const EdgeInsets.only(left: 64),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: _getDividerColor(context),
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFAQItem(Map<String, dynamic> faq, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        expansionTileTheme: ExpansionTileThemeData(
          textColor: _getTextColor(context),
          iconColor: _getTextColor(context),
          collapsedTextColor: _getTextColor(context),
          collapsedIconColor: _getSubtitleColor(context),
        ),
      ),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: faq['color'].withOpacity(isDark ? 0.2 : 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(faq['icon'], color: faq['color'], size: 20),
        ),
        title: Text(
          faq['question'],
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _getTextColor(context),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(64, 0, 16, 16),
            child: Text(
              faq['answer'],
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                color: _getSubtitleColor(context),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
