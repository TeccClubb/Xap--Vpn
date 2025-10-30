import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xap_vpn/Providers/VpnProvide/vpnProvide.dart';
import 'package:xap_vpn/Screens/setting/premiun.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Load user data from provider after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<VpnProvide>();
      if (provider.user.isNotEmpty) {
        _nameController.text = provider.user.first.name;
        _emailController.text = provider.user.first.email;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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

  Color _getDividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF2A2A2A)
        : Color(0xFFF0F0F0);
  }

  Color _getIconBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFF1A3A5C).withOpacity(0.3)
        : Color(0xFF0B5C8C).withOpacity(0.1);
  }

  Color _getFeatureBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 18, 30, 48)
        : Color(0xFFF8F9FA);
  }

  Color _getBackButtonColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 14, 25, 41)
        : Color(0xFFF5F5F5);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VpnProvide>(
      builder: (context, provider, child) {
        // Update text controllers when user data changes
        if (provider.user.isNotEmpty) {
          if (_nameController.text.isEmpty) {
            _nameController.text = provider.user.first.name;
          }
          if (_emailController.text.isEmpty) {
            _emailController.text = provider.user.first.email;
          }
        }

        return Scaffold(
          backgroundColor: _getBackgroundColor(context),
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20),
                // Header
                _buildHeader(context),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),

                        // Profile Section
                        _buildProfileSection(context, provider),

                        SizedBox(height: 24),

                        // Account Information
                        _buildSectionTitle('Account Information', context),
                        SizedBox(height: 12),
                        _buildAccountInformation(context, provider),

                        SizedBox(height: 24),

                        // Subscription Section
                        _buildSectionTitle('Subscription', context),
                        SizedBox(height: 12),
                        _buildSubscriptionCard(context, provider),

                        SizedBox(height: 32),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            SizedBox(width: 12),
            Text(
              'My Account',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getTextColor(context),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isEditing = !_isEditing;
                  if (!_isEditing) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Profile updated successfully!'),
                        backgroundColor: Color(0xFF00D68F),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0B5C8C), Color(0xFF28E3ED)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _isEditing ? 'Save' : 'Edit',
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
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, VpnProvide provider) {
    // Get user initials
    String initials = 'MF';
    String userName = 'MianFarhan77';
    String userEmail = 'Loading...';

    if (provider.user.isNotEmpty) {
      userName = provider.user.first.name;
      userEmail = provider.user.first.email;
      initials = userName.length >= 2
          ? userName.substring(0, 2).toUpperCase()
          : userName.substring(0, 1).toUpperCase();
    }

    return Container(
      width: double.infinity,
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
        children: [
          // Profile Picture
          Stack(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B5C8C),
                    ),
                  ),
                ),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      // Handle profile picture change
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Color(0xFF0B5C8C),
                        size: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            userName,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            userEmail,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 16),
          // Account Status Badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  provider.isPremium ? Icons.star : Icons.verified_user,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  provider.isPremium ? 'Premium Plan' : 'Free Plan',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
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

  Widget _buildAccountInformation(BuildContext context, VpnProvide provider) {
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
          _buildInfoField(
            context: context,
            icon: Icons.person_outline,
            label: 'Full Name',
            controller: _nameController,
            enabled: _isEditing,
          ),
          _buildDivider(context),
          _buildInfoField(
            context: context,
            icon: Icons.email_outlined,
            label: 'Email Address',
            controller: _emailController,
            enabled: _isEditing,
          ),
          _buildDivider(context),
          _buildInfoItem(
            context: context,
            icon: Icons.calendar_today_outlined,
            label: 'Member Since',
            value: provider.user.isNotEmpty
                ? _formatUserDate(provider.user.first.createdAt)
                : 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(BuildContext context, VpnProvide provider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subscription = provider.activeSubscription;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 18),
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
        children: [
          // Header Row
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0B5C8C), Color(0xFF28E3ED)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.card_membership,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Plan',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 11,
                        color: _getSubtitleColor(context),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      subscription?.planName ??
                          (provider.isPremium ? 'Premium Plan' : 'Free Plan'),
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _getTextColor(context),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(provider.subscriptionStatus, isDark),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _getStatusText(
                    provider.subscriptionStatus,
                    provider.isPremium,
                  ),
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getStatusTextColor(provider.subscriptionStatus),
                  ),
                ),
              ),
            ],
          ),

          // Subscription Details (Premium users only)
          if (provider.isPremium && subscription != null) ...[
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getFeatureBgColor(context),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  // Expiry Date
                  if (subscription.expiryDate != null)
                    _buildDetailRow(
                      context,
                      Icons.event_outlined,
                      'Expires On',
                      subscription.formattedExpiryDate,
                    ),

                  // Days Remaining
                  if (subscription.daysRemaining != null &&
                      subscription.daysRemaining! > 0) ...[
                    SizedBox(height: 8),
                    _buildDetailRow(
                      context,
                      Icons.schedule_outlined,
                      'Days Remaining',
                      '${subscription.daysRemaining} days',
                    ),
                  ],

                  // Start Date
                  if (subscription.startDate != null) ...[
                    SizedBox(height: 8),
                    _buildDetailRow(
                      context,
                      Icons.play_circle_outline,
                      'Started On',
                      subscription.formattedStartDate,
                    ),
                  ],

                  // Billing Cycle
                  if (subscription.billingCycle != null) ...[
                    SizedBox(height: 8),
                    _buildDetailRow(
                      context,
                      Icons.repeat_outlined,
                      'Billing Cycle',
                      _formatBillingCycle(subscription.billingCycle!),
                    ),
                  ],

                  // Amount
                  if (subscription.amount != null) ...[
                    SizedBox(height: 8),
                    _buildDetailRow(
                      context,
                      Icons.attach_money_outlined,
                      'Amount',
                      '\$${subscription.amount} ${subscription.currency ?? ""}',
                    ),
                  ],

                  // Renewal Date
                  if (subscription.renewalDate != null) ...[
                    SizedBox(height: 8),
                    _buildDetailRow(
                      context,
                      Icons.update_outlined,
                      'Next Renewal',
                      _formatDate(subscription.renewalDate!),
                    ),
                  ],

                  // Auto Renew Status
                  if (subscription.autoRenew != null) ...[
                    SizedBox(height: 8),
                    _buildDetailRow(
                      context,
                      subscription.autoRenew!
                          ? Icons.autorenew
                          : Icons.cancel_outlined,
                      'Auto Renew',
                      subscription.autoRenew! ? 'Enabled' : 'Disabled',
                    ),
                  ],

                  // Payment Method
                  if (subscription.paymentMethod != null) ...[
                    SizedBox(height: 8),
                    _buildDetailRow(
                      context,
                      Icons.payment_outlined,
                      'Payment Method',
                      _formatPaymentMethod(subscription.paymentMethod!),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // Free Plan Features
          if (!provider.isPremium) ...[
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getFeatureBgColor(context),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPlanFeature('Limited Servers', Icons.public, context),
                  Container(
                    width: 1,
                    height: 30,
                    color: _getDividerColor(context),
                  ),
                  _buildPlanFeature('Standard Speed', Icons.speed, context),
                  Container(
                    width: 1,
                    height: 30,
                    color: _getDividerColor(context),
                  ),
                  _buildPlanFeature('Ads Supported', Icons.ads_click, context),
                ],
              ),
            ),
          ],

          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to premium screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PremiumScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0B5C8C),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    provider.isPremium ? Icons.settings : Icons.upgrade,
                    size: 18,
                  ),
                  SizedBox(width: 6),
                  Text(
                    provider.isPremium
                        ? 'Manage Subscription'
                        : 'Upgrade to Premium',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Color(0xFF0B5C8C)),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              color: _getSubtitleColor(context),
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _getTextColor(context),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status, bool isDark) {
    if (status == null)
      return isDark ? Color(0xFF00D68F).withOpacity(0.2) : Color(0xFFF0F0F0);

    switch (status.toLowerCase()) {
      case 'active':
        return isDark ? Color(0xFF00D68F).withOpacity(0.2) : Color(0xFFE7F9F3);
      case 'trial':
        return isDark ? Color(0xFF28E3ED).withOpacity(0.2) : Color(0xFFE3F8FA);
      case 'expired':
        return isDark ? Color(0xFFFF6B6B).withOpacity(0.2) : Color(0xFFFFF0F0);
      case 'cancelled':
        return isDark ? Color(0xFFFFB74D).withOpacity(0.2) : Color(0xFFFFF8E1);
      default:
        return isDark ? Color(0xFF00D68F).withOpacity(0.2) : Color(0xFFF0F0F0);
    }
  }

  Color _getStatusTextColor(String? status) {
    if (status == null) return Color(0xFF00D68F);

    switch (status.toLowerCase()) {
      case 'active':
        return Color(0xFF00D68F);
      case 'trial':
        return Color(0xFF28E3ED);
      case 'expired':
        return Color(0xFFFF6B6B);
      case 'cancelled':
        return Color(0xFFFFB74D);
      default:
        return Color(0xFF00D68F);
    }
  }

  String _getStatusText(String? status, bool isPremium) {
    if (status == null) {
      return isPremium ? 'Active' : 'Free';
    }
    return status.substring(0, 1).toUpperCase() + status.substring(1);
  }

  String _formatBillingCycle(String cycle) {
    if (cycle.toLowerCase().contains('month')) return 'Monthly';
    if (cycle.toLowerCase().contains('year')) return 'Yearly';
    if (cycle.toLowerCase().contains('week')) return 'Weekly';
    return cycle.substring(0, 1).toUpperCase() + cycle.substring(1);
  }

  String _formatPaymentMethod(String method) {
    if (method.toLowerCase().contains('stripe')) return 'Credit/Debit Card';
    if (method.toLowerCase().contains('paypal')) return 'PayPal';
    if (method.toLowerCase().contains('google')) return 'Google Pay';
    if (method.toLowerCase().contains('apple')) return 'Apple Pay';
    return method.substring(0, 1).toUpperCase() + method.substring(1);
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${_monthName(date.month)} ${date.day}, ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  Widget _buildPlanFeature(String text, IconData icon, BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: _getSubtitleColor(context)),
        SizedBox(height: 4),
        Text(
          text,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 10,
            color: _getSubtitleColor(context),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoField({
    required BuildContext context,
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required bool enabled,
  }) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getIconBgColor(context),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Color(0xFF0B5C8C), size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    color: _getSubtitleColor(context),
                  ),
                ),
                SizedBox(height: 4),
                TextField(
                  controller: controller,
                  enabled: enabled,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _getTextColor(context),
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getIconBgColor(context),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Color(0xFF0B5C8C), size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 11,
                    color: _getSubtitleColor(context),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 64),
      child: Divider(height: 1, thickness: 1, color: _getDividerColor(context)),
    );
  }

  String _formatUserDate(DateTime date) {
    return '${_monthName(date.month)} ${date.day}, ${date.year}';
  }
}
