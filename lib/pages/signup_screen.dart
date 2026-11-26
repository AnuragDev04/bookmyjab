import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/shared_preferences_helper.dart';
import 'otp_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _firstNameController  = TextEditingController();
  final _lastNameController   = TextEditingController();
  final _phoneController      = TextEditingController();
  final _emailController      = TextEditingController();
  final _cityController       = TextEditingController();
  final _passwordController   = TextEditingController();
  final _confirmController    = TextEditingController();

  bool _obscurePassword       = true;
  bool _obscureConfirm        = true;
  bool _agreedToTerms         = false;
  bool _isLoading             = false;

  // Validation errors
  String? _firstNameError;
  String? _lastNameError;
  String? _phoneError;
  String? _emailError;
  String? _cityError;
  String? _passwordError;
  String? _confirmError;

  static final _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');

  bool _validate() {
    setState(() {
      _firstNameError = _firstNameController.text.trim().isEmpty
          ? 'First name is required' : null;
      _lastNameError = _lastNameController.text.trim().isEmpty
          ? 'Last name is required' : null;

      final phone = _phoneController.text.trim();
      if (phone.isEmpty) {
        _phoneError = 'Mobile number is required';
      } else if (phone.length != 10) {
        _phoneError = 'Enter a valid 10-digit number';
      } else {
        _phoneError = null;
      }

      final email = _emailController.text.trim();
      if (email.isEmpty) {
        _emailError = 'Email address is required';
      } else if (!email.contains('@')) {
        _emailError = 'Email must contain @';
      } else if (!_emailRegex.hasMatch(email)) {
        _emailError = 'Enter a valid email (e.g. user@example.com)';
      } else {
        _emailError = null;
      }

      _cityError = _cityController.text.trim().isEmpty
          ? 'City is required' : null;

      final pw = _passwordController.text;
      if (pw.isEmpty) {
        _passwordError = 'Password is required';
      } else if (pw.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
      } else {
        _passwordError = null;
      }

      final confirm = _confirmController.text;
      if (confirm.isEmpty) {
        _confirmError = 'Please confirm your password';
      } else if (confirm != pw) {
        _confirmError = 'Passwords do not match';
      } else {
        _confirmError = null;
      }
    });

    return [_firstNameError, _lastNameError, _phoneError, _emailError, _cityError, _passwordError, _confirmError]
        .every((e) => e == null);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_validate()) return;
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse(AppConstants.USER_REGISTRATION_API),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'first_name': _firstNameController.text.trim(),
          'last_name': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'city': _cityController.text.trim(),
          'role': 'customer',
          'password': _passwordController.text,
          'terms_accepted': true,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        debugPrint('Registration response: ${response.body}');

        final String? message = data['message']?.toString();
        final bool isSuccess =
            (data['status'] == 'true' || data['status'] == true) &&
                (data['success'] == '1' ||
                    data['success'] == 1 ||
                    data['success'] == true) ||
            (message != null &&
                message.toLowerCase().contains('success'));

        if (isSuccess) {
          setState(() => _isLoading = false);

          // ── Save user data to SharedPreferences ──
          final userId   = data['data']?['id']?.toString()    ??
                           data['data']?['user_id']?.toString() ??
                           data['id']?.toString() ?? '';
          final email    = _emailController.text.trim();
          final phone    = _phoneController.text.trim();
          const role     = 'customer';
          final city    = _cityController.text.trim();

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_id',    userId);
          await prefs.setString('user_email', email);
          await prefs.setString('user_phone', phone);
          await prefs.setString('city',  city);
          await prefs.setString('user_role',  role);

          // Also save via helper for consistency
          await SharedPreferencesHelper.saveLoginData(phone, {
            'user_id': userId,
            'email':   email,
            'phone':   phone,
            'city':   city,
            'role':    role,
          });

          debugPrint('Saved — user_id: $userId | email: $email | phone: $phone | role: $role');

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message ?? 'Registration successful!',
                style: GoogleFonts.poppins(fontSize: 13),
              ),
              backgroundColor: const Color(0xFF2E7D32),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 2),
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpScreen(
                contact: '+91 $phone',
                isMobile: true,
              ),
            ),
          );
        } else {
          setState(() => _isLoading = false);
          final errorMessage =
              data['message']?.toString() ?? 'Registration failed.';
          debugPrint('API Error: $errorMessage');
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Registration failed: $errorMessage',
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
        // Parse error message from body if available
        String errorMessage;
        try {
          final Map<String, dynamic> errData = jsonDecode(response.body);
          debugPrint('Error response body: ${response.body}');
          if (response.statusCode == 409) {
            errorMessage = errData['message']?.toString() ??
                'An account with this email or phone already exists.';
          } else {
            errorMessage = errData['message']?.toString() ??
                'Registration failed: HTTP ${response.statusCode}';
          }
        } catch (_) {
          errorMessage = response.statusCode == 409
              ? 'An account with this email or phone already exists.'
              : 'Registration failed: HTTP ${response.statusCode}';
        }

        setState(() => _isLoading = false);
        debugPrint('HTTP Error: ${response.statusCode}');
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: GoogleFonts.poppins(fontSize: 13),
            ),
            backgroundColor: response.statusCode == 409
                ? AppColors.orange
                : AppColors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error during registration: $e');
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
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: back + illustration ──────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFF5F5FA),
                          border: Border.all(
                              color: const Color(0xFFE8E8E8), width: 1),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 16, color: AppColors.deepPurple),
                      ),
                    ),
                    const Spacer(),
                    // Illustration top-right
                    Image.asset(
                      'assets/images/signup.png',
                      width: 130,
                      height: 120,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(
                        width: 130,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.purple.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.health_and_safety_outlined,
                            size: 60, color: AppColors.purple),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Logo + brand ───────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo3.png',
                      width: 32,
                      height: 32,
                      errorBuilder: (_, __, ___) => Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.local_hospital_rounded,
                            color: Colors.white, size: 18),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(children: [
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
                        Text(
                          'Healthcare at Your Doorstep',
                          style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: AppColors.greyText,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Heading ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Your Account',
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepPurple),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Join Bookmyjab and book trusted\nTrusted Healthcare Partner for Your Family.',
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: AppColors.secondaryText,
                          height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Form fields ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First Name
                    _FieldLabel('First Name'),
                    const SizedBox(height: 6),
                    _InputField(
                      controller: _firstNameController,
                      hint: 'Enter your first name',
                      icon: Icons.person_outline_rounded,
                      keyboardType: TextInputType.name,
                      error: _firstNameError,
                      onChanged: (_) => setState(() => _firstNameError = null),
                    ),
                    const SizedBox(height: 16),

                    // Last Name
                    _FieldLabel('Last Name'),
                    const SizedBox(height: 6),
                    _InputField(
                      controller: _lastNameController,
                      hint: 'Enter your last name',
                      icon: Icons.person_outline_rounded,
                      keyboardType: TextInputType.name,
                      error: _lastNameError,
                      onChanged: (_) => setState(() => _lastNameError = null),
                    ),
                    const SizedBox(height: 16),

                    // Mobile Number
                    _FieldLabel('Mobile Number'),
                    const SizedBox(height: 6),
                    _SignupPhoneField(
                      controller: _phoneController,
                      error: _phoneError,
                      onChanged: (_) => setState(() => _phoneError = null),
                    ),
                    const SizedBox(height: 16),

                    // Email
                    _FieldLabel('Email Address'),
                    const SizedBox(height: 6),
                    _SignupEmailField(
                      controller: _emailController,
                      error: _emailError,
                      onChanged: (_) => setState(() => _emailError = null),
                    ),
                    const SizedBox(height: 16),

                    // City
                    _FieldLabel('City'),
                    const SizedBox(height: 6),
                    _InputField(
                      controller: _cityController,
                      hint: 'Enter your city',
                      icon: Icons.location_city_outlined,
                      keyboardType: TextInputType.text,
                      error: _cityError,
                      onChanged: (_) => setState(() => _cityError = null),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    _FieldLabel('Password'),
                    const SizedBox(height: 6),
                    _PasswordField(
                      controller: _passwordController,
                      hint: 'Create a password',
                      obscure: _obscurePassword,
                      onToggle: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      error: _passwordError,
                      onChanged: (_) => setState(() => _passwordError = null),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    _FieldLabel('Confirm Password'),
                    const SizedBox(height: 6),
                    _PasswordField(
                      controller: _confirmController,
                      hint: 'Confirm your password',
                      obscure: _obscureConfirm,
                      onToggle: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                      error: _confirmError,
                      onChanged: (_) => setState(() => _confirmError = null),
                    ),
                    const SizedBox(height: 18),

                    // Privacy notice banner
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.purple.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.shield_outlined,
                              size: 22, color: AppColors.purple),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Your privacy is important to us',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.deepPurple),
                                ),
                                Text(
                                  'We never share your details with anyone.',
                                  style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: AppColors.greyText),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Terms checkbox
                    GestureDetector(
                      onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: _agreedToTerms
                                  ? AppColors.purple
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: _agreedToTerms
                                    ? AppColors.purple
                                    : const Color(0xFFBDBDBD),
                                width: 1.5,
                              ),
                            ),
                            child: _agreedToTerms
                                ? const Icon(Icons.check_rounded,
                                    size: 14, color: Colors.white)
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text: 'I agree to the ',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.greyText),
                                ),
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.purple),
                                ),
                                TextSpan(
                                  text: ' and ',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.greyText),
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
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
                    const SizedBox(height: 24),

                    // Create Account button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _agreedToTerms && !_isLoading ? _createAccount : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          disabledBackgroundColor:
                              AppColors.orange.withOpacity(0.50),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
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
                            : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Create Account',
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward_rounded,
                                color: Colors.white, size: 20),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Already have account
                    Center(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Already have an account? ',
                            style: GoogleFonts.poppins(
                                fontSize: 13, color: AppColors.greyText),
                          ),
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                'Login',
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
                    const SizedBox(height: 32),
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

