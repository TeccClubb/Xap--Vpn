import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xap_vpn/Providers/VpnProvide/vpnProvide.dart';
import 'package:xap_vpn/Screens/Onborading/welcome.dart';
import 'package:xap_vpn/Screens/bottomnavbar/bottomnavbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  // Helper methods for theme colors
  Color _getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 10, 18, 30)
        : Colors.white;
  }

  Color _getTaglineColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFFB0B0B0)
        : Color(0xff21344F);
  }

  Color _getStatusTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFFB0B0B0)
        : Colors.grey.shade600;
  }

  Color _getProgressBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2A2A2A)
        : Color(0xffE5E7EB);
  }

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _progressAnimation.addListener(() {
      setState(() {});
    });

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToNextScreen();
      }
    });

    // Start animation after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _progressController.forward();
    });
  }

  Future<void> _navigateToNextScreen() async {
    // Check if user is already logged in
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final bool isLoggedIn = token != null && token.isNotEmpty;

    // If user is logged in, preload servers and user data
    if (isLoggedIn && mounted) {
      final provider = context.read<VpnProvide>();

      // Preload all necessary data in parallel
      await Future.wait([
        provider.getServersPlease(true),
        provider.getUser(),
        provider.getPremium(),
        provider.loadFavoriteServers(),
        provider.loadSelectedServerIndex(),
      ]);

      // Load protocol and kill switch settings
      await provider.lProtocolFromStorage();
      await provider.myKillSwitch();

      // Validate that free users don't have premium servers selected
      await provider.validateAndFixSelectedServer();

      // Auto-select fastest server if no valid server is selected
      if (provider.servers.isNotEmpty &&
          (provider.selectedServerIndex == 0 ||
              provider.selectedServerIndex >= provider.servers.length)) {
        await provider.selectFastestServerByHealth();
      }

      // Ping all servers once after loading (runs in background)
      if (provider.servers.isNotEmpty) {
        provider.pingAllServers(); // Don't await - let it run in background
      }

      // Check and trigger auto-connect if enabled
      await provider.autoC(context);
    }

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    // Navigate to Home if logged in, otherwise to Welcome screen
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            isLoggedIn ? const BottomNavBar() : const WelcomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _getBackgroundColor(context),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                height: screenSize.height * 0.3,
                width: screenSize.width * 0.6,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/Xap VPN.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              SizedBox(height: 40),

              // App Title with gradient colors
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Xap ',
                      style: GoogleFonts.daysOne(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0B5C8C), // Blue color
                      ),
                    ),
                    TextSpan(
                      text: 'VPN',
                      style: GoogleFonts.daysOne(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF27E9E4), // Turquoise color
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16),

              // Tagline
              Text(
                'Secure • Private • Unlimited',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _getTaglineColor(context),
                ),
              ),

              SizedBox(height: 150),

              // Animated Progress Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    // Progress bar
                    LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: _getProgressBgColor(context),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF0B5C8C),
                      ),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    ),

                    SizedBox(height: 20),

                    // Status text
                    Text(
                      'Initializing secure connection...',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: _getStatusTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
