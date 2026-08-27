import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isMobileSelected = true;
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

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
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _sendOtp() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
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
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Healthcare at Your Doorstep',
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: AppColors.secondaryText),
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
                          onTap: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() => _isMobileSelected = true);
                            });
                          },
                        ),
                        _TabBtn(
                          label: 'Email',
                          icon: Icons.mail_outline_rounded,
                          selected: !_isMobileSelected,
                          onTap: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() => _isMobileSelected = false);
                            });
                          },
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
                    _PhoneField(controller: _phoneController)
                  else
                    _EmailField(controller: _emailController),

                  const SizedBox(height: 30),

                  // Send OTP button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _sendOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: Text(
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
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: const Color(0xFFE0E0E0), width: 1.5),
                      ),
                      child: Row(
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
  const _PhoneField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: const BoxDecoration(
              border:
                  Border(right: BorderSide(color: Color(0xFFE0E0E0))),
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
    );
  }
}

// ── Email field ───────────────────────────────────────────────────────────────
class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: GoogleFonts.poppins(
            fontSize: 14, color: AppColors.deepPurple),
        decoration: InputDecoration(
          hintText: 'Enter email address',
          hintStyle: GoogleFonts.poppins(
              fontSize: 14, color: AppColors.greyText),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
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


