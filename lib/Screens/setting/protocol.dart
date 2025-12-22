import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xap_vpn/Providers/VpnProvide/vpnProvide.dart';

class ProtocolScreen extends StatefulWidget {
  const ProtocolScreen({Key? key}) : super(key: key);

  @override
  State<ProtocolScreen> createState() => _ProtocolScreenState();
}

class _ProtocolScreenState extends State<ProtocolScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load protocol from provider when screen loads
    final provider = Provider.of<VpnProvide>(context, listen: false);
    provider.lProtocolFromStorage();
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

  Color _getIconBgColor(BuildContext context, Color originalColor) {
    return Theme.of(context).brightness == Brightness.dark
        ? originalColor.withOpacity(0.2)
        : originalColor.withOpacity(0.1);
  }

  Color _getCheckBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 18, 30, 48)
        : Color(0xFFF5F5F5);
  }

  Color _getSpeedBarBgColor(BuildContext context) {
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
            child: Column(
              children: [
                // Header
                _buildHeader(context),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    child: Column(
                      children: [
                        _buildProtocolCard(
                          provider: provider,
                          protocol: Protocol.wireguard,
                          name: 'WireGuard',
                          description: 'Modern and lightweight',
                          speed: 'Excellent',
                          speedValue: 0.95,
                          security: 'High Security',
                          protocolType: 'UDP',
                          encryption: 'ChaCha20',
                          recommended: true,
                          color: Color(0xFF00D68F),
                          icon: Icons.rocket_launch,
                          context: context,
                        ),
                        SizedBox(height: 16),
                        _buildProtocolCard(
                          provider: provider,
                          protocol: Protocol.singbox,
                          name: 'SingBox',
                          description: 'Next-generation VPN protocol',
                          speed: 'Excellent',
                          speedValue: 0.95,
                          security: 'High Security',
                          protocolType: 'Advanced',
                          encryption: 'Multi-layer',
                          recommended: false,
                          color: Color(0xFF5E5CE6),
                          icon: Icons.bolt,
                          context: context,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
                'Protocol',
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

  Widget _buildProtocolCard({
    required VpnProvide provider,
    required Protocol protocol,
    required String name,
    required String description,
    required String speed,
    required double speedValue,
    required String security,
    required String protocolType,
    required String encryption,
    required bool recommended,
    required Color color,
    required IconData icon,
    required BuildContext context,
  }) {
    final isSelected = provider.selectedProtocol == protocol;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () async {
        // Try to set the protocol
        final success = await provider.setProtocol(protocol);

        if (!success && mounted) {
          // Show error message if protocol change failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Please disconnect VPN before changing protocol',
                style: GoogleFonts.spaceGrotesk(color: Colors.white),
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (success && mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Protocol changed to $name',
                style: GoogleFonts.spaceGrotesk(color: Colors.white),
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _getCardColor(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Color(0xFF28E3ED) : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Icon with Gradient when selected
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [Color(0xFF0B5C8C), Color(0xFF28E3ED)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                    color: isSelected ? null : _getIconBgColor(context, color),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : color,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                // Name and Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _getTextColor(context),
                            ),
                          ),
                          SizedBox(width: 8),
                          if (recommended)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFFF9500),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Recommended',
                                style: GoogleFonts.outfit(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        description,
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
                  curve: Curves.easeInOut,
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Color(0xFF0B5C8C)
                        : _getCheckBgColor(context),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check,
                    color: isSelected
                        ? Colors.white
                        : _getSubtitleColor(context),
                    size: 16,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Speed Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Speed',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: _getSubtitleColor(context),
                  ),
                ),
                Text(
                  speed,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _getTextColor(context),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),

            // Speed Bar with Gradient
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  color: _getSpeedBarBgColor(context),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: speedValue,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF0B5C8C), Color(0xFF28E3ED)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Details Row
            Row(
              children: [
                // Security Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF00D68F),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    security,
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                // Protocol Type
                Text(
                  protocolType,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: _getSubtitleColor(context),
                  ),
                ),
                Spacer(),
                // Encryption
                Text(
                  encryption,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: _getSubtitleColor(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
