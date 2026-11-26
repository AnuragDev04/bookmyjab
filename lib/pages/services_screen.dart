import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'service_detail_screen.dart';
import 'sub_services_screen.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  String _selectedBadge = 'All';
  List<String> _badges = ['All'];
  bool _badgesLoading = false;

  static const _allServices = [
    _ServiceItem(
      label: 'Home Nursing',
      description: 'Professional nursing care\nat your home',
      icon: Icons.home_outlined,
      color: AppColors.purple,
    ),
    _ServiceItem(
      label: 'Vaccination',
      description: 'All age group vaccines\nat home',
      icon: Icons.vaccines_outlined,
      color: AppColors.orange,
    ),
    _ServiceItem(
      label: 'Patient Care',
      description: 'Post surgery & chronic\ncare at home',
      icon: Icons.personal_injury_outlined,
      color: AppColors.purple,
    ),
    _ServiceItem(
      label: 'Elder Care',
      description: 'Compassionate care for\nyour loved ones',
      icon: Icons.elderly_outlined,
      color: AppColors.orange,
    ),
    _ServiceItem(
      label: 'Medical Assistance',
      description: 'Doctor consultation\nat home',
      icon: Icons.medical_services_outlined,
      color: AppColors.purple,
    ),
    _ServiceItem(
      label: 'Physiotherapy',
      description: 'Rehabilitation & pain\nmanagement',
      icon: Icons.accessibility_new_outlined,
      color: AppColors.orange,
    ),
    _ServiceItem(
      label: 'Lab Test',
      description: 'Sample collection\nat home',
      icon: Icons.science_outlined,
      color: AppColors.purple,
    ),
    _ServiceItem(
      label: 'Emergency Care',
      description: 'Immediate care &\nassistance',
      icon: Icons.emergency_outlined,
      color: AppColors.orange,
    ),
  ];

  List<_ServiceItem> get _filtered {
    if (_query.isEmpty) return _allServices;
    return _allServices
        .where((s) =>
            s.label.toLowerCase().contains(_query.toLowerCase()) ||
            s.description.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    _fetchBadges();
  }

  Future<void> _fetchBadges() async {
    setState(() => _badgesLoading = true);
    try {
      final response = await http
          .get(Uri.parse(AppConstants.CATEGORY_LIST_API))
          .timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['success'] == true) {
          final items = (body['data'] as List<dynamic>)
              .where((e) =>
                  e['status']?.toString().toLowerCase() == 'active')
              .map((e) => e['category_name']?.toString() ?? '')
              .where((n) => n.isNotEmpty)
              .toList();
          if (mounted) {
            setState(() {
              _badges = ['All', ...items];
              _selectedBadge = 'All';
              _badgesLoading = false;
            });
            return;
          }
        }
      }
    } catch (e) {
      debugPrint('Category fetch error: $e');
    }
    if (mounted) setState(() => _badgesLoading = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Navigator.canPop(context)
            ? GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: AppColors.deepPurple, size: 20),
              )
            : const SizedBox.shrink(),
        title: Text(
          'Vaccines & Care',
          style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.deepPurple),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFF0F0F0)),
        ),
      ),
      body: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8E8E8)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search_rounded,
                      color: AppColors.greyText, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _query = v),
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.deepPurple),
                      decoration: InputDecoration(
                        hintText: 'Search services...',
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 14, color: AppColors.greyText),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: Icon(Icons.close_rounded,
                            color: AppColors.greyText, size: 18),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Filter badges ───────────────────────────────────────
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              height: 36,
              child: _badgesLoading
                  ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 4,
                      itemBuilder: (_, __) => Container(
                        width: 72,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _badges.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, i) {
                        final badge = _badges[i];
                        final selected = _selectedBadge == badge;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedBadge = badge),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.purple
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? AppColors.purple
                                    : const Color(0xFFDDDDDD),
                              ),
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.purple
                                            .withOpacity(0.25),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Text(
                              badge,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: selected
                                    ? Colors.white
                                    : AppColors.greyText,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),

          // ── List ────────────────────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No services found',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: AppColors.greyText),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) =>
                        _ServiceCard(service: filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────
class _ServiceItem {
  final String label;
  final String description;
  final IconData icon;
  final Color color;
  const _ServiceItem({
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
  });
}

// ── Service Card ──────────────────────────────────────────────────────────────
class _ServiceCard extends StatelessWidget {
  final _ServiceItem service;
  const _ServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SubServicesScreen(
            label: service.label,
            description: service.description,
            icon: service.icon,
            color: service.color,
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: service.color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(service.icon, color: service.color, size: 26),
            ),
            const SizedBox(width: 14),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.label,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    service.description,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.greyText,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // Chevron
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: service.color.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: service.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
