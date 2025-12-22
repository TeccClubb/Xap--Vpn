import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xap_vpn/Providers/VpnProvide/vpnProvide.dart';
import 'package:xap_vpn/Screens/setting/premiun.dart';

class ServerScreen extends StatefulWidget {
  final VoidCallback? onServerSelected;

  const ServerScreen({Key? key, this.onServerSelected}) : super(key: key);

  @override
  State<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends State<ServerScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  int _selectedServerId = -1;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final provider = context.read<VpnProvide>();
    //   provider.loadFavoriteServers();
    //   provider.loadSelectedServerIndex();
    //   if (provider.servers.isNotEmpty) {
    //     setState(() {
    //       _selectedServerId = provider.servers[provider.selectedServerIndex].id;
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper method to get colors based on theme
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

  Color _getSearchBarColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 14, 25, 41)
        : Color(0xFFF0F0F0);
  }

  Color _getTabColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 14, 25, 41)
        : Color(0xFFF0F0F0);
  }

  Color _getFlagBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2A2A2A)
        : Color(0xFFF5F5F5);
  }

  // Calculate signal bars based on ping (lower is better)
  int _calculateSignalBars(int pingMs) {
    if (pingMs <= 50) return 4; // Excellent
    if (pingMs <= 100) return 3; // Good
    if (pingMs <= 200) return 2; // Fair
    if (pingMs <= 500) return 1; // Poor
    return 0; // Very poor
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),

            // Search Bar
            _buildSearchBar(context),

            SizedBox(height: 14),
            // Quick Actions
            _buildQuickActions(context),

            SizedBox(height: 18),
            // All Countries Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                'All Countries',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _getTextColor(context),
                ),
              ),
            ),

            SizedBox(height: 12),
            // Category Tabs
            _buildCategoryTabs(context),

            SizedBox(height: 12),
            // Countries List
            Expanded(child: _buildCountriesList(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Select Country',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: _getTextColor(context),
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(PremiumScreen());
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
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
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'Try Premium',
                style: GoogleFonts.outfit(
                  fontSize: 12,
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

  Widget _buildSearchBar(BuildContext context) {
    final provider = context.read<VpnProvide>();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      padding: EdgeInsets.symmetric(horizontal: 14),
      height: 44,
      decoration: BoxDecoration(
        color: _getSearchBarColor(context),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: provider.setQueryText,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                color: _getTextColor(context),
              ),
              decoration: InputDecoration(
                hintText: 'Search Country',
                hintStyle: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  color: _getSubtitleColor(context),
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          Icon(Icons.search, color: _getSubtitleColor(context), size: 20),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final provider = context.watch<VpnProvide>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _getTextColor(context),
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              // Check if user is premium
              if (!provider.isPremium) {
                // Check if there are any free servers available
                final hasFreeServers = provider.servers.any(
                  (server) => server.type.toLowerCase() == 'free',
                );

                if (!hasFreeServers) {
                  // No free servers available, show premium dialog
                  _showPremiumRequiredDialog('Fastest Free Server');
                  return;
                }
              }

              // Check if VPN is currently connected
              final wasConnected =
                  provider.vpnConnectionStatus ==
                  VpnStatusConnectionStatus.connected;

              // Select fastest server based on user type
              if (provider.isPremium) {
                // Premium users can use all servers
                await provider.selectFastestServerByHealth(
                  considerAllServers: true,
                );
              } else {
                // Free users can only use free servers
                // Check if there are any free servers available
                final hasFreeServers = provider.servers.any(
                  (server) => server.type.toLowerCase() == 'free',
                );

                if (!hasFreeServers) {
                  // No free servers available, show premium dialog
                  _showPremiumRequiredDialog('Fastest Free Server');
                  return;
                }

                await provider.selectFastestServerByHealth(
                  considerAllServers: false,
                );
              }

              if (provider.servers.isNotEmpty) {
                final fastestServer =
                    provider.servers[provider.selectedServerIndex];

                // Double-check the selected server is appropriate for user type
                if (!provider.isPremium &&
                    fastestServer.type.toLowerCase() != 'free') {
                  _showPremiumRequiredDialog('Fastest Free Server');
                  return;
                }

                setState(() {
                  _selectedServerId = fastestServer.id;
                });

                // Switch to home screen immediately
                if (widget.onServerSelected != null) {
                  widget.onServerSelected!();
                }

                // Then handle connection in background
                if (wasConnected) {
                  _showServerSwitchingMessage(fastestServer.name);

                  // Disconnect and wait
                  await provider.toggleVpn();
                  await Future.delayed(Duration(milliseconds: 800));

                  // Reconnect automatically
                  await Future.delayed(Duration(milliseconds: 500));
                  await provider.toggleVpn();
                  _showServerConnectedMessage(fastestServer.name);
                } else {
                  // Not connected, so connect automatically
                  _showServerSwitchingMessage(fastestServer.name);
                  await Future.delayed(Duration(milliseconds: 500));
                  await provider.toggleVpn();
                  _showServerConnectedMessage(fastestServer.name);
                }
              }
            },
            child: _buildQuickActionItem(
              context: context,
              icon: Icons.bolt,
              iconColor: Colors.white,
              iconBgGradient: LinearGradient(
                colors: [Color(0xFF0B5C8C), Color(0xFF28E3ED)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              title: 'Fastest Free Server',
            ),
          ),
          SizedBox(height: 10),
          GestureDetector(
            onTap: () async {
              // Check if user is premium
              if (!provider.isPremium) {
                _showPremiumRequiredDialog('Random Location');
                return;
              }

              if (provider.servers.isEmpty) return;

              // Premium users can select from all servers (free + premium)
              final allServers = provider.servers.asMap().entries.toList();

              if (allServers.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('No servers available'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }

              // Check if VPN is currently connected
              final wasConnected =
                  provider.vpnConnectionStatus ==
                  VpnStatusConnectionStatus.connected;

              // Select random server
              final randomIndex =
                  DateTime.now().millisecond % allServers.length;
              final selectedEntry = allServers[randomIndex];
              final serverIndex = selectedEntry.key;
              final randomServer = selectedEntry.value;

              // Set selected server as manually selected to show manual widget
              provider.setSelectedServerIndex(serverIndex, manually: true);
              setState(() {
                _selectedServerId = randomServer.id;
              });

              // Switch to home screen immediately
              if (widget.onServerSelected != null) {
                widget.onServerSelected!();
              }

              // Then handle connection in background
              if (wasConnected) {
                _showServerSwitchingMessage(randomServer.name);

                // Disconnect and wait
                await provider.toggleVpn();
                await Future.delayed(Duration(milliseconds: 800));

                // Reconnect automatically
                await Future.delayed(Duration(milliseconds: 500));
                await provider.toggleVpn();
                _showServerConnectedMessage(randomServer.name);
              } else {
                // Not connected, so connect automatically
                _showServerSwitchingMessage(randomServer.name);
                await Future.delayed(Duration(milliseconds: 500));
                await provider.toggleVpn();
                _showServerConnectedMessage(randomServer.name);
              }
            },
            child: _buildQuickActionItem(
              context: context,
              icon: Icons.shuffle,
              iconColor: Colors.white,
              iconBgGradient: LinearGradient(
                colors: [Color(0xFFD4AF37), Color(0xFFF4E08A)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              title: 'Random Location',
              isPremium: true, // Mark as premium feature
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Gradient iconBgGradient,
    required String title,
    bool isPremium = false, // Add premium flag
  }) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getCardColor(context),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.04,
            ),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: iconBgGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Row(
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _getTextColor(context),
                  ),
                ),
                if (isPremium) ...[
                  SizedBox(width: 6),
                  Icon(Icons.workspace_premium, color: Colors.amber, size: 16),
                ],
              ],
            ),
          ),
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              color: _getFlagBgColor(context),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline,
              color: _getSubtitleColor(context),
              size: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    final categories = ['All', 'Streaming', 'Gaming', 'Browsing'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: categories.map((category) {
          final isSelected = _selectedCategory == category;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 7),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [Color(0xFF0B5C8C), Color(0xFF28E3ED)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null,
                color: isSelected ? null : _getTabColor(context),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                category,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : _getSubtitleColor(context),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCountriesList(BuildContext context) {
    final provider = context.watch<VpnProvide>();

    // if (provider.isloading) {
    //   return Center(child: CircularProgressIndicator(color: Color(0xFF28E3ED)));
    // }

    if (provider.filterServers.isEmpty) {
      return Center(
        child: Text(
          'No servers available',
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: _getTextColor(context),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 18),
      itemCount: provider.filterServers.length,
      itemBuilder: (context, index) {
        final server = provider.filterServers[index];
        final isSelected = _selectedServerId == server.id;
        final isFavorite = provider.isFavoriteServer(server.id);
        final isPremium = server.type.toLowerCase() == 'premium';
        final userIsPremium = provider.isPremium;

        return GestureDetector(
          onTap: () async {
            // BUSINESS RULE: Free users CANNOT manually select servers
            if (!userIsPremium) {
              // Show message that free users must use Fastest Server tab
              _showFreeUserRestrictionMessage();
              return;
            }

            // Premium users can manually select any server
            if (isPremium && !userIsPremium) {
              _showPremiumRequiredMessage(server.name);
              return;
            }

            // Check if VPN is currently connected
            final wasConnected =
                provider.vpnConnectionStatus ==
                VpnStatusConnectionStatus.connected;

            setState(() {
              _selectedServerId = server.id;
            });

            final serverIndex = provider.servers.indexWhere(
              (item) => item.id == server.id,
            );

            if (serverIndex != -1) {
              // Set the selected server first
              provider.setSelectedServerIndex(serverIndex, manually: true);

              // Switch to home screen immediately
              if (widget.onServerSelected != null) {
                widget.onServerSelected!();
              }

              // Then handle connection in background
              if (wasConnected) {
                // Show switching message
                _showServerSwitchingMessage(server.name);

                // Disconnect and wait
                await provider.toggleVpn();
                await Future.delayed(Duration(milliseconds: 800));

                // Reconnect automatically
                await Future.delayed(Duration(milliseconds: 500));
                await provider.toggleVpn();
                _showServerConnectedMessage(server.name);
              } else {
                // Not connected, so connect automatically
                _showServerSwitchingMessage(server.name);
                await Future.delayed(Duration(milliseconds: 500));
                await provider.toggleVpn();
                _showServerConnectedMessage(server.name);
              }
            }
          },
          child: _buildCountryItem(
            context: context,
            flag: server.image.isNotEmpty ? server.image : '🌍',
            name: server.name,
            city: server.subServers != null && server.subServers!.isNotEmpty
                ? server.subServers![0].name
                : '',
            ping: server.pingMs > 0 && server.pingMs < 9999
                ? '${server.pingMs} ms'
                : server.pingMs == 9999
                ? 'N/A'
                : '-- ms',
            signal: server.pingMs > 0 && server.pingMs < 9999
                ? _calculateSignalBars(server.pingMs)
                : 4,
            isSelected: isSelected,
            isFavorite: isFavorite,
            isPremium: isPremium,
            onFavoriteToggle: () async {
              await provider.toggleFavoriteServer(server.id);
              if (!mounted) return;
              if (provider.isFavoriteServer(server.id)) {
                _showServerFavoritedMessage(server.name);
              } else {
                _showServerUnfavoritedMessage(server.name);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildCountryItem({
    required BuildContext context,
    required String flag,
    required String name,
    required String city,
    required String ping,
    required int signal,
    bool isSelected = false,
    bool isFavorite = false,
    bool isPremium = false,
    VoidCallback? onFavoriteToggle,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getCardColor(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? Color(0xFF28E3ED) : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.04,
            ),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          // Flag
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              // color: _getFlagBgColor(context),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: flag.startsWith('http')
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        flag,
                        fit: BoxFit.cover,
                        width: 30,
                        height: 30,
                        errorBuilder: (context, error, stackTrace) =>
                            Text('🌍', style: TextStyle(fontSize: 22)),
                      ),
                    )
                  : Text(flag, style: TextStyle(fontSize: 22)),
            ),
          ),
          SizedBox(width: 10),
          // Country Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _getTextColor(context),
                      ),
                    ),
                    if (isPremium) ...[
                      SizedBox(width: 6),
                      Icon(
                        Icons.workspace_premium,
                        color: Colors.amber,
                        size: 14,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  city,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    color: _getSubtitleColor(context),
                  ),
                ),
              ],
            ),
          ),
          // Favorite Star
          if (onFavoriteToggle != null)
            GestureDetector(
              onTap: onFavoriteToggle,
              child: Container(
                padding: EdgeInsets.all(4),
                child: Icon(
                  isFavorite ? Icons.star : Icons.star_outline,
                  color: isFavorite ? Colors.amber : _getSubtitleColor(context),
                  size: 20,
                ),
              ),
            ),
          SizedBox(width: 8),
          // Signal and Ping
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  4,
                  (index) => Container(
                    width: 2.5,
                    height: 7 + (index * 1.8),
                    margin: EdgeInsets.only(left: 1.5),
                    decoration: BoxDecoration(
                      color: index < signal
                          ? Color(0xFF00D68F)
                          : (Theme.of(context).brightness == Brightness.dark
                                ? Color(0xFF3A3A3A)
                                : Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(1.5),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3),
              Text(
                ping,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: _getSubtitleColor(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper methods for user feedback
  void _showServerSwitchingMessage(String serverName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Switching to $serverName...',
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF28E3ED),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showServerConnectedMessage(String serverName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              'Connected to $serverName',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showServerFavoritedMessage(String serverName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            const SizedBox(width: 8),
            Text(
              '$serverName added to favorites',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.amber[700],
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showServerUnfavoritedMessage(String serverName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.star_outline, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              '$serverName removed from favorites',
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[600],
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showPremiumRequiredMessage(String serverName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getCardColor(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.amber.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 40,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Premium Server',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getTextColor(context),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$serverName is only available for Premium users',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: _getSubtitleColor(context),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Get.to(() => PremiumScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Upgrade',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showFreeUserRestrictionMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getCardColor(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(0xFF0B5C8C).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xFF0B5C8C).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bolt,
                    size: 40,
                    color: Color(0xFF0B5C8C),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Use Fastest Server',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getTextColor(context),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Free users can only connect using the "Fastest Server" feature. Tap the Fastest Server button to connect automatically.',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: _getSubtitleColor(context),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Text(
                          'Got it',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Get.to(() => PremiumScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0B5C8C),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Upgrade to Premium',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPremiumRequiredDialog(String featureName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _getCardColor(context),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.amber.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.workspace_premium,
                    size: 40,
                    color: Colors.amber,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Premium Feature',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getTextColor(context),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$featureName is only available for Premium users',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: _getSubtitleColor(context),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Get.to(() => PremiumScreen());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Upgrade to Premium',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
