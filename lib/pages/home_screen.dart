import 'dart:async';
import 'package:bookmyjab/pages/book_appointment_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'appointment_detail_screen.dart';
import 'appointments_screen.dart';
import 'nurse_detail_screen.dart';
import 'profile_screen.dart';
import 'select_address_screen.dart';
import 'service_detail_screen.dart';
import 'services_screen.dart';
import 'sub_services_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Scaffold(
        backgroundColor: const Color(0xFFF5F5FA),
        body: SafeArea(child: _HomeBody()),
        extendBody: true,
      ),
      const AppointmentsScreen(),
      const SizedBox(), // Book Now placeholder
      const ServicesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      extendBody: true,
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _currentIndex = i);
          });
        },
        onBookNow: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const BookAppointmentScreen(
              serviceName: 'Home Nursing',
              servicePrice: '₹739',
            ),
          ),
        ),
      ),
    );
  }
}

// ── Home Body ─────────────────────────────────────────────────────────────────
class _HomeBody extends StatefulWidget {
  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  // Master list of all searchable services
  static const _allServices = [
    _ServiceData('Home\nNursing',       Icons.home_outlined,                AppColors.purple),
    _ServiceData('Vaccination',         Icons.vaccines_outlined,             AppColors.orange),
    _ServiceData('Patient\nCare',       Icons.personal_injury_outlined,      AppColors.purple),
    _ServiceData('Elder\nCare',         Icons.elderly_outlined,              AppColors.orange),
    _ServiceData('Medical\nAssistance', Icons.medical_services_outlined,     AppColors.purple),
    _ServiceData('Physio-\ntherapy',    Icons.accessibility_new_outlined,    AppColors.orange),
    _ServiceData('Lab Test',            Icons.science_outlined,              AppColors.purple),
    _ServiceData('Emergency\nCare',     Icons.emergency_outlined,            AppColors.orange),
  ];

  List<_ServiceData> get _filteredServices {
    if (_query.isEmpty) return _allServices;
    final q = _query.toLowerCase();
    return _allServices
        .where((s) => s.label.toLowerCase().replaceAll('\n', ' ').contains(q))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredServices;
    final isSearching = _query.isNotEmpty;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top bar ──────────────────────────────────────────────────
          _TopBar(),
          const SizedBox(height: 18),

          // ── Search bar ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _SearchBar(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              onClear: () {
                _searchController.clear();
                setState(() => _query = '');
              },
            ),
          ),
          const SizedBox(height: 20),

          // ── Search results (shown when query is active) ──────────────
          if (isSearching) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                filtered.isEmpty
                    ? 'No services found for "$_query"'
                    : '${filtered.length} result${filtered.length == 1 ? '' : 's'} for "$_query"',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.greyText,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (filtered.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: filtered
                      .map((s) => _SearchResultTile(service: s))
                      .toList(),
                ),
              ),
            const SizedBox(height: 96),
          ],

          // ── Normal content (hidden when searching) ───────────────────
          if (!isSearching) ...[
            // ── Banner Carousel ────────────────────────────────────────
            _BannerCarousel(),
            const SizedBox(height: 24),

            // ── Quick Services ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SectionHeader(
                title: 'Quick Services',
                onViewAll: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ServicesScreen()),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _QuickServicesGrid(),
            ),
            const SizedBox(height: 20),

            // ── Promo Banner ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _PromoBanner(),
            ),
            const SizedBox(height: 24),

            // ── Nearby Nurses ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SectionHeader(title: 'Nearby Nurses', onViewAll: () {}),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _NurseCard(
                name: 'Priya Sharma',
                rating: '4.8',
                reviews: '120',
                experience: '5 Years Exp.',
                distance: '1.2 km away',
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _NurseCard(
                name: 'Anjali Verma',
                rating: '4.6',
                reviews: '98',
                experience: '3 Years Exp.',
                distance: '2.4 km away',
              ),
            ),
            const SizedBox(height: 28),

            // ── Upcoming Appointment ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Upcoming Appointment',
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepPurple)),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _UpcomingAppointmentCard(),
            ),
            const SizedBox(height: 28),

            // ── Popular Services (auto-scroll) ─────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SectionHeader(
                title: 'Popular Services',
                onViewAll: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ServicesScreen()),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: const _PopularServicesCarousel(),
            ),
            const SizedBox(height: 96),
          ],
        ],
      ),
    );
  }
}

