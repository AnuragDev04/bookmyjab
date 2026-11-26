import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/shared_preferences_helper.dart';
import 'home_nurse_screen.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isMobileSelected = true;
  final _phoneController    = TextEditingController();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailError;
  String? _phoneError;
  String? _passwordError;
  bool _isGoogleLoading  = false;
  bool _isLoading        = false;
  bool _obscurePassword  = true;
  bool _keepSignedIn     = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email', 'profile']);

  // Email regex: must have @, domain part, and a dot in domain
  static final _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');

  String? _validateEmail(String value) {
    final v = value.trim();
    if (v.isEmpty) return 'Email address is required';
    if (!v.contains('@')) return 'Email must contain @';
    if (!_emailRegex.hasMatch(v)) return 'Enter a valid email (e.g. user@example.com)';
    return null;
  }

  String? _validatePhone(String value) {
    final v = value.trim();
    if (v.isEmpty) return 'Mobile number is required';
    if (v.length != 10) return 'Enter a valid 10-digit mobile number';
    return null;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final keep = prefs.getBool('keep_signed_in') ?? false;
    if (keep) {
      final savedContact  = prefs.getString('saved_contact') ?? '';
      final savedPassword = prefs.getString('saved_password') ?? '';
      final isMobile      = prefs.getBool('saved_is_mobile') ?? true;
      setState(() {
        _keepSignedIn      = true;
        _isMobileSelected  = isMobile;
        if (isMobile) {
          _phoneController.text = savedContact;
        } else {
          _emailController.text = savedContact;
        }
        _passwordController.text = savedPassword;
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    if (_isGoogleLoading) return;
    setState(() => _isGoogleLoading = true);

    try {
      // Sign out first to always show the account chooser
      await _googleSignIn.signOut();
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (!mounted) return;

      if (account != null) {
        // Successful sign-in — navigate to HomeScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
        );
      }
      // If account == null the user cancelled — do nothing
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Google Sign-In failed. Please try again.',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _sendOtp() async {
    // Validate input fields
    bool hasError = false;

    if (_isMobileSelected) {
      final err = _validatePhone(_phoneController.text);
      setState(() => _phoneError = err);
      if (err != null) hasError = true;
    } else {
      final err = _validateEmail(_emailController.text);
      setState(() => _emailError = err);
      if (err != null) hasError = true;
    }

    if (_passwordController.text.trim().isEmpty) {
      setState(() => _passwordError = 'Password is required');
      hasError = true;
    } else {
      setState(() => _passwordError = null);
    }

    if (hasError) return;
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final emailOrPhone = _isMobileSelected
          ? _phoneController.text.trim()
          : _emailController.text.trim();

      final response = await http.post(
        Uri.parse(AppConstants.LOGIN_API),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
         'emailOrPhone': emailOrPhone,
          //'email': emailOrPhone,
          'password': _passwordController.text,
        }),
      );

      debugPrint('Login response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        debugPrint('Login full response: ${response.body}');

        final String? message = data['message']?.toString();
        final bool isSuccess =
            (data['status'] == 'true' || data['status'] == true) &&
                (data['success'] == '1' ||
                    data['success'] == 1 ||
                    data['success'] == true) ||
            (message != null &&
                message.toLowerCase().contains('success'));

        if (isSuccess) {
          // Response structure: data -> data -> user
          final userObj = data['data'] is Map
              ? (data['data'] as Map<String, dynamic>)['user'] is Map
                  ? (data['data'] as Map<String, dynamic>)['user'] as Map<String, dynamic>
                  : data['data'] as Map<String, dynamic>
              : <String, dynamic>{};

          final firstName = userObj['first_name']?.toString().trim() ?? '';
          final userId    = userObj['user_id']?.toString() ??
              userObj['id']?.toString() ?? '';
          final email     = userObj['email']?.toString() ?? emailOrPhone;
          final phone     = userObj['phone']?.toString() ??
              userObj['mobile']?.toString() ?? emailOrPhone;
          final role      = userObj['role']?.toString() ?? 'customer';
          final city      = userObj['city']?.toString().trim() ?? '';

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_id',         userId);
          await prefs.setString('user_first_name', firstName);
          await prefs.setString('user_email',      email);
          await prefs.setString('user_phone',      phone);
          await prefs.setString('user_role',       role);
          await prefs.setString('user_city',       city);

          await SharedPreferencesHelper.saveLoginData(phone, {
            'user_id':    userId,
            'first_name': firstName,
            'email':      email,
            'ph one':      phone,
            'role':       role,
            'city':       city,
          });

          debugPrint('Login saved — user_id: $userId | first_name: $firstName | email: $email | phone: $phone | role: $role');

          // Save or clear "keep me signed in" credentials
          final prefs2 = await SharedPreferences.getInstance();
          if (_keepSignedIn) {
            await prefs2.setBool('keep_signed_in',  true);
            await prefs2.setString('saved_contact',  emailOrPhone);
            await prefs2.setString('saved_password', _passwordController.text);
            await prefs2.setBool('saved_is_mobile',  _isMobileSelected);
          } else {
            await prefs2.remove('keep_signed_in');
            await prefs2.remove('saved_contact');
            await prefs2.remove('saved_password');
            await prefs2.remove('saved_is_mobile');
          }

          setState(() => _isLoading = false);
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message ?? 'Login successful!',
                style: GoogleFonts.poppins(fontSize: 13),
              ),
              backgroundColor: const Color(0xFF2E7D32),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 2),
            ),
          );

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
            (route) => false,
          );
        } else {
          setState(() => _isLoading = false);
          final errorMessage =
              data['message']?.toString() ?? 'Login failed. Please try again.';
          debugPrint('Login API error: $errorMessage');
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMessage,
                style: GoogleFonts.poppins(fontSize: 13),
              ),
              backgroundColor: AppColors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        String errorMessage;
        try {
          final Map<String, dynamic> errData = jsonDecode(response.body);
          errorMessage = errData['message']?.toString() ??
              'Login failed: HTTP ${response.statusCode}';
        } catch (_) {
          errorMessage = 'Login failed: HTTP ${response.statusCode}';
        }

        setState(() => _isLoading = false);
        debugPrint('Login HTTP error: ${response.statusCode}');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            backgroundColor: AppColors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Login error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
          // ── Hero image ──────────────────────────────────────────────
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/images/login_background.png',
                  fit: BoxFit.fitWidth,
                  errorBuilder: (_, __, ___) => Container(
                    height: size.height * 0.28,
                    color: const Color(0xFFEDE7F6),
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo3.png',
                          width: 30,
                          height: 30,
                          errorBuilder: (_, __, ___) => Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.orange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.local_hospital_rounded,
                                color: Colors.white, size: 16),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: 'Book',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.deepPurple),
                                ),
                                TextSpan(
                                  text: 'my',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.orange),
                                ),
                                TextSpan(
                                  text: 'jab',
                                  style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.deepPurple),
                                ),
                              ]),
                            ),
                            /*Text(
                              'Uncompromising Care. Seamlessly Yours.',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: AppColors.orange.withValues(alpha: 0.80),
                                letterSpacing: 0.2,
                              ),
                            ),*/
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Form area ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  // Welcome text
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Welcome to ',
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Bookmy',
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepPurple),
                        ),
                        TextSpan(
                          text: 'jab',
                          style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.orange),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Center(
                    child: Text(
                      'Login with your Mobile Number / Email to continue',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.secondaryText,
                          height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Toggle tabs
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        _TabBtn(
                          label: 'Mobile Number',
                          icon: Icons.phone_outlined,
                          selected: _isMobileSelected,
                          onTap: () => setState(() => _isMobileSelected = true),
                        ),
                        _TabBtn(
                          label: 'Email',
                          icon: Icons.mail_outline_rounded,
                          selected: !_isMobileSelected,
                          onTap: () => setState(() => _isMobileSelected = false),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Label
                  Text(
                    _isMobileSelected ? 'Mobile Number' : 'Email Address',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.deepPurple),
                  ),
                  const SizedBox(height: 8),

                  // Input
                  if (_isMobileSelected)
                    _PhoneField(
                      controller: _phoneController,
                      error: _phoneError,
                      onChanged: (_) => setState(() => _phoneError = null),
                    )
                  else
                    _EmailField(
                      controller: _emailController,
                      error: _emailError,
                      onChanged: (_) => setState(() => _emailError = null),
                    ),

                  const SizedBox(height: 16),

                  // Password label
                  Text(
                    'Password',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.deepPurple),
                  ),
                  const SizedBox(height: 8),

                  // Password field
                  _LoginPasswordField(
                    controller: _passwordController,
                    obscure: _obscurePassword,
                    error: _passwordError,
                    onToggle: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    onChanged: (_) => setState(() => _passwordError = null),
                  ),

                  const SizedBox(height: 14),

                  // Keep me signed in checkbox
                  GestureDetector(
                    onTap: () => setState(() => _keepSignedIn = !_keepSignedIn),
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: _keepSignedIn
                                ? AppColors.purple
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: _keepSignedIn
                                  ? AppColors.purple
                                  : const Color(0xFFBDBDBD),
                              width: 1.5,
                            ),
                          ),
                          child: _keepSignedIn
                              ? const Icon(Icons.check_rounded,
                                  size: 14, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Keep me signed in',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.deepPurple,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _sendOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        disabledBackgroundColor:
                            AppColors.orange.withOpacity(0.60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Text(
                              'Login',
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // New user sign up
                  Center(
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'New user? ',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.greyText,
                              fontWeight: FontWeight.w400),
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignupScreen()),
                            ),
                            child: Text(
                              'Sign Up',
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.purple),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // OR divider
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Color(0xFFE0E0E0), thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('OR',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.greyText)),
                      ),
                      const Expanded(child: Divider(color: Color(0xFFE0E0E0), thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Continue with Google
                  // Continue with Google
                  GestureDetector(
                    onTap: _isGoogleLoading ? null : _signInWithGoogle,
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFFE0E0E0), width: 1.5),
                      ),
                      child: _isGoogleLoading
                          ? const Center(
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.purple,
                                ),
                              ),
                            )
                          : Row(
                        children: [
                          const SizedBox(width: 16),
                          // Google icon from assets
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Image.asset(
                              'assets/images/google.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            'Continue with Google',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.deepPurple),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Trust badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _TrustBadge(svgPath: 'assets/images/shield_lock.svg', label: 'Secure\n& Safe'),
                      _TrustBadge(svgPath: 'assets/images/verified.svg', label: 'Verified\nProfessionals'),
                      _TrustBadge(svgPath: 'assets/images/bolt.svg', label: 'Quick\nBooking'),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Privacy policy
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'By continuing, you agree to our\n',
                          style: GoogleFonts.poppins(
                              fontSize: 12, color: AppColors.secondaryText),
                        ),
                        TextSpan(
                          text: 'Privacy Policy & Terms of Service',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.purple),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ── Tab button ────────────────────────────────────────────────────────────────
class _TabBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _TabBtn(
      {required this.label,
      required this.icon,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.purple : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16,
                  color: selected ? Colors.white : AppColors.greyText),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: selected ? Colors.white : AppColors.greyText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Phone field ───────────────────────────────────────────────────────────────
class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  final ValueChanged<String>? onChanged;
  const _PhoneField({required this.controller, this.error, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: hasError ? AppColors.red : const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(
                          color: hasError
                              ? AppColors.red.withOpacity(0.4)
                              : const Color(0xFFE0E0E0))),
                ),
                child: Row(
                  children: [
                    Text('+91',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.deepPurple)),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 18, color: AppColors.greyText),
                  ],
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  onChanged: onChanged,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.deepPurple),
                  decoration: InputDecoration(
                    hintText: 'Enter mobile number',
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 14, color: AppColors.greyText),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          _ErrorRow(error!),
        ],
      ],
    );
  }
}

