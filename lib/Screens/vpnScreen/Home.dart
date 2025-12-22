import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xap_vpn/Providers/VpnProvide/vpnProvide.dart';
import 'package:xap_vpn/Screens/setting/premiun.dart';
import 'package:xap_vpn/DataModel/serverDataModel.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onChangeServerTap;

  const HomeScreen({Key? key, this.onChangeServerTap}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  double _dragPosition = 0;
  final double _buttonWidth = 160;
  final double _circleSize = 54;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Load data only if not already loaded (from splash screen)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<VpnProvide>();

      // Only load if servers are empty (means user came directly without splash)
      if (provider.servers.isEmpty) {
        await provider.getUser();
        await provider.getPremium();
        provider.lProtocolFromStorage();
        provider.myKillSwitch();
        await provider.getServersPlease(true);
        await provider.loadFavoriteServers();
        await provider.loadSelectedServerIndex();

        // Validate that free users don't have premium servers selected
        await provider.validateAndFixSelectedServer();

        // Auto-select fastest server if no valid server is selected
        if (provider.servers.isNotEmpty) {
          if (provider.selectedServerIndex == 0 ||
              provider.selectedServerIndex >= provider.servers.length) {
            await provider.selectFastestServerByHealth();
          }
        }

        // Ping all servers once after loading
        if (provider.servers.isNotEmpty) {
          provider.pingAllServers(); // Don't await - let it run in background
        }

        // Check and trigger auto-connect ONLY when loading fresh (not on app restart)
        await provider.autoC(context);
      } else {
        // On app restart, just sync the VPN state without triggering auto-connect
        log("App restart detected - checking VPN state");
        await provider.syncVpnStateOnRestart();
      }

      // Start timer if already connected (e.g., after app restart)
      if (provider.vpnConnectionStatus == VpnStatusConnectionStatus.connected) {
        if (provider.connectionDuration == 0) {
          provider.startConnectionTimer();
        }
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  // Helper methods for theme colors (matching Server screen)
  Color _getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 10, 18, 30)
        : Color(0xFFFAFAFA);
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

  Color _getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 14, 25, 41)
        : Colors.white;
  }

  Color _getIconBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2A2A2A)
        : Color(0xFFF5F5F5);
  }

  Color _getButtonBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 14, 25, 41)
        : Color(0xFFF5F5F5);
  }

  void _toggleConnection() async {
    final provider = context.read<VpnProvide>();

    // Prevent action if already in a transitional state
    if (provider.isloading) {
      return;
    }

    // Toggle VPN connection
    await provider.toggleVpn();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final provider = context.read<VpnProvide>();
    bool isConnected =
        provider.vpnConnectionStatus == VpnStatusConnectionStatus.connected;

    setState(() {
      _dragPosition += details.delta.dx;

      if (isConnected) {
        _dragPosition = _dragPosition.clamp(
          -(_buttonWidth - _circleSize - 16),
          0.0,
        );
      } else {
        _dragPosition = _dragPosition.clamp(
          0.0,
          _buttonWidth - _circleSize - 16,
        );
      }
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    final provider = context.read<VpnProvide>();
    bool isConnected =
        provider.vpnConnectionStatus == VpnStatusConnectionStatus.connected;
    double threshold = (_buttonWidth - _circleSize - 16) * 0.5;

    if (isConnected) {
      if (_dragPosition < -threshold) {
        _toggleConnection();
        _dragPosition = 0;
      } else {
        setState(() {
          _dragPosition = 0;
        });
      }
    } else {
      if (_dragPosition > threshold) {
        _toggleConnection();
        _dragPosition = 0;
      } else {
        setState(() {
          _dragPosition = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(context),
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image (World Map)
            Positioned.fill(
              child: Opacity(
                opacity: 0.5,
                child: Image.asset('assets/wolrd map.png', fit: BoxFit.cover),
              ),
            ),

            // Main Content - Wrapped with Consumer to watch VPN status
            Consumer<VpnProvide>(
              builder: (context, provider, child) {
                // Show error message if any
                if (provider.connectionError != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.connectionError!),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 4),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    provider.connectionError =
                        null; // Clear error after showing
                  });
                }

                bool isConnected =
                    provider.vpnConnectionStatus ==
                    VpnStatusConnectionStatus.connected;

                return Column(
                  children: [
                    // Header
                    _buildHeader(context),

                    // Content
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          // Status Icon
                          Icon(
                            isConnected ? Icons.shield : Icons.shield_outlined,
                            size: 28,
                            color: isConnected
                                ? Color(0xFF27E9E4)
                                : _getTextColor(context),
                          ),

                          SizedBox(height: 12),
                          // Status Text
                          Text(
                            isConnected ? 'Protected' : 'UnProtected!',
                            style: GoogleFonts.outfit(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: _getTextColor(context),
                            ),
                          ),

                          SizedBox(height: 6),
                          // Status Subtitle
                          Text(
                            isConnected
                                ? 'Your connection is secure'
                                : 'Your connection is not secure',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 13,
                              color: _getSubtitleColor(context),
                            ),
                          ),

                          SizedBox(height: 32),
                          // Timer (only show when connected)
                          if (isConnected) ...[
                            Text(
                              provider.getFormattedConnectionTime(),
                              style: GoogleFonts.outfit(
                                fontSize: 42,
                                fontWeight: FontWeight.w600,
                                color: _getTextColor(context),
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(height: 32),
                          ] else ...[
                            SizedBox(height: 93),
                          ],

                          // Swipe Button
                          _buildSwipeButton(provider),

                          Spacer(),

                          // Server Selection Card
                          _buildServerCard(context, provider),

                          // Change Server Button (only when connected and NOT manually selected)
                          if (isConnected && !provider.isManuallySelected) ...[
                            SizedBox(height: 14),
                            _buildChangeServerButton(context),
                          ],

                          SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/Xap VPN.png', width: 42, height: 42),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xap VPN',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: _getTextColor(context),
                    ),
                  ),
                  Text(
                    'Secure • Private',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 11,
                      color: _getSubtitleColor(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.to(PremiumScreen());
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0B5C8C), Color(0xFF28E3ED)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF28E3ED).withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Try Premium',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeButton(VpnProvide provider) {
    bool isConnected =
        provider.vpnConnectionStatus == VpnStatusConnectionStatus.connected;
    bool isConnecting =
        provider.vpnConnectionStatus == VpnStatusConnectionStatus.connecting;
    bool isDisconnecting =
        provider.vpnConnectionStatus == VpnStatusConnectionStatus.disconnecting;
    double maxDrag = _buttonWidth - _circleSize - 0;
    double circleLeft = isConnected
        ? maxDrag + _dragPosition
        : 8 + _dragPosition;

    return GestureDetector(
      onHorizontalDragUpdate: (isConnecting || isDisconnecting)
          ? null
          : _onHorizontalDragUpdate,
      onHorizontalDragEnd: (isConnecting || isDisconnecting)
          ? null
          : _onHorizontalDragEnd,
      child: Container(
        width: 170,
        height: 70,
        decoration: BoxDecoration(
          color: isConnected ? Color(0xFF27E9E4) : Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: (isConnected ? Color(0xFF27E9E4) : Colors.grey)
                  .withOpacity(0.3),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Chevron icons (left side when connected)
            if (isConnected && !isDisconnecting)
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Row(
                    children: [
                      Icon(
                        Icons.chevron_left,
                        color: Colors.white.withOpacity(0.7),
                        size: 22,
                      ),
                      Icon(
                        Icons.chevron_left,
                        color: Colors.white.withOpacity(0.5),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),

            // Chevron icons (right side when disconnected)
            if (!isConnected && !isConnecting)
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Row(
                    children: [
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white.withOpacity(0.5),
                        size: 22,
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white.withOpacity(0.3),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),

            // Draggable Circle with Loading Indicator
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOut,
              left: circleLeft,
              top: 8,
              bottom: 8,
              child: Container(
                width: _circleSize,
                height: _circleSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: (isConnecting || isDisconnecting)
                    ? Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromARGB(255, 232, 105, 9),
                            ),
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServerCard(BuildContext context, VpnProvide provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    bool isConnected =
        provider.vpnConnectionStatus == VpnStatusConnectionStatus.connected;

    // Get selected server from provider
    final selectedServer =
        provider.servers.isNotEmpty &&
            provider.selectedServerIndex < provider.servers.length
        ? provider.servers[provider.selectedServerIndex]
        : null;

    // Show simpler widget if manually selected by user
    if (provider.isManuallySelected) {
      return _buildManualServerCard(
        context,
        provider,
        selectedServer,
        isConnected,
      );
    }

    // Show full widget for auto-selected servers
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _getCardColor(context),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icon with country flag badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0B5C8C), Color(0xFF28E3ED)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF28E3ED).withOpacity(0.3),
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.bolt, color: Colors.white, size: 22),
                  ),
                  // Country flag badge (only when connected)
                  if (isConnected && selectedServer != null)
                    Positioned(
                      right: -18,
                      bottom: -10,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: _getCardColor(context),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _getCardColor(context),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            selectedServer.image,
                            width: 26,
                            height: 26,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Text(
                                    '�',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 10),
              if (isConnected) SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isConnected && selectedServer != null
                          ? selectedServer.name
                          : 'Fastest Free Server',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _getTextColor(context),
                      ),
                    ),
                    if (isConnected && selectedServer != null)
                      Text(
                        selectedServer.type,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 11,
                          color: _getSubtitleColor(context),
                        ),
                      ),
                  ],
                ),
              ),
              // Ping display for auto-selected server
              if (selectedServer != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getIconBgColor(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.speed,
                        size: 14,
                        color: _getPingColor(
                          isConnected,
                          selectedServer,
                          provider,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        _getPingText(isConnected, selectedServer, provider),
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _getTextColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Auto Selected From:',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  color: _getSubtitleColor(context),
                ),
              ),
              SizedBox(width: 6),
              // Show first 5 server flags
              ...provider.servers.take(5).map((server) {
                return Container(
                  margin: EdgeInsets.only(right: 4),
                  width: 18,
                  height: 18,
                  child: ClipOval(
                    child: Image.network(
                      server.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Text('�', style: TextStyle(fontSize: 10)),
                    ),
                  ),
                );
              }).toList(),
              SizedBox(width: 4),
              if (provider.servers.length > 5)
                Text(
                  '${provider.servers.length - 5}+',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: _getSubtitleColor(context),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChangeServerButton(BuildContext context) {
    final provider = context.read<VpnProvide>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      width: double.infinity,
      height: 46,
      child: ElevatedButton(
        onPressed: () async {
          // Disconnect first
          await provider.toggleVpn(); // This will disconnect

          // Wait a moment for disconnection to complete
          await Future.delayed(Duration(milliseconds: 500));

          // Select next fastest server (excluding current one)
          await provider.selectNextFastestServer();

          if (provider.servers.isNotEmpty &&
              provider.selectedServerIndex < provider.servers.length) {
            final selectedServer =
                provider.servers[provider.selectedServerIndex];

            // Show switching message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Switching to ${selectedServer.name}...'),
                backgroundColor: Color(0xFF28E3ED),
                duration: Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );

            // Wait a moment, then reconnect with new server
            await Future.delayed(Duration(milliseconds: 500));
            await provider.toggleVpn(); // This will connect to the new server
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _getButtonBgColor(context),
          foregroundColor: _getTextColor(context),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Change Server',
          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // Simpler widget for manually selected servers - shows only flag, name, and ping
  Widget _buildManualServerCard(
    BuildContext context,
    VpnProvide provider,
    Server? selectedServer,
    bool isConnected,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get subserver name
    String getSubServerName() {
      if (selectedServer != null &&
          selectedServer.subServers != null &&
          selectedServer.subServers!.isNotEmpty &&
          provider.selectedSubServerIndex < selectedServer.subServers!.length) {
        return selectedServer.subServers![provider.selectedSubServerIndex].name;
      }
      return '';
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _getCardColor(context),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          // Server flag
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.transparent, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: selectedServer != null
                  ? Image.network(
                      selectedServer.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Text('🌍', style: TextStyle(fontSize: 24)),
                      ),
                    )
                  : Center(child: Text('🌍', style: TextStyle(fontSize: 24))),
            ),
          ),
          SizedBox(width: 14),
          // Server name and subserver
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedServer != null ? selectedServer.name : 'No Server',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _getTextColor(context),
                  ),
                ),
                SizedBox(height: 4),
                // Show subserver name if available
                if (getSubServerName().isNotEmpty) ...[
                  Text(
                    getSubServerName(),
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 12,
                      color: _getSubtitleColor(context),
                    ),
                  ),
                  // SizedBox(height: 2),
                ],
                // Text(
                //   selectedServer != null ? selectedServer.type : '',
                //   style: GoogleFonts.spaceGrotesk(
                //     fontSize: 11,
                //     color: _getSubtitleColor(context).withOpacity(0.7),
                //   ),
                // ),
              ],
            ),
          ),
          // Ping display
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _getIconBgColor(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.speed,
                  size: 16,
                  color: _getPingColor(isConnected, selectedServer, provider),
                ),
                SizedBox(width: 6),
                Text(
                  _getPingText(isConnected, selectedServer, provider),
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _getTextColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for ping display
  Color _getPingColor(bool isConnected, Server? server, VpnProvide provider) {
    if (isConnected && provider.pingSpeed != "0") {
      return Color(0xFF28E3ED);
    }
    if (!isConnected &&
        server != null &&
        server.pingMs > 0 &&
        server.pingMs < 9999) {
      return Color(0xFF28E3ED);
    }
    return _getSubtitleColor(context);
  }

  String _getPingText(bool isConnected, Server? server, VpnProvide provider) {
    // When connected, show real-time ping
    if (isConnected && provider.pingSpeed != "0") {
      return '${provider.pingSpeed}ms';
    }
    // When not connected, show stored ping from server
    if (!isConnected && server != null) {
      if (server.pingMs > 0 && server.pingMs < 9999) {
        return '${server.pingMs}ms';
      }
      if (server.pingMs == 9999) {
        return 'N/A';
      }
    }
    return '--';
  }
}