// ── Popular Services Carousel (auto-scroll) ───────────────────────────────────
class _PopularServicesCarousel extends StatefulWidget {
  const _PopularServicesCarousel();

  @override
  State<_PopularServicesCarousel> createState() =>
      _PopularServicesCarouselState();
}

class _PopularServicesCarouselState extends State<_PopularServicesCarousel> {
  late final PageController _controller;
  late final Timer _timer;
  int _current = 0;

  static const _items = [
    _PopularService(
      title: 'Home Nursing',
      subtitle: 'Professional care at your doorstep',
      price: '₹499',
      icon: Icons.home_outlined,
      gradient: [Color(0xFF5B2D8E), Color(0xFF9C57D3)],
    ),
    _PopularService(
      title: 'Elder Care',
      subtitle: 'Compassionate care for seniors',
      price: '₹599',
      icon: Icons.elderly_outlined,
      gradient: [Color(0xFFE65100), Color(0xFFFF8A50)],
    ),
    _PopularService(
      title: 'Physiotherapy',
      subtitle: 'Rehab & pain relief at home',
      price: '₹699',
      icon: Icons.accessibility_new_outlined,
      gradient: [Color(0xFF1565C0), Color(0xFF42A5F5)],
    ),
    _PopularService(
      title: 'Lab Test',
      subtitle: 'Sample collection at your home',
      price: '₹199',
      icon: Icons.science_outlined,
      gradient: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
    ),
    _PopularService(
      title: 'Vaccination',
      subtitle: 'All age group vaccines at home',
      price: '₹299',
      icon: Icons.vaccines_outlined,
      gradient: [Color(0xFF6A1B9A), Color(0xFFBA68C8)],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.82);
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      final next = (_current + 1) % _items.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 148,
          child: PageView.builder(
            controller: _controller,
            padEnds: false,
            itemCount: _items.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) {
              final item = _items[i];
              final accent = item.gradient.first;
              final isActive = _current == i;

              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ServiceDetailScreen(
                      label: item.title,
                      description: item.subtitle,
                      icon: item.icon,
                      color: accent,
                    ),
                  ),
                ),
                child: AnimatedScale(
                  scale: isActive ? 1.0 : 0.95,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isActive
                            ? accent.withOpacity(0.35)
                            : const Color(0xFFEEEEEE),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isActive
                              ? accent.withOpacity(0.18)
                              : Colors.black.withOpacity(0.05),
                          blurRadius: isActive ? 16 : 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Soft tinted circle in top-right
                        Positioned(
                          right: -16,
                          top: -16,
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accent.withOpacity(0.07),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Icon box
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: accent.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(item.icon, color: accent, size: 26),
                              ),
                              const SizedBox(width: 14),
                              // Text content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(item.title,
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.deepPurple)),
                                    const SizedBox(height: 3),
                                    Text(item.subtitle,
                                        style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: AppColors.greyText,
                                            height: 1.4)),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: accent.withOpacity(0.10),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text('From ${item.price}',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                  color: accent)),
                                        ),
                                        const Spacer(),
                                        Container(
                                          width: 28,
                                          height: 28,
                                          decoration: BoxDecoration(
                                            color: accent.withOpacity(0.12),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                              Icons.arrow_forward_rounded,
                                              color: accent,
                                              size: 14),
                                        ),
                                      ],
                                    ),
                                  ],
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
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dot indicators — aligned with 16px page padding
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              _items.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(right: 5),
                width: _current == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _current == i
                      ? AppColors.purple
                      : AppColors.purple.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PopularService {
  final String title;
  final String subtitle;
  final String price;
  final IconData icon;
  final List<Color> gradient;
  const _PopularService({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.icon,
    required this.gradient,
  });
}

