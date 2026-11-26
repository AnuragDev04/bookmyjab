import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'appointment_detail_screen.dart';
import 'appointments_screen.dart';
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
  int _currentIndex = 2;

  // Keep pages stable — do not rebuild them inside build()
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    // Index mapping: 0=Appointments, 1=Services, 2=Home, 3=Notifications, 4=Profile
    _pages = [
      const AppointmentsScreen(),
      const ServicesScreen(),
      const _HomeBody(),
      const _NotificationsScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      extendBody: true,
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        onHomeNav: () => setState(() => _currentIndex = 2),
      ),
    );
  }
}

// ── Home Body ─────────────────────────────────────────────────────────────────
class _HomeBody extends StatefulWidget {
  const _HomeBody();

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _firstName = '';

  // Master list of all searchable services
  static const _allServices = [
    _ServiceData(label: 'Home\nNursing',       subtitle: '',  price: '₹ 499', icon: Icons.home_outlined,                color: AppColors.purple),
    _ServiceData(label: 'Vaccination',         subtitle: '',  price: '₹ 299', icon: Icons.vaccines_outlined,            color: AppColors.orange),
    _ServiceData(label: 'Patient\nCare',       subtitle: '',  price: '₹ 399', icon: Icons.personal_injury_outlined,     color: AppColors.purple),
    _ServiceData(label: 'Elder\nCare',         subtitle: '',  price: '₹ 599', icon: Icons.elderly_outlined,             color: AppColors.orange),
    _ServiceData(label: 'Medical\nAssistance', subtitle: '',  price: '₹ 799', icon: Icons.medical_services_outlined,    color: AppColors.purple),
    _ServiceData(label: 'Physio-\ntherapy',   subtitle: '',  price: '₹ 699', icon: Icons.accessibility_new_outlined,   color: AppColors.orange),
    _ServiceData(label: 'Lab Test',            subtitle: '',  price: '₹ 199', icon: Icons.science_outlined,             color: AppColors.purple),
    _ServiceData(label: 'Emergency\nCare',     subtitle: '',  price: '₹ 499', icon: Icons.emergency_outlined,           color: AppColors.orange),
  ];

  List<_ServiceData> get _filteredServices {
    if (_query.isEmpty) return _allServices;
    final q = _query.toLowerCase();
    return _allServices
        .where((s) => s.label.toLowerCase().replaceAll('\n', ' ').contains(q))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_first_name') ?? '';
    if (mounted) setState(() => _firstName = name);
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
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          _TopBar(firstName: _firstName),
          const SizedBox(height: 18),
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
          if (!isSearching) ...[
            _BannerCarousel(),
            const SizedBox(height: 24),
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _QuickServicesGrid(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _PromoBanner(),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Upcoming Appointment',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepPurple,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _UpcomingAppointmentCard(),
            ),
            const SizedBox(height: 96),
          ],
        ],
      ),
    );
  }
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
            selectedDate: '24 October 2026',
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
  Timer? _autoScrollTimer;

  List<_BannerData> _banners = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBanners();
  }

  Future<void> _fetchBanners() async {
    try {
      final response = await http.get(
        Uri.parse(AppConstants.BANNER_LIST_API),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data['status'] == 'true' &&
            (data['success'] == '1' || data['success'] == 1)) {
          final List<dynamic> items = data['data'];
          final loaded = items.map((item) => _BannerData(
            id: item['id']?.toString() ?? '',
            heading: item['banner_heading']?.toString() ?? '',
            title: item['banner_title']?.toString() ?? '',
            desc: item['banner_desc']?.toString() ?? '',
            videoUrl: item['banner_vedio']?.toString() ?? '',
          )).toList();

          if (mounted) {
            setState(() {
              _banners = loaded;
              _isLoading = false;
            });
            _startAutoScroll();
          }
        } else {
          if (mounted) setState(() => _isLoading = false);
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Banner fetch error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_banners.isEmpty) return;
      final next = (_currentPage + 1) % _banners.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 160,
          decoration: BoxDecoration(
            color: AppColors.purple.withOpacity(0.07),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppColors.purple,
              strokeWidth: 2.5,
            ),
          ),
        ),
      );
    }

    if (_banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 160,
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

// ── Banner data model ─────────────────────────────────────────────────────────
class _BannerData {
  final String id;
  final String heading;
  final String title;
  final String desc;
  final String videoUrl;

  const _BannerData({
    required this.id,
    required this.heading,
    required this.title,
    required this.desc,
    required this.videoUrl,
  });
}

// ── Banner card with video player ─────────────────────────────────────────────
class _BannerCard extends StatefulWidget {
  final _BannerData data;
  const _BannerCard({required this.data});

  @override
  State<_BannerCard> createState() => _BannerCardState();
}

class _BannerCardState extends State<_BannerCard> {
  VideoPlayerController? _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.data.videoUrl.isNotEmpty) {
      _initVideo();
    }
  }

  Future<void> _initVideo() async {
    try {
      final ctrl = VideoPlayerController.networkUrl(
        Uri.parse(widget.data.videoUrl),
      );
      await ctrl.initialize();
      ctrl.setLooping(true);
      ctrl.setVolume(0);
      ctrl.play();
      if (mounted) {
        setState(() {
          _controller = ctrl;
          _initialized = true;
        });
      } else {
        ctrl.dispose();
      }
    } catch (e) {
      debugPrint('Video init error: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: AppColors.purple.withOpacity(0.12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
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
            // ── Video background ──
            if (_initialized && _controller != null)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.size.width,
                  height: _controller!.value.size.height,
                  child: VideoPlayer(_controller!),
                ),
              )
            else
              Container(
                color: AppColors.purple.withOpacity(0.15),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),

            // ── Text overlay ──
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 100, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // heading: first half purple, second half orange
                  Builder(builder: (context) {
                    final words = widget.data.heading.split(' ');
                    final mid = (words.length / 2).ceil();
                    final firstHalf = words.take(mid).join(' ');
                    final secondHalf = words.skip(mid).join(' ');
                    return RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: firstHalf,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.purple,
                              height: 1.3,
                            ),
                          ),
                          if (secondHalf.isNotEmpty)
                            TextSpan(
                              text: ' $secondHalf',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.orange,
                                height: 1.3,
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 4),
                  Text(
                    widget.data.desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: AppColors.orange,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                          color: AppColors.orange.withOpacity(0.40), width: 1),
                    ),
                    child: Text(
                      widget.data.title,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.orange.withOpacity(0.90),
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
      ],
    );
  }
}

