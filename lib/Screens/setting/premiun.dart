import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xap_vpn/DataModel/plansModel.dart';
import 'package:xap_vpn/Providers/VpnProvide/vpnProvide.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  @override
  void initState() {
    super.initState();
    // Load plans from backend
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VpnProvide>().getPlans();
    });
  }

  final List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.flash_on,
      'title': 'Lightning Fast Speed',
      'description': 'Ultra-fast servers worldwide',
      'color': Color(0xFFFF9500),
    },
    {
      'icon': Icons.security,
      'title': 'Military-Grade Security',
      'description': '256-bit AES encryption',
      'color': Color(0xFF0B5C8C),
    },
    {
      'icon': Icons.block,
      'title': 'Ad-Free Experience',
      'description': 'No ads, no interruptions',
      'color': Color(0xFFFF3B30),
    },
    {
      'icon': Icons.public,
      'title': '50+ Server Locations',
      'description': 'Access from anywhere',
      'color': Color(0xFF5E5CE6),
    },
  ];

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

  Color _getInfoBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 18, 30, 48)
        : Color(0xFFF8F9FA);
  }

  Color _getButtonBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 18, 30, 48)
        : Color(0xFFF5F5F5);
  }

  Color _getBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2A2A2A)
        : Color(0xFFE5E5E5);
  }

  Color _getHandleColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF3A3A3A)
        : Color(0xFFD0D0D0);
  }

  Color _getCloseButtonColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 18, 30, 48)
        : Color(0xFFF5F5F5);
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
                    child: Column(
                      children: [
                        SizedBox(height: 20),

                        // Premium Banner
                        _buildPremiumBanner(provider),

                        SizedBox(height: 24),

                        // Features Section
                        _buildFeaturesSection(context),

                        SizedBox(height: 24),

                        // Guarantee Badge
                        _buildGuaranteeBadge(context),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomButtons(context, provider),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getCardColor(context),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(Icons.close, color: _getTextColor(context), size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner(VpnProvide provider) {
    // Get the best deal plan or first plan
    final bestPlan = provider.plans.isNotEmpty
        ? provider.plans.firstWhere(
            (plan) => plan.isBestDeal,
            orElse: () => provider.plans.first,
          )
        : null;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 18),
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
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
      child: Column(
        children: [
          // Crown
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text('👑', style: TextStyle(fontSize: 40))),
          ),

          SizedBox(height: 20),

          Text(
            'Go Premium',
            style: GoogleFonts.outfit(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.1,
            ),
          ),

          SizedBox(height: 8),

          Text(
            bestPlan != null && bestPlan.trialPeriod > 0
                ? 'Start Your ${bestPlan.trialPeriod}-${bestPlan.trialInterval} Free Trial'
                : 'Unlock All Premium Features',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.95),
            ),
          ),

          SizedBox(height: 16),

          if (bestPlan != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Then \$${bestPlan.discountPrice.toStringAsFixed(2)}/${bestPlan.invoiceInterval} • Cancel anytime',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            'What You\'ll Get',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _getTextColor(context),
            ),
          ),
        ),

        SizedBox(height: 16),

        ...List.generate(_features.length, (index) {
          final feature = _features[index];
          return Container(
            margin: EdgeInsets.only(
              left: 18,
              right: 18,
              bottom: index < _features.length - 1 ? 12 : 0,
            ),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getCardColor(context),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: feature['color'].withOpacity(isDark ? 0.2 : 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    feature['icon'],
                    color: feature['color'],
                    size: 24,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature['title'],
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _getTextColor(context),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        feature['description'],
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          color: _getSubtitleColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.check_circle, color: Color(0xFF00D68F), size: 22),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildGuaranteeBadge(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFF00D68F).withOpacity(isDark ? 0.3 : 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF00D68F).withOpacity(isDark ? 0.2 : 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_user,
              color: Color(0xFF00D68F),
              size: 26,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '30-Day Money Back',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _getTextColor(context),
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Full refund, no questions asked',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    color: _getSubtitleColor(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, VpnProvide provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _getCardColor(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _startFreeTrial,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0B5C8C),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Start Free Trial',
                style: GoogleFonts.outfit(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 2),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: TextButton(
              onPressed: () => _showAllPlans(provider),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'See All Plans',
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0B5C8C),
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward, size: 18, color: Color(0xFF0B5C8C)),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  void _startFreeTrial() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _getCardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00D68F), Color(0xFF00E5A0)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 44),
              ),

              SizedBox(height: 24),

              Text(
                'Trial Started!',
                style: GoogleFonts.outfit(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: _getTextColor(context),
                ),
              ),

              SizedBox(height: 10),

              Text(
                'Enjoy 7 days of premium features',
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 15,
                  color: _getSubtitleColor(context),
                ),
              ),

              SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getInfoBgColor(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Trial Ends:', 'Oct 31, 2025'),
                    SizedBox(height: 10),
                    _buildInfoRow('Then:', '\$4.99/month'),
                  ],
                ),
              ),

              SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0B5C8C),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            color: _getSubtitleColor(context),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _getTextColor(context),
          ),
        ),
      ],
    );
  }

  void _showAllPlans(VpnProvide provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _getHandleColor(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            SizedBox(height: 20),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Choose Your Plan',
                    style: GoogleFonts.outfit(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: _getTextColor(context),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: _getCloseButtonColor(context),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: _getSubtitleColor(context),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Plans from backend
            Expanded(
              child: provider.plans.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF0B5C8C),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      itemCount: provider.plans.length,
                      itemBuilder: (context, index) {
                        return _buildPlanCard(provider.plans[index], context);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(PlanModel plan, BuildContext context) {
    final isPopular = plan.isBestDeal;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Calculate savings percentage
    String? savings;
    if (plan.originalPrice > plan.discountPrice) {
      final savingsPercent =
          ((plan.originalPrice - plan.discountPrice) / plan.originalPrice * 100)
              .round();
      savings = 'Save $savingsPercent%';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 14),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: _getCardColor(context),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isPopular ? Color(0xFF28E3ED) : _getBorderColor(context),
                width: isPopular ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plan.name,
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _getTextColor(context),
                          ),
                        ),
                        SizedBox(height: 2),
                        if (savings != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color(
                                0xFF00D68F,
                              ).withOpacity(isDark ? 0.2 : 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              savings,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF00D68F),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${plan.discountPrice.toStringAsFixed(2)}',
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0B5C8C),
                          ),
                        ),
                        Text(
                          'per ${plan.invoiceInterval}',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 12,
                            color: _getSubtitleColor(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 14),

                // Billed Info
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    color: _getInfoBgColor(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Billed every ${plan.invoicePeriod} ${plan.invoiceInterval}',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 13,
                          color: _getSubtitleColor(context),
                        ),
                      ),
                      Text(
                        '\$${(plan.discountPrice * plan.invoicePeriod).toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _getTextColor(context),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 14),

                // Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _confirmPurchase(plan);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isPopular
                          ? Color(0xFF0B5C8C)
                          : _getButtonBgColor(context),
                      foregroundColor: isPopular
                          ? Colors.white
                          : _getTextColor(context),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Select Plan',
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Popular Badge
          if (isPopular)
            Positioned(
              top: -8,
              right: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0B5C8C), Color(0xFF28E3ED)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF28E3ED).withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  'MOST POPULAR',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _confirmPurchase(PlanModel plan) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: _getCardColor(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0B5C8C), Color(0xFF28E3ED)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text('👑', style: TextStyle(fontSize: 38)),
                ),
              ),

              SizedBox(height: 24),

              Text(
                'Confirm Purchase',
                style: GoogleFonts.outfit(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _getTextColor(context),
                ),
              ),

              SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getInfoBgColor(context),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _buildInfoRow('Plan:', plan.name),
                    SizedBox(height: 10),
                    _buildInfoRow(
                      'Total:',
                      '\$${(plan.discountPrice * plan.invoicePeriod).toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _getSubtitleColor(context),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Welcome to Premium! 👑'),
                            backgroundColor: Color(0xFF00D68F),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0B5C8C),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Confirm',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