// ── Upcoming Appointment Card ─────────────────────────────────────────────────
class _UpcomingAppointmentCard extends StatelessWidget {
  const _UpcomingAppointmentCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const AppointmentDetailScreen(
            serviceName: 'Home Nursing',
            selectedDate: '24 May 2025',
            selectedTime: '10:00 AM',
            address: '12, Park Street, Bangalore,\nKarnataka - 560001',
            bookingId: 'BMJ202505240001',
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            // Top coloured strip
            Container(
              height: 5,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5B2D8E), Color(0xFF9C57D3)],
                ),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(18)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
              child: Column(
                children: [
                  // Service + status row
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.purple.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: const Icon(Icons.home_outlined,
                            color: AppColors.purple, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Home Nursing',
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepPurple)),
                            Text('Priya Sharma · Staff Nurse',
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppColors.greyText)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Confirmed',
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF2E7D32))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  const SizedBox(height: 12),

                  // Date / Time / Price row
                  Row(
                    children: [
                      _ApptInfoChip(
                          icon: Icons.calendar_today_rounded,
                          label: '24 May 2025'),
                      const SizedBox(width: 10),
                      _ApptInfoChip(
                          icon: Icons.access_time_rounded,
                          label: '10:00 AM'),
                      const Spacer(),
                      Text('₹739',
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.orange)),
                    ],
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

class _ApptInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ApptInfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.greyText),
          const SizedBox(width: 5),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.deepPurple)),
        ],
      ),
    );
  }
}