// ── Top Bar ───────────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final String firstName;
  const _TopBar({required this.firstName});

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

                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text('Welcome,',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.greyText,
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      firstName.isNotEmpty ? firstName : 'User',
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
    _ServiceData(
      label: 'Vaccines & Care',
      subtitle: 'For all age groups at home',
      price: '₹ 299',
      icon: Icons.vaccines_outlined,
      color: AppColors.orange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (_services.isEmpty) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: (MediaQuery.of(context).size.width - 32) * 0.5,
        child: _ServiceCard(service: _services[0]),
      ),
    );
  }
}

class _ServiceData {
  final String label;
  final String subtitle;
  final String price;
  final IconData icon;
  final Color color;
  const _ServiceData({
    required this.label,
    required this.subtitle,
    required this.price,
    required this.icon,
    required this.color,
  });
}

class _ServiceCard extends StatelessWidget {
  final _ServiceData service;
  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    final s = service;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SubServicesScreen(
            label: s.label,
            description: s.subtitle,
            icon: s.icon,
            color: s.color,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: s.color.withOpacity(0.10),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon box
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: s.color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(s.icon, color: s.color, size: 26),
            ),
            const SizedBox(height: 10),

            // Title
            Text(
              s.label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.deepPurple,
              ),
            ),
            const SizedBox(height: 2),

            // Subtitle
            Text(
              s.subtitle,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: AppColors.greyText,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 12),

            // Arrow button
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: s.color.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_forward_rounded,
                    color: s.color, size: 15),
              ),
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

// ── Bottom Navigation ─────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onHomeNav;
  const _BottomNav({required this.currentIndex, required this.onTap, required this.onHomeNav});

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
              // Nav row — 2 items left, empty space for center Home, 2 items right
              Row(
                children: [
                  _NavItem(
                      icon: Icons.calendar_month_rounded,
                      label: 'Appointments',
                      selected: currentIndex == 0,
                      onTap: () => onTap(0)),
                  _NavItem(
                      icon: Icons.grid_view_rounded,
                      label: 'Services',
                      selected: currentIndex == 1,
                      onTap: () => onTap(1)),
                  // Empty space for FAB
                  const Expanded(child: SizedBox()),
                  _NavItem(
                      icon: Icons.notifications_outlined,
                      label: 'Notifications',
                      selected: currentIndex == 3,
                      onTap: () => onTap(3)),
                  _NavItem(
                      icon: Icons.person_rounded,
                      label: 'Profile',
                      selected: currentIndex == 4,
                      onTap: () => onTap(4)),
                ],
              ),
              // Floating centre Home button
              Positioned(
                top: -36,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: onHomeNav,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: const [Color(0xFFFF9A3E), AppColors.orange],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.orange.withOpacity(
                                    currentIndex == 2 ? 0.45 : 0.25),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.home_rounded,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text('Home',
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: currentIndex == 2
                                    ? AppColors.purple
                                    : const Color(0xFF757575))),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with active pill indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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

// ── Notifications Screen (placeholder) ───────────────────────────────────────
class _NotificationsScreen extends StatelessWidget {
  const _NotificationsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.deepPurple,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFF0F0F0)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_none_rounded,
                size: 64, color: AppColors.purple.withOpacity(0.35)),
            const SizedBox(height: 14),
            Text(
              'No notifications yet',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.greyText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
