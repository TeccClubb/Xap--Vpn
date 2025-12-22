// ignore_for_file: file_names
// import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xap_vpn/Screens/setting/setting.dart';
import 'package:xap_vpn/Screens/vpnScreen/Home.dart';
import 'package:xap_vpn/Screens/vpnScreen/server.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // Current tab index
  var currentIndex = 0.obs;
  //  final isDark = Theme.of(context).brightness == Brightness.dark;

  // Method to get current page with callback
  Widget _getCurrentPage() {
    switch (currentIndex.value) {
      case 0:
        return HomeScreen(
          onChangeServerTap: () {
            // When user taps Change Server, switch to Servers screen
            setState(() {
              currentIndex.value = 1;
            });
          },
        );
      case 1:
        return ServerScreen(
          onServerSelected: () {
            // When user selects a server, switch to Home screen
            setState(() {
              currentIndex.value = 0;
            });
          },
        );
      case 2:
        return const SettingsScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      bottom: true,
      top: false,
      left: false,
      right: false,
      child: Obx(
        () => Scaffold(
          body: _getCurrentPage(),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: isDark ? Color.fromARGB(255, 10, 18, 30) : Colors.white,
            ),
            child: SafeArea(
              child: Container(
                height: 65,
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.shield, "VPN", 0),
                    _buildNavItem(Icons.public, "Countries", 1),
                    _buildNavItem(Icons.settings, "Settings", 2),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = currentIndex.value == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex.value = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Color(0xFF28E3ED) : Color(0xFFBDBDBD),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? Color(0xFF28E3ED) : Color(0xFFBDBDBD),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            // Bottom indicator line
            // Container(
            //   width: 50,
            //   height: 3,
            //   decoration: BoxDecoration(
            //     color: isSelected ? Color(0xFF1A2B49) : Colors.transparent,
            //     borderRadius: BorderRadius.circular(2),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// You can remove this if you're using a different color constant approach
class AppColors {
  static const Color primary = Colors.white;
}