// ── Search Result Tile ────────────────────────────────────────────────────────
class _SearchResultTile extends StatelessWidget {
  final _ServiceData service;
  const _SearchResultTile({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SubServicesScreen(
            label: service.label.replaceAll('\n', ' '),
            description: '',
            icon: service.icon,
            color: service.color,
          ),
        ),
      ),
      child: Container(
        width: (MediaQuery.of(context).size.width - 44) / 2,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: service.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(service.icon, color: service.color, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                service.label.replaceAll('\n', ' '),
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.deepPurple,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Banner Carousel ───────────────────────────────────────────────────────────
class _BannerCarousel extends StatefulWidget {
  @override
  State<_BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<_BannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      final next = (_currentPage + 1) % _banners.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  static const _banners = [
    _BannerData(
      title: 'Flat 20% OFF',
      subtitle: 'On your first booking',
      code: 'Use Code: CARE20',
      icon: Icons.medical_services_outlined,
      accent: AppColors.purple,
      image: 'assets/images/demo1.png',
    ),
    _BannerData(
      title: 'Free Consultation',
      subtitle: 'Book a nurse today',
      code: 'Limited Time Offer',
      icon: Icons.health_and_safety_outlined,
      accent: AppColors.orange,
      image: 'assets/images/demo2.png',
    ),
    _BannerData(
      title: 'Elder Care Plans',
      subtitle: 'Tailored for your loved ones',
      code: 'Starting ₹499/month',
      icon: Icons.elderly_outlined,
      accent: AppColors.purple,
      image: 'assets/images/demo3.png',
    ),
  ];

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 130,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PageView.builder(
              controller: _pageController,
              itemCount: _banners.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _BannerCard(data: _banners[i]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentPage == i ? 20 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: _currentPage == i
                    ? AppColors.purple
                    : AppColors.purple.withOpacity(0.25),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BannerData {
  final String title;
  final String subtitle;
  final String code;
  final IconData icon;
  final Color accent;
  final String image;
  const _BannerData({
    required this.title,
    required this.subtitle,
    required this.code,
    required this.icon,
    required this.accent,
    required this.image,
  });
}

class _BannerCard extends StatelessWidget {
  final _BannerData data;
  const _BannerCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            Image.asset(
              data.image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: data.accent.withOpacity(0.15),
              ),
            ),
            // Dark gradient overlay for text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.55),
                    Colors.black.withOpacity(0.10),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            // Text content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 100, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data.title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    data.subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.90),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.20),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.50), width: 1),
                    ),
                    child: Text(
                      data.code,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.2,
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

// ── Section Header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;
  const _SectionHeader({required this.title, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.deepPurple)),
        GestureDetector(
          onTap: onViewAll,
          child: Text('View All',
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.purple)),
        ),
      ],
    );
  }
}

// ── Top Bar ───────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location + Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location pill
                GestureDetector(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 16, color: AppColors.purple),
                      const SizedBox(width: 3),
                      Text('Bangalore',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepPurple)),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          size: 18, color: AppColors.deepPurple),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text('Good Morning,',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.greyText,
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text('Riya Sharma',
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepPurple)),
                    const SizedBox(width: 6),
                    const Text('', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ],
            ),
          ),
          // Bell + Avatar
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Row(
                children: [
                  // Notification bell
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.notifications_outlined,
                            size: 22, color: AppColors.deepPurple),
                        // notification dot
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Avatar
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.purple, width: 2),
                      color: const Color(0xFFEDE7F6),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.person_rounded,
                            size: 24,
                            color: AppColors.purple),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Search Bar ────────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search_rounded, color: AppColors.greyText, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: GoogleFonts.poppins(
                  fontSize: 13.5,
                  color: AppColors.deepPurple,
                  fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                hintText: 'Search services...',
                hintStyle: GoogleFonts.poppins(
                    fontSize: 13.5,
                    color: AppColors.greyText,
                    fontWeight: FontWeight.w400),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          // Clear button when text is present, mic otherwise
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (_, value, __) {
              if (value.text.isNotEmpty) {
                return GestureDetector(
                  onTap: onClear,
                  child: Container(
                    margin: const EdgeInsets.only(left: 6, right: 10),
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.greyText.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.close_rounded,
                        size: 18, color: AppColors.greyText),
                  ),
                );
              }
              return Container(
                margin: const EdgeInsets.only(left: 6, right: 10),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.mic_rounded,
                    size: 19, color: AppColors.purple),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ── Quick Services Grid ───────────────────────────────────────────────────────
class _QuickServicesGrid extends StatelessWidget {
  static const _services = [
    _ServiceData('Home\nNursing',      Icons.home_outlined,                    AppColors.purple),
    _ServiceData('Vaccination',        Icons.vaccines_outlined,                AppColors.orange),
    _ServiceData('Patient\nCare',      Icons.personal_injury_outlined,         AppColors.purple),
    _ServiceData('Elder\nCare',        Icons.elderly_outlined,                 AppColors.orange),
    _ServiceData('Medical\nAssistance',Icons.medical_services_outlined,        AppColors.purple),
    _ServiceData('Physio-\ntherapy',   Icons.accessibility_new_outlined,       AppColors.orange),
    _ServiceData('Lab Test',           Icons.science_outlined,                 AppColors.purple),
    _ServiceData('Emergency\nCare',    Icons.emergency_outlined,               AppColors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    // Two rows of 5 — first row has 5, second row has 3
    // Use a Wrap for natural flow
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _services
              .take(5)
              .map((s) => _ServiceItem(service: s))
              .toList(),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ..._services.skip(5).map((s) => _ServiceItem(service: s)).toList(),
            // Empty spacers to keep alignment with 5-column grid
            const SizedBox(width: 60),
            const SizedBox(width: 60),
          ],
        ),
      ],
    );
  }
}

class _ServiceData {
  final String label;
  final IconData icon;
  final Color color;
  const _ServiceData(this.label, this.icon, this.color);
}

