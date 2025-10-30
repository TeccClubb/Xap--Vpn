import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RateAppScreen extends StatefulWidget {
  const RateAppScreen({Key? key}) : super(key: key);

  @override
  State<RateAppScreen> createState() => _RateAppScreenState();
}

class _RateAppScreenState extends State<RateAppScreen> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
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

  Color _getInputBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 18, 30, 48)
        : Color(0xFFF8F9FA);
  }

  Color _getStarInactiveColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF3A3A3A)
        : Color(0xFFE0E0E0);
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
                  children: [
                    SizedBox(height: 20),

                    // App Icon
                    _buildAppIcon(),

                    SizedBox(height: 24),

                    // Title
                    Text(
                      'Enjoying Xap VPN?',
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: _getTextColor(context),
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      'Your feedback helps us improve',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        color: _getSubtitleColor(context),
                      ),
                    ),

                    SizedBox(height: 32),

                    // Rating Stars
                    _buildRatingStars(context),

                    SizedBox(height: 32),

                    // Review Box
                    if (_rating > 0) _buildReviewSection(context),

                    SizedBox(height: 24),

                    // Features Card
                    _buildFeaturesCard(),

                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Submit Button
            if (_rating > 0) _buildSubmitButton(context),
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
                'Rate App',
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

  Widget _buildAppIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0B5C8C), Color(0xFF28E3ED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF28E3ED).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Center(child: Icon(Icons.vpn_lock, size: 50, color: Colors.white)),
    );
  }

  Widget _buildRatingStars(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Tap to Rate',
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _getTextColor(context),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = index + 1;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 48,
                    color: index < _rating
                        ? Color(0xFFFFCC00)
                        : _getStarInactiveColor(context),
                  ),
                ),
              );
            }),
          ),
          if (_rating > 0) ...[
            SizedBox(height: 12),
            Text(
              _getRatingText(),
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _getSubtitleColor(context),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getRatingText() {
    switch (_rating) {
      case 1:
        return '😞 We\'re sorry to hear that';
      case 2:
        return '😕 We can do better';
      case 3:
        return '😊 Good! Thank you';
      case 4:
        return '😄 Great! We\'re happy';
      case 5:
        return '🤩 Awesome! You\'re the best!';
      default:
        return '';
    }
  }

  Widget _buildReviewSection(BuildContext context) {
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
          Text(
            'Share Your Experience (Optional)',
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _getTextColor(context),
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _reviewController,
            maxLines: 4,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              color: _getTextColor(context),
            ),
            decoration: InputDecoration(
              hintText: 'Tell us what you love about Xap VPN...',
              hintStyle: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                color: _getSubtitleColor(context),
              ),
              filled: true,
              fillColor: _getInputBgColor(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard() {
    final features = [
      {'icon': Icons.security, 'text': 'Secure & Private'},
      {'icon': Icons.speed, 'text': 'Fast Connection'},
      {'icon': Icons.public, 'text': '100+ Servers'},
      {'icon': Icons.support_agent, 'text': '24/7 Support'},
    ];

    return Container(
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
        children: [
          Text(
            'Why Users Love Xap VPN',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      feature['icon'] as IconData,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      feature['text'] as String,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _getCardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            if (_rating >= 4) {
              // Open App Store/Play Store
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening App Store... ⭐'),
                  backgroundColor: Color(0xFF00D68F),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            } else {
              // Submit feedback internally
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Thank you for your feedback! 💙'),
                  backgroundColor: Color(0xFF00D68F),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0B5C8C),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, size: 20),
              SizedBox(width: 8),
              Text(
                _rating >= 4 ? 'Rate on Store' : 'Submit Feedback',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
