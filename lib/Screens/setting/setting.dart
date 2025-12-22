import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xap_vpn/Providers/VpnProvide/vpnProvide.dart';
import 'package:xap_vpn/Screens/setting/Accout.dart';
import 'package:xap_vpn/Screens/setting/feedback.dart';
import 'package:xap_vpn/Screens/setting/help.dart';
import 'package:xap_vpn/Screens/setting/language.dart';
import 'package:xap_vpn/Screens/setting/premiun.dart';
import 'package:xap_vpn/Screens/setting/privacy.dart';
import 'package:xap_vpn/Screens/setting/protocol.dart';
import 'package:xap_vpn/Screens/setting/rate.dart';
import 'package:xap_vpn/Screens/setting/term.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;

  @override
  void initState() {
    super.initState();
    // Load settings from provider on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<VpnProvide>();
      provider.loadAutoConnectState(); // Load auto-connect state from storage
      provider.myKillSwitch(); // Load kill-switch state from storage
      provider.lProtocolFromStorage(); // Load protocol from storage
    });
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

  Color _getDividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2A2A2A)
        : Color(0xFFF0F0F0);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VpnProvide>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: _getBackgroundColor(context),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(context),

                  SizedBox(height: 16),

                  // Premium Card
                  _buildPremiumCard(context, provider),

                  SizedBox(height: 24),

                  // Account Section
                  _buildSectionTitle('Account', context),
                  SizedBox(height: 12),
                  _buildAccountSection(context, provider),

                  SizedBox(height: 24),

                  // Connection Section
                  _buildSectionTitle('Connection', context),
                  SizedBox(height: 12),
                  _buildConnectionSection(context, provider),

                  SizedBox(height: 24),

                  // General Section
                  _buildSectionTitle('General', context),
                  SizedBox(height: 12),
                  _buildGeneralSection(context),

                  SizedBox(height: 24),

                  // Support Section
                  _buildSectionTitle('Support', context),
                  SizedBox(height: 12),
                  _buildSupportSection(context),

                  SizedBox(height: 24),

                  // About Section
                  _buildSectionTitle('About', context),
                  SizedBox(height: 12),
                  _buildAboutSection(context),

                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      child: Text(
        'Setting',
        style: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: _getTextColor(context),
        ),
      ),
    );
  }

  Widget _buildPremiumCard(BuildContext context, VpnProvide provider) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VPN Premium',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Unlock all features',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('👑', style: TextStyle(fontSize: 24)),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 44,
            child: ElevatedButton(
              onPressed: () {
                Get.to(PremiumScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFF0B5C8C),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Upgrade Now',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
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

  Widget _buildAccountSection(BuildContext context, VpnProvide provider) {
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
        children: [
          _buildMenuItem(
            context: context,
            icon: Icons.person_outline,
            iconBgColor: Color(0xFF0B5C8C),
            title: 'Profile',
            subtitle: provider.user.isNotEmpty
                ? provider.user.first.email
                : 'Manage your account',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountScreen()),
              );
            },
          ),
          _buildDivider(context),
          _buildMenuItem(
            context: context,
            icon: Icons.card_membership_outlined,
            iconBgColor: Color(0xFF0B5C8C),
            title: 'Subscription',
            subtitle: provider.isPremium ? 'Premium Plan' : 'Free Plan',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PremiumScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionSection(BuildContext context, VpnProvide provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get protocol name
    String protocolName = 'WireGuard';
    if (provider.selectedProtocol == Protocol.wireguard) {
      protocolName = 'WireGuard';
    } else if (provider.selectedProtocol == Protocol.singbox) {
      protocolName = 'Singbox';
    }

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
        children: [
          _buildSwitchItem(
            context: context,
            icon: Icons.wifi,
            iconBgColor: Color(0xFF0B5C8C),
            title: 'Auto Connect',
            subtitle: 'Connect on app start',
            value: provider.autoConnectOn,
            onChanged: (value) {
              provider.toggleAutoConnectState();
            },
          ),
          _buildDivider(context),
          _buildSwitchItem(
            context: context,
            icon: Icons.security,
            iconBgColor: Color(0xFF0B5C8C),
            title: 'Kill Switch',
            subtitle: 'Block traffic if VPN drops',
            value: provider.killSwitchOn,
            onChanged: (value) {
              provider.toggleKillSwitchState();
            },
          ),
          _buildDivider(context),
          _buildMenuItem(
            context: context,
            icon: Icons.shield_outlined,
            iconBgColor: Color(0xFF0B5C8C),
            title: 'Protocol',
            subtitle: protocolName,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProtocolScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSection(BuildContext context) {
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
        children: [
          _buildSwitchItem(
            context: context,
            icon: Icons.notifications_outlined,
            iconBgColor: Color(0xFFFF9500),
            title: 'Notifications',
            subtitle: 'Get important updates',
            value: _notifications,
            onChanged: (value) {
              setState(() {
                _notifications = value;
              });
            },
          ),
          _buildDivider(context),
          _buildSwitchItem(
            context: context,
            icon: Icons.dark_mode_outlined,
            iconBgColor: Color(0xFF5E5CE6),
            title: 'Dark Mode',
            subtitle: 'Switch to dark theme',
            value: Get.isDarkMode,
            onChanged: (value) {
              Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),
          _buildDivider(context),
          _buildMenuItem(
            context: context,
            icon: Icons.language_outlined,
            iconBgColor: Color(0xFF00D68F),
            title: 'Language',
            subtitle: 'English',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LanguageScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
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
        children: [
          _buildMenuItem(
            context: context,
            icon: Icons.feedback_outlined,
            iconBgColor: Color(0xFFFF3B30),
            title: 'Feedback',
            subtitle: 'Share your thoughts',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FeedbackScreen()),
              );
            },
          ),
          _buildDivider(context),
          _buildMenuItem(
            context: context,
            icon: Icons.help_outline,
            iconBgColor: Color(0xFF007AFF),
            title: 'Help & Support',
            subtitle: 'Get assistance',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HelpSupportScreen()),
              );
            },
          ),
          _buildDivider(context),
          _buildMenuItem(
            context: context,
            icon: Icons.star_outline,
            iconBgColor: Color(0xFFFFCC00),
            title: 'Rate App',
            subtitle: 'Rate us on store',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RateAppScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
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
        children: [
          _buildMenuItem(
            context: context,
            icon: Icons.description_outlined,
            iconBgColor: Color(0xFF8E8E93),
            title: 'Privacy Policy',
            subtitle: 'Read our policy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );
            },
          ),
          _buildDivider(context),
          _buildMenuItem(
            context: context,
            icon: Icons.article_outlined,
            iconBgColor: Color(0xFF8E8E93),
            title: 'Terms of Service',
            subtitle: 'View terms',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsServiceScreen()),
              );
            },
          ),
          _buildDivider(context),
          _buildMenuItem(
            context: context,
            icon: Icons.info_outline,
            iconBgColor: Color(0xFF8E8E93),
            title: 'App Version',
            subtitle: '1.0.0',
            showArrow: false,
            onTap: () {},
          ),
          _buildDivider(context),
          _buildMenuItem(
            context: context,
            icon: Icons.logout,
            iconBgColor: Colors.red,
            title: 'Sign Out',
            subtitle: 'Logout from this device',
            onTap: () async {
              // Show confirmation dialog
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: _getCardColor(context),
                  title: Text(
                    'Sign Out',
                    style: GoogleFonts.outfit(
                      color: _getTextColor(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  content: Text(
                    'Are you sure you want to sign out?',
                    style: GoogleFonts.spaceGrotesk(
                      color: _getSubtitleColor(context),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (confirm == true && context.mounted) {
                final provider = context.read<VpnProvide>();
                await provider.logout(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _getTextColor(context),
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11,
                      color: _getSubtitleColor(context),
                    ),
                  ),
                ],
              ),
            ),
            if (showArrow)
              Icon(
                Icons.chevron_right,
                color: _getSubtitleColor(context),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required BuildContext context,
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _getTextColor(context),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    color: _getSubtitleColor(context),
                  ),
                ),
              ],
            ),
          ),
          // Custom Gradient Switch
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Transform.scale(
              scale: 0.8,
              child: Container(
                width: 51,
                height: 31,
                decoration: BoxDecoration(
                  gradient: value
                      ? LinearGradient(
                          colors: [Color(0xFF0B5C8C), Color(0xFF28E3ED)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        )
                      : null,
                  color: value ? null : Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      left: value ? 20 : 0,
                      right: value ? 0 : 20,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        margin: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 64),
      child: Divider(height: 1, thickness: 1, color: _getDividerColor(context)),
    );
  }
}
