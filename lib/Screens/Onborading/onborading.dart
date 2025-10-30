import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:xap_vpn/Screens/Auth/login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  List<OnboardingPage> pages = [
    OnboardingPage(
      image: 'assets/1.png',
      title: 'Secure Your\nFreedom',
      description:
          'Connect to the internet without borders or limits. Your privacy is always protected with our secure servers.',
      buttonText: 'Continue',
    ),
    OnboardingPage(
      image: 'assets/2.png',
      title: 'Stay Always\nProtected',
      description:
          'Advanced encryption keeps your data safe, even on public Wi-Fi. No logs, no worries — just pure protection.',
      buttonText: 'Continue',
    ),
    OnboardingPage(
      image: 'assets/3.png',
      title: 'Connect Without\nLimits',
      description:
          'Connect to any server in seconds and stream, browse, or game with zero lag — anywhere, anytime',
      buttonText: 'Get Started',
    ),
  ];

  // Helper methods for theme colors
  Color _getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 10, 18, 30)
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

  Color _getImageBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 14, 25, 41).withOpacity(0.5)
        : Color(0xFFE8FBFA);
  }

  Color _getDotColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF3A3A3A)
        : Colors.grey.shade300;
  }

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    // Start animations
    _startAnimations();
  }

  void _startAnimations() {
    _fadeController.forward();
    _scaleController.forward();
    _slideController.forward();
  }

  void _resetAnimations() {
    _fadeController.reset();
    _scaleController.reset();
    _slideController.reset();
    _startAnimations();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _onNextPage() {
    if (_currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 1000),
        curve: Curves.easeInOut,
      );
    } else {
      // Navigate to the login screen
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(context),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  _resetAnimations();
                },
                itemBuilder: (context, index) {
                  return _buildPage(pages[index], context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Column(
                children: [
                  // Custom page indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: pages.length,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 6,
                      expansionFactor: 3,
                      activeDotColor: Color(0xFF0B5C8C),
                      dotColor: _getDotColor(context),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Image
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildAnimatedImage(page.image, context),
                ),
                SizedBox(height: 50),

                // Animated Title
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      page.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _getTextColor(context),
                        height: 1.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Animated Description
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Text(
                      page.description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: _getSubtitleColor(context),
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Animated Button
          FadeTransition(
            opacity: _fadeAnimation,
            child: _buildContinueButton(page.buttonText),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedImage(String imagePath, BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 700),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _getImageBgColor(context),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF0B5C8C).withOpacity(0.1 * value),
                blurRadius: 20 * value,
                spreadRadius: 5 * value,
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              imagePath,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  Widget _buildContinueButton(String text) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.8, end: 1.0),
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: double.infinity,
            height: 60,
            margin: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: _onNextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0B5C8C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 2,
                shadowColor: Color(0xFF0B5C8C).withOpacity(0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Class to store onboarding page data
class OnboardingPage {
  final String image;
  final String title;
  final String description;
  final String buttonText;

  OnboardingPage({
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
  });
}
