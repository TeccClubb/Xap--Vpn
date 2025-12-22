import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsServiceScreen extends StatelessWidget {
  const TermsServiceScreen({Key? key}) : super(key: key);

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

  Color _getLastUpdatedBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 18, 30, 48)
        : Color(0xFFF8F9FA);
  }

  Color _getBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2A2A2A)
        : Color(0xFFE0E0E0);
  }

  Color _getIconBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF1A3A5C).withOpacity(0.3)
        : Color(0xFF0B5C8C).withOpacity(0.1);
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
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Info Banner
                    _buildInfoBanner(),

                    SizedBox(height: 24),

                    // Last Updated
                    _buildLastUpdated(context),

                    SizedBox(height: 24),

                    // Content
                    _buildSection(
                      context,
                      'Acceptance of Terms',
                      'By accessing and using Xap VPN, you accept and agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use our service.',
                      Icons.done_all,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'Service Description',
                      'Xap VPN provides a virtual private network service that:\n\n• Encrypts your internet connection\n• Protects your online privacy\n• Allows access to geo-restricted content\n• Offers both free and premium plans\n\nWe strive to maintain 99.9% uptime but cannot guarantee uninterrupted service.',
                      Icons.vpn_lock,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'User Obligations',
                      'You agree to:\n\n• Provide accurate account information\n• Keep your password secure\n• Not share your account with others\n• Not use the service for illegal activities\n• Not attempt to hack or disrupt the service\n• Comply with all applicable laws',
                      Icons.rule,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'Prohibited Activities',
                      'You must NOT use Xap VPN for:\n\n• Illegal downloading or file sharing\n• Spamming or phishing\n• Hacking or cyberattacks\n• Distributing malware\n• Violating intellectual property rights\n• Harassment or hate speech\n\nViolations may result in immediate termination.',
                      Icons.block,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'Subscription & Payment',
                      'Premium subscriptions:\n\n• Are billed in advance\n• Auto-renew unless cancelled\n• Can be cancelled at any time\n• Are non-refundable (subject to applicable law)\n• May have price changes with 30 days notice\n\nFree plan limitations may apply.',
                      Icons.payment,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'Service Limitations',
                      'We reserve the right to:\n\n• Modify or discontinue features\n• Limit bandwidth on free plans\n• Restrict server access\n• Suspend accounts for violations\n• Change pricing with notice\n\nWe are not liable for service interruptions.',
                      Icons.settings,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'Intellectual Property',
                      'All content, features, and functionality of Xap VPN are owned by us and protected by copyright, trademark, and other laws. You may not copy, modify, or distribute our content without permission.',
                      Icons.copyright,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'Disclaimer of Warranties',
                      'The service is provided "AS IS" and "AS AVAILABLE" without warranties of any kind. We do not guarantee:\n\n• Specific connection speeds\n• Uninterrupted access\n• Error-free operation\n• Complete security\n\nUse at your own risk.',
                      Icons.warning_amber,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'Limitation of Liability',
                      'We shall not be liable for:\n\n• Indirect or consequential damages\n• Lost profits or data\n• Service interruptions\n• Third-party actions\n• Force majeure events\n\nOur total liability is limited to the amount you paid in the last 12 months.',
                      Icons.gavel,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'Termination',
                      'We may terminate or suspend your account:\n\n• For violations of these terms\n• For fraudulent activity\n• For extended inactivity\n• At our sole discretion\n\nYou may terminate your account at any time through settings.',
                      Icons.cancel,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'Changes to Terms',
                      'We may update these Terms of Service at any time. Continued use of the service after changes constitutes acceptance of the new terms. We will notify you of material changes.',
                      Icons.update,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'Governing Law',
                      'These terms are governed by the laws of the jurisdiction where our company is registered. Any disputes will be resolved through binding arbitration.',
                      Icons.account_balance,
                    ),

                    SizedBox(height: 24),

                    // Contact Card
                    _buildContactCard(context),

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
                'Terms of Service',
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
      padding: EdgeInsets.all(16),
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.article, color: Colors.white, size: 24),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terms of Service',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Please read these terms carefully',
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

  Widget _buildLastUpdated(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getLastUpdatedBgColor(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _getBorderColor(context), width: 1),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today,
            size: 16,
            color: _getSubtitleColor(context),
          ),
          SizedBox(width: 8),
          Text(
            'Last Updated: October 23, 2025',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              color: _getSubtitleColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _getIconBgColor(context),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Color(0xFF0B5C8C), size: 18),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _getTextColor(context),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              color: _getSubtitleColor(context),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getCardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFF28E3ED).withOpacity(
            Theme.of(context).brightness == Brightness.dark ? 0.5 : 1.0,
          ),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Questions About These Terms?',
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _getTextColor(context),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'If you have any questions about these Terms of Service, please contact us:',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              color: _getSubtitleColor(context),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.email, size: 16, color: Color(0xFF0B5C8C)),
              SizedBox(width: 8),
              Text(
                'legal@xapvpn.com',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  color: Color(0xFF0B5C8C),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
