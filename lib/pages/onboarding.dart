import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const List<_OnboardingData> _pages = [
    _OnboardingData(
      titleNormal: 'Book Healthcare\n',
      titleColored: 'at Home',
      titleColoredIsOrange: true,
      subtitle: 'Quality care in the comfort of your home.',
      imagePath: 'assets/images/onboarding_1.png',
    ),
    _OnboardingData(
      titleNormal: 'Certified\n',
      titleColored: 'Professionals',
      titleColoredIsOrange: true,
      subtitle: 'Verified & experienced healthcare experts.',
      imagePath: 'assets/images/onboarding_2.png',
    ),
    _OnboardingData(
      titleNormal: 'Fast Booking &\n',
      titleColored: 'Secure Payments',
      titleColoredIsOrange: true,
      subtitle: 'Easy booking experience with secure payments.',
      imagePath: 'assets/images/onboarding_3.png',
    ),
  ];

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
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) => setState(() => _currentPage = index);

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
           /* Positioned.fill(
              child: Image.asset(
                'assets/images/common.png',
                fit: BoxFit.cover,
              ),
            ),*/

            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _pages.length,
              itemBuilder: (_, i) => _OnboardingPage(data: _pages[i]),
            ),

            // Skip button top-right
            Positioned(
              top: 8,
              right: 16,
              child: GestureDetector(
                onTap: _goToLogin,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    'Skip',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyText,
                    ),
                  ),
                ),
              ),
            ),

            // Bottom: dots + next/book now button
            Positioned(
              bottom: 32,
              left: 32,
              right: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 56),

                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 22 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? AppColors.purple
                              : const Color(0xFFD0D0D0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  // Arrow / Book Now
                  GestureDetector(
                    onTap: _next,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentPage == _pages.length - 1 ? 140 : 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.purple.withValues(alpha: 0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _currentPage == _pages.length - 1
                            ? Text(
                                'Book Now',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 26,
                              ),
                      ),
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

// ── Onboarding Page ───────────────────────────────────────────────────────────
class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 48),

        // Title + subtitle
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: data.titleNormal,
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepPurple,
                        height: 1.25,
                      ),
                    ),
                    TextSpan(
                      text: data.titleColored,
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: data.titleColoredIsOrange
                            ? AppColors.orange
                            : AppColors.purple,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                data.subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.greyText,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Illustration image
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                height: MediaQuery.of(context).size.height * 0.35,
                child: Image.asset(
                  data.imagePath,
                  fit: BoxFit.fill,
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(Icons.image_not_supported_outlined,
                        size: 80, color: Color(0xFFD0D0D0)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────
class _OnboardingData {
  final String titleNormal;
  final String titleColored;
  final bool titleColoredIsOrange;
  final String subtitle;
  final String imagePath;

  const _OnboardingData({
    required this.titleNormal,
    required this.titleColored,
    required this.titleColoredIsOrange,
    required this.subtitle,
    required this.imagePath,
  });
}