// ── Field label ───────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.deepPurple),
    );
  }
}

// ── Generic input field ───────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final String? error;
  final ValueChanged<String>? onChanged;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
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
              const SizedBox(width: 14),
              Icon(icon,
                  size: 20,
                  color: hasError ? AppColors.red : AppColors.purple),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  onChanged: onChanged,
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.deepPurple),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 14, color: AppColors.greyText),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
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

// ── Signup phone field ────────────────────────────────────────────────────────
class _SignupPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  final ValueChanged<String>? onChanged;
  const _SignupPhoneField(
      {required this.controller, this.error, this.onChanged});

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
                              : const Color(0xFFE0E0E0))),
                ),
                child: Row(
                  children: [
                    Icon(Icons.phone_outlined,
                        size: 18,
                        color:
                            hasError ? AppColors.red : AppColors.purple),
                    const SizedBox(width: 6),
                    Text('+91',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.deepPurple)),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        size: 16, color: AppColors.greyText),
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

// ── Signup email field ────────────────────────────────────────────────────────
class _SignupEmailField extends StatefulWidget {
  final TextEditingController controller;
  final String? error;
  final ValueChanged<String>? onChanged;
  const _SignupEmailField(
      {required this.controller, this.error, this.onChanged});

  @override
  State<_SignupEmailField> createState() => _SignupEmailFieldState();
}

