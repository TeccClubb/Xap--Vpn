import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

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
                      'Information We Collect',
                      'We collect information that you provide directly to us, including:\n\n• Account information (email, username)\n• Payment information for premium subscriptions\n• Device information and IP addresses\n• Connection logs (when connected/disconnected)\n• Crash reports and performance data',
                      Icons.info_outline,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'How We Use Your Information',
                      'We use the information we collect to:\n\n• Provide and maintain our VPN service\n• Process payments and transactions\n• Send you technical notices and updates\n• Respond to your comments and questions\n• Improve our services and user experience\n• Detect and prevent fraud or abuse',
                      Icons.check_circle_outline,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'Data Security',
                      'We implement industry-standard security measures to protect your data:\n\n• 256-bit AES encryption\n• Secure server infrastructure\n• Regular security audits\n• No-logs policy for browsing activity\n• Encrypted data transmission',
                      Icons.security,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'Third-Party Services',
                      'We may use third-party services for:\n\n• Payment processing (secure payment gateways)\n• Analytics (anonymized data only)\n• Cloud infrastructure\n• Customer support tools\n\nThese services have their own privacy policies.',
                      Icons.business,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'Your Rights',
                      'You have the right to:\n\n• Access your personal data\n• Correct inaccurate information\n• Request data deletion\n• Opt-out of marketing communications\n• Export your data\n• Lodge a complaint with authorities',
                      Icons.verified_user,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'Data Retention',
                      'We retain your personal information for as long as necessary to provide our services and comply with legal obligations. You can request deletion of your account at any time.',
                      Icons.access_time,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'Children\'s Privacy',
                      'Our service is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13.',
                      Icons.child_care,
                    ),

                    SizedBox(height: 20),

                    _buildSection(
                      context,
                      'Changes to This Policy',
                      'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last Updated" date.',
                      Icons.update,
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
                'Privacy Policy',
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
            child: Icon(Icons.shield, color: Colors.white, size: 24),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Privacy Matters',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'We\'re committed to protecting your data',
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
            'Questions About Privacy?',
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _getTextColor(context),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'If you have any questions about this Privacy Policy, please contact us:',
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
                'privacy@xapvpn.com',
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