class _ServiceItem extends StatelessWidget {
  final _ServiceData service;
  const _ServiceItem({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SubServicesScreen(
            label: service.label.replaceAll('\n', ' '),
            description: '',
            icon: service.icon,
            color: service.color,
          ),
        ),
      ),
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: service.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(service.icon, color: service.color, size: 26),
            ),
            const SizedBox(height: 7),
            Text(
              service.label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.deepPurple,
                  height: 1.3),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Promo Banner ──────────────────────────────────────────────────────────────
class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3E1A6E), Color(0xFF6A3B9A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Decorative circles
          Positioned(
            right: 100,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            right: 60,
            bottom: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          // Nurse illustration
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18)),
              child: SizedBox(
                width: 115,
                child: Image.asset(
                  'assets/images/nurse.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Image.asset(
                    'assets/images/nurse.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.white.withOpacity(0.08),
                      child: const Icon(Icons.medical_services_rounded,
                          size: 50, color: Colors.white24),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Text content
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 130, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Flat 20% OFF',
                    style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2)),
                const SizedBox(height: 2),
                Text('On your first booking',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.45), width: 1),
                  ),
                  child: Text('Use Code: CARE20',
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.3)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Nurse Card ────────────────────────────────────────────────────────────────
class _NurseCard extends StatelessWidget {
  final String name;
  final String rating;
  final String reviews;
  final String experience;
  final String distance;

  const _NurseCard({
    required this.name,
    required this.rating,
    required this.reviews,
    required this.experience,
    required this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NurseDetailScreen(
            name: name,
            role: 'Staff Nurse',
            rating: rating,
            reviews: reviews,
            experience: experience,
            distance: distance,
          ),
        ),
      ),
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.purple.withOpacity(0.1),
              border:
                  Border.all(color: AppColors.purple.withOpacity(0.25), width: 1.5),
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/nurse.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person_rounded,
                    size: 32, color: AppColors.purple),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepPurple)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 15, color: Color(0xFFFFC107)),
                    const SizedBox(width: 3),
                    Text('$rating ($reviews)',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.greyText,
                            fontWeight: FontWeight.w400)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(experience,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.greyText,
                        fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          // Distance badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.purple.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(distance,
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.purple)),
          ),
        ],
      ),
    ),
    );
  }
}

// ── Bottom Navigation ─────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onBookNow;
  const _BottomNav({required this.currentIndex, required this.onTap, required this.onBookNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
              color: AppColors.purple.withOpacity(0.10),
              blurRadius: 24,
              offset: const Offset(0, -4))
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 70,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Nav row
              Row(
                children: [
                  _NavItem(
                      icon: Icons.home_rounded,
                      label: 'Home',
                      selected: currentIndex == 0,
                      onTap: () => onTap(0)),
                  _NavItem(
                      icon: Icons.calendar_month_rounded,
                      label: 'Appointment',
                      selected: currentIndex == 1,
                      onTap: () => onTap(1)),
                  // Empty space for FAB
                  const Expanded(child: SizedBox()),
                  _NavItem(
                      icon: Icons.grid_view_rounded,
                      label: 'Services',
                      selected: currentIndex == 3,
                      onTap: () => onTap(3)),
                  _NavItem(
                      icon: Icons.person_rounded,
                      label: 'Profile',
                      selected: currentIndex == 4,
                      onTap: () => onTap(4)),
                ],
              ),
              // Floating center FAB
              Positioned(
                top: -28,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: onBookNow,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF9A3E), AppColors.orange],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add_rounded,
                              color: Colors.white, size: 32),
                        ),
                        const SizedBox(height: 3),
                        Text('Book Now',
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.orange)),
                      ],
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
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavItem(
      {required this.icon,
      required this.label,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with active pill indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.purple.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 22,
                color: selected ? AppColors.purple : const Color(0xFF757575),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? AppColors.purple : const Color(0xFF757575)),
            ),
          ],
        ),
      ),
    );
  }
}