class _SignupEmailFieldState extends State<_SignupEmailField> {
  static final _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$');

  late final FocusNode _focus;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode()
      ..addListener(() => setState(() => _isFocused = _focus.hasFocus));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _emailRegex.hasMatch(widget.controller.text.trim());

  @override
  Widget build(BuildContext context) {
    final hasError = widget.error != null && widget.error!.isNotEmpty;
    final borderColor = hasError
        ? AppColors.red
        : _isFocused
            ? AppColors.purple
            : const Color(0xFFE0E0E0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _isFocused && !hasError
                ? AppColors.purple.withOpacity(0.03)
                : Colors.white,
            border: Border.all(color: borderColor, width: 1.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(Icons.mail_outline_rounded,
                  size: 20,
                  color: hasError
                      ? AppColors.red
                      : _isFocused
                          ? AppColors.purple
                          : AppColors.greyText),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (v) {
                    setState(() {}); // rebuild for live indicator
                    widget.onChanged?.call(v);
                  },
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.deepPurple),
                  decoration: InputDecoration(
                    hintText: 'Enter your email address',
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 14, color: AppColors.greyText),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              // Live validity indicator
              if (widget.controller.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    hasError || !_isValid
                        ? Icons.cancel_outlined
                        : Icons.check_circle_outline_rounded,
                    size: 18,
                    color: hasError || !_isValid
                        ? AppColors.red
                        : const Color(0xFF2E7D32),
                  ),
                ),
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          _ErrorRow(widget.error!),
        ],
      ],
    );
  }
}

// ── Phone field (kept for compatibility) ─────────────────────────────────────
class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return _SignupPhoneField(controller: controller);
  }
}

// ── Password field ────────────────────────────────────────────────────────────
class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;
  final String? error;
  final ValueChanged<String>? onChanged;

  const _PasswordField({
    required this.controller,
    required this.hint,
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
              const SizedBox(width: 14),
              Icon(Icons.lock_outline_rounded,
                  size: 20,
                  color: hasError ? AppColors.red : AppColors.purple),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  onChanged: onChanged,
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: AppColors.deepPurple),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 14, color: AppColors.greyText),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
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