// ── Email field ───────────────────────────────────────────────────────────────
class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  final ValueChanged<String>? onChanged;
  const _EmailField({required this.controller, this.error, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: hasError ? AppColors.red : const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // ── Left icon section (mirrors the +91 prefix box) ──
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                        color: hasError
                            ? AppColors.red.withOpacity(0.4)
                            : const Color(0xFFE0E0E0)),
                  ),
                ),
                child: Icon(
                  Icons.mail_outline_rounded,
                  size: 20,
                  color: hasError ? AppColors.red : AppColors.greyText,
                ),
              ),
              // ── Text input ──
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: onChanged,
                  cursorColor: AppColors.deepPurple,
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.deepPurple),
                  decoration: InputDecoration(
                    hintText: 'Enter email address',
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 14, color: AppColors.greyText),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          _ErrorRow(error!),
        ],
      ],
    );
  }
}

// ── Error row ─────────────────────────────────────────────────────────────────
class _ErrorRow extends StatelessWidget {
  final String message;
  const _ErrorRow(this.message);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.error_outline_rounded,
            size: 13, color: AppColors.red),
        const SizedBox(width: 4),
        Expanded(
          child: Text(message,
              style: GoogleFonts.poppins(
                  fontSize: 11, color: AppColors.red)),
        ),
      ],
    );
  }
}

