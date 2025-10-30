import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xap_vpn/Providers/AuthProvide/authProvide.dart';
import 'package:xap_vpn/Screens/Auth/login.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({Key? key}) : super(key: key);

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _agreedToTerms = false;
  String _passwordStrength = '';
  Color _strengthColor = Colors.grey;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

  Color _getInputBgColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 14, 25, 41)
        : Color(0xFFF5F5F5);
  }

  Color _getBackButtonColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color.fromARGB(255, 14, 25, 41)
        : Color(0xFFF5F5F5);
  }

  Color _getIconColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Color(0xFFB0B0B0)
        : Color(0xFFB0B0B0);
  }

  void _checkPasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() {
        _passwordStrength = '';
        _strengthColor = Colors.grey;
      });
      return;
    }

    if (password.length < 4) {
      setState(() {
        _passwordStrength = 'Weak';
        _strengthColor = Colors.red;
      });
    } else if (password.length < 8) {
      setState(() {
        _passwordStrength = 'Medium';
        _strengthColor = Colors.orange;
      });
    } else {
      setState(() {
        _passwordStrength = 'Strong';
        _strengthColor = Colors.green;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),

                  // Back Button and Title
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getBackButtonColor(context),
                            borderRadius: BorderRadius.circular(12),
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
                          child: Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: Text(
                              'Create Account',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: _getTextColor(context),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/Xap VPN.png',
                      width: 80,
                      height: 80,
                    ),
                  ),

                  SizedBox(height: 18),

                  // Title
                  Center(
                    child: Text(
                      'Join XAP VPN',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getTextColor(context),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Subtitle
                  Center(
                    child: Text(
                      'Start your secure browsing journey',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: _getSubtitleColor(context),
                      ),
                    ),
                  ),

                  SizedBox(height: 40),

                  // Full Name Label
                  Text(
                    'Full Name',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _getTextColor(context),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Full Name Input
                  TextFormField(
                    controller: _nameController,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: _getTextColor(context),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your full name',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: _getSubtitleColor(context),
                      ),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: _getIconColor(context),
                        size: 20,
                      ),
                      filled: true,
                      fillColor: _getInputBgColor(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xFF0B5C8C),
                          width: 1,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),

                  // Email Label
                  Text(
                    'Email Address',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _getTextColor(context),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Email Input
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: _getTextColor(context),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: _getSubtitleColor(context),
                      ),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: _getIconColor(context),
                        size: 20,
                      ),
                      filled: true,
                      fillColor: _getInputBgColor(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xFF0B5C8C),
                          width: 1,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),

                  // Password Label
                  Text(
                    'Password',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _getTextColor(context),
                    ),
                  ),

                  SizedBox(height: 8),

                  // Password Input
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    onChanged: _checkPasswordStrength,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: _getTextColor(context),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Create a strong password',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: _getSubtitleColor(context),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: _getIconColor(context),
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: _getIconColor(context),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: _getInputBgColor(context),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Color(0xFF0B5C8C),
                          width: 1,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  // Password Strength Indicator
                  if (_passwordStrength.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 4),
                      child: Text(
                        _passwordStrength,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: _strengthColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  SizedBox(height: 20),

                  // Terms and Conditions Checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _agreedToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreedToTerms = value ?? false;
                            });
                          },
                          activeColor: Color(0xFF0B5C8C),
                          checkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: _getSubtitleColor(context),
                            ),
                            children: [
                              TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: Color(0xFF0B5C8C),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: Color(0xFF0B5C8C),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32),

                  // Create Account Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _agreedToTerms
                          ? () => _handleSignUp(context)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0B5C8C),
                        disabledBackgroundColor: Color(
                          0xFF0B5C8C,
                        ).withOpacity(0.5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Consumer<AuthProvide>(
                        builder: (context, authProvider, child) {
                          return authProvider.isloading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Create Account',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward, size: 20),
                                  ],
                                );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 24),

                  // Sign In Link
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: _getSubtitleColor(context),
                        ),
                        children: [
                          TextSpan(text: 'Already have an account? '),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Sign In',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Color(0xFF0B5C8C),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignUp(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please agree to Terms of Service and Privacy Policy',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final authProvider = Provider.of<AuthProvide>(context, listen: false);

      // Set the values from the local controllers to the provider's controllers
      authProvider.usernameController.text = _nameController.text;
      authProvider.mailController.text = _emailController.text;
      authProvider.passwordController.text = _passwordController.text;

      // Call the signup method from the provider
      await authProvider.signup(context);
    }
  }
}