// ── Login Password field ──────────────────────────────────────────────────────
class _LoginPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final String? error;
  final VoidCallback onToggle;
  final ValueChanged<String>? onChanged;

  const _LoginPasswordField({
    required this.controller,
    required this.obscure,
    required this.onToggle,
    this.error,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = error != null && error!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: hasError ? AppColors.red : const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                        color: hasError
                            ? AppColors.red.withOpacity(0.4)
                            : const Color(0xFFE0E0E0)),
                  ),
                ),
                child: Icon(Icons.lock_outline_rounded,
                    size: 20,
                    color: hasError ? AppColors.red : AppColors.greyText),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  onChanged: onChanged,
                  cursorColor: AppColors.deepPurple,
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.deepPurple),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 14, color: AppColors.greyText),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onToggle,
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Icon(
                    obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20,
                    color: AppColors.greyText,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          _ErrorRow(error!),
        ],
      ],
    );
  }
}

// ── Trust badge ───────────────────────────────────────────────────────────────
class _TrustBadge extends StatelessWidget {
  final String svgPath;
  final String label;
  const _TrustBadge({required this.svgPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          svgPath,
          width: 36,
          height: 36,
          colorFilter: const ColorFilter.mode(AppColors.purple, BlendMode.srcIn),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
              fontSize: 11, color: AppColors.greyText, height: 1.4,  fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}


