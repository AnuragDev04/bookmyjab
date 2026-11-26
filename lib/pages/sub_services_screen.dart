import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/selected_service.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import 'book_appointment_screen.dart';
import 'confirm_booking_screen.dart';
import 'service_detail_screen.dart';

class SubServicesScreen extends StatefulWidget {
  final String label;
  final String description;
  final IconData icon;
  final Color color;

  const SubServicesScreen({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  State<SubServicesScreen> createState() => _SubServicesScreenState();
}

class _SubServicesScreenState extends State<SubServicesScreen> {
  // Expose widget fields via shorter refs
  String get label => widget.label;
  String get description => widget.description;
  IconData get icon => widget.icon;
  Color get color => widget.color;

  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedBadge = 'All';

  // Badges loaded from API
  List<String> _badges = ['All'];
  bool _badgesLoading = false;

  // Vaccines loaded from API
  List<_VaccineItem> _vaccines = [];
  bool _vaccinesLoading = false;
  String? _vaccinesError;

  // category_id → category_name map (built when badges load)
  final Map<int, String> _categoryMap = {};

  // Family members shared across all cards
  List<Map<String, dynamic>> _familyMembers = [];
  bool _familyLoading = false;

  // ── Lifted qty state: vaccineId → qty ──────────────────────────────────────
  final Map<int, int> _qtys = {};

  int _qtyFor(int id) => _qtys[id] ?? 0;

  void _increment(int id) => setState(() => _qtys[id] = _qtyFor(id) + 1);
  void _decrement(int id) {
    final current = _qtyFor(id);
    if (current > 0) setState(() => _qtys[id] = current - 1);
  }

  // Selected vaccines with qty > 0
  List<_VaccineItem> get _selectedVaccines =>
      _vaccines.where((v) => _qtyFor(v.vaccineId) > 0).toList();

  // Total selected count for button badge
  int get _totalSelected =>
      _qtys.values.fold(0, (sum, q) => sum + q);

  @override
  void initState() {
    super.initState();
    _fetchBadges();
    _fetchVaccines();
    _fetchFamilyMembers();
  }

  Future<void> _fetchBadges() async {
    if (!mounted) return;
    setState(() => _badgesLoading = true);
    try {
      final response = await http
          .get(Uri.parse(AppConstants.CATEGORY_LIST_API))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true) {
          final List<dynamic> data = body['data'] ?? [];
          // Build category_id → name map
          for (final item in data) {
            final id = item['category_id'] as int?;
            final name = item['category_name']?.toString() ?? '';
            if (id != null && name.isNotEmpty) {
              _categoryMap[id] = name;
            }
          }
          final fetched = data
              .where((item) =>
                  item['status']?.toString().toLowerCase() == 'active')
              .map((item) => item['category_name']?.toString() ?? '')
              .where((name) => name.isNotEmpty)
              .toList();
          if (mounted) {
            setState(() {
              _badges = ['All', ...fetched];
              _selectedBadge = 'All';
              _badgesLoading = false;
            });
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('Category fetch error: $e');
    }
    if (mounted) setState(() => _badgesLoading = false);
  }

  Future<void> _fetchVaccines() async {
    if (!mounted) return;
    setState(() {
      _vaccinesLoading = true;
      _vaccinesError = null;
    });
    try {
      final response = await http
          .get(Uri.parse(AppConstants.ALL_VACCINES_LIST_API))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['success'] == true) {
          final List<dynamic> data = body['data'] ?? [];
          final items = data
              .map((e) => _VaccineItem.fromJson(e as Map<String, dynamic>))
              .where((v) => v.title.isNotEmpty)
              .toList();
          if (mounted) {
            setState(() {
              _vaccines = items;
              _vaccinesLoading = false;
            });
          }
          return;
        }
      }
      if (mounted) {
        setState(() {
          _vaccinesLoading = false;
          _vaccinesError = 'Failed to load vaccines. Tap to retry.';
        });
      }
    } catch (e) {
      debugPrint('Vaccines fetch error: $e');
      if (mounted) {
        setState(() {
          _vaccinesLoading = false;
          _vaccinesError = 'Network error. Tap to retry.';
        });
      }
    }
  }

  Future<void> _fetchFamilyMembers() async {
    if (!mounted) return;
    setState(() => _familyLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? '';
      if (userId.isEmpty) {
        if (mounted) setState(() => _familyLoading = false);
        return;
      }
      final uri = Uri.parse(
          '${AppConstants.FETCH_FAMILY_MEMBER_API}?user_id=$userId');
      final response =
          await http.get(uri).timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        if (body['success'] == true) {
          final data = body['data'] as List<dynamic>? ?? [];
          final fetched = data.map((e) {
            final name = e['name']?.toString() ?? '';
            final gender = e['gender']?.toString() ?? '';
            final label = gender.isNotEmpty ? '$name ($gender)' : name;
            return {'label': label, 'id': e['family_member_id']};
          }).toList();
          if (mounted) {
            setState(() {
              _familyMembers = fetched;
              _familyLoading = false;
            });
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('Family members fetch error: $e');
    }
    if (mounted) setState(() => _familyLoading = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Filtered vaccines from API ─────────────────────────────────────────────
  List<_VaccineItem> get _filteredItems {
    var items = _vaccines;

    // Badge filter — match by category_id via _categoryMap
    if (_selectedBadge != 'All') {
      // Find the category_id(s) whose name matches the selected badge
      final matchingIds = _categoryMap.entries
          .where((e) =>
              e.value.toLowerCase().trim() ==
              _selectedBadge.toLowerCase().trim())
          .map((e) => e.key)
          .toSet();
      if (matchingIds.isNotEmpty) {
        items = items
            .where((v) => matchingIds.contains(v.categoryId))
            .toList();
      }
    }

    // Search filter
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      items = items
          .where((v) =>
              v.title.toLowerCase().contains(q) ||
              v.description.toLowerCase().contains(q))
          .toList();
    }

    return items;
  }

  // Hero banner subtitle per service
  static const Map<String, List<String>> _bannerText = {
    'Vaccination': [
      'Trusted vaccines, delivered by certified nurses.',
      'A full clinical catalogue — cold-chain managed, concierge-confirmed, and digitally recorded.',
    ],
    'Vaccines & Care': [
      'Trusted vaccines, delivered by certified nurses.',
      'A full clinical catalogue — cold-chain managed, concierge-confirmed, and digitally recorded.',
    ],
    'Home Nursing': ['Care at Your\nDoorstep', 'Professional nursing care from the comfort of home.'],
    'Patient Care': ['Healing at\nHome', 'Expert patient care tailored to your recovery needs.'],
    'Elder Care': ['Love &\nCompassion', 'Dedicated care for your elderly loved ones at home.'],
    'Medical Assistance': ['Doctors\nAt Home', 'Certified doctors available whenever you need them.'],
    'Physiotherapy': ['Move Better,\nFeel Better', 'Expert physiotherapy in the comfort of your home.'],
    'Lab Test': ['Tests at\nYour Home', 'NABL-certified lab tests with doorstep collection.'],
    'Emergency Care': ['Always Ready,\nAlways Safe', 'Immediate emergency care available 24/7.'],
  };

  @override
  Widget build(BuildContext context) {
    final items = _filteredItems;
    final banner = _bannerText[label] ?? [label, description];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.deepPurple, size: 20),
        ),
        title: Text(label,
            style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.deepPurple)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFF0F0F0)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

            // ── Hero Banner ────────────────────────────────────────
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Text side ──
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 18, 12, 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                banner[0],
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepPurple,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                banner[1],
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: AppColors.greyText,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ── Image side ──
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        child: Image.asset(
                          'assets/images/home_nurse.png',
                          width: 130,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (_, __, ___) => SizedBox(
                            width: 120,
                            child: Icon(icon, size: 80,
                                color: color.withOpacity(0.3)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Section title & subtitle ───────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('At-home vaccination',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepPurple)),
                  const SizedBox(height: 4),
                  Text('Choose from a wide range of services.',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.greyText,
                          height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Search bar ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5FA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFEEEEEE)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v),
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.deepPurple),
                  decoration: InputDecoration(
                    hintText: 'Search services...',
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.greyText),
                    prefixIcon: Icon(Icons.search_rounded,
                        color: color, size: 20),
                    suffixIcon: _query.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                            child: const Icon(Icons.close_rounded,
                                color: AppColors.greyText, size: 18),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Filter badges ──────────────────────────────────────
            SizedBox(
              height: 36,
              child: _badgesLoading
                  ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 4,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (_, __) => Container(
                        width: 72,
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
                          onTap: () => setState(() => _selectedBadge = badge),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: selected ? color : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected ? color : const Color(0xFFDDDDDD),
                              ),
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: color.withOpacity(0.25),
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
                                color: selected ? Colors.white : AppColors.greyText,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),

            // ── Vaccine list: loading / error / empty / grid ───────
            if (_vaccinesLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: CircularProgressIndicator(
                    color: color,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            else if (_vaccinesError != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                child: GestureDetector(
                  onTap: _fetchVaccines,
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.wifi_off_rounded,
                            size: 48, color: color.withOpacity(0.4)),
                        const SizedBox(height: 12),
                        Text(
                          _vaccinesError!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: AppColors.greyText),
                        ),
                        const SizedBox(height: 8),
                        Text('Tap to retry',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: color,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              )
            else if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 48, color: color.withOpacity(0.3)),
                      const SizedBox(height: 12),
                      Text(
                        'No services found',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: AppColors.greyText,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...List.generate((items.length / 2).ceil(), (rowIndex) {
              final left = rowIndex * 2;
              final right = left + 1;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: _SubServiceCard(
                        vaccine: items[left],
                        color: color,
                        qty: _qtyFor(items[left].vaccineId),
                        familyMembers: _familyMembers,
                        familyLoading: _familyLoading,
                        onMemberAdded: _fetchFamilyMembers,
                        onIncrement: () => _increment(items[left].vaccineId),
                        onDecrement: () => _decrement(items[left].vaccineId),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ServiceDetailScreen(
                              label: label,
                              description: items[left].description,
                              icon: icon,
                              color: color,
                            ),
                          ),
                        ),
                        onArrowTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConfirmBookingScreen(
                              serviceName: items[left].title,
                              servicePrice: '₹${items[left].currentPrice}',
                              selectedDate: '',
                              selectedTime: '',
                              address: '',
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (right < items.length)
                      Expanded(
                        child: _SubServiceCard(
                          vaccine: items[right],
                          color: color,
                          qty: _qtyFor(items[right].vaccineId),
                          familyMembers: _familyMembers,
                          familyLoading: _familyLoading,
                          onMemberAdded: _fetchFamilyMembers,
                          onIncrement: () => _increment(items[right].vaccineId),
                          onDecrement: () => _decrement(items[right].vaccineId),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ServiceDetailScreen(
                                label: label,
                                description: items[right].description,
                                icon: icon,
                                color: color,
                              ),
                            ),
                          ),
                          onArrowTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ConfirmBookingScreen(
                                serviceName: items[right].title,
                                servicePrice: '₹${items[right].currentPrice}',
                                selectedDate: '',
                                selectedTime: '',
                                address: '',
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      const Expanded(child: SizedBox()),
                  ],
                ),
              );
            }),

            // ── Administration Charge static card ──────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EDF8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Purple circle check icon
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: AppColors.deepPurple,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Administration Charge',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontSize: 12.5,
                                color: AppColors.greyText,
                                height: 1.4,
                              ),
                              children: [
                                const TextSpan(
                                    text: 'Nurse visit + administration at '),
                                TextSpan(
                                  text: '₹299',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.deepPurple,
                                  ),
                                ),
                                const TextSpan(
                                    text: ' /  vaccination x 1\nhome (mandatory)'),
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
                ],
              ),
            ),
          ),

          // ── Sticky Continue button ──────────────────────────────────
          if (_totalSelected > 0)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              child: Row(
                children: [
                  // Selected count badge
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$_totalSelected item${_totalSelected > 1 ? 's' : ''} selected',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.greyText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${_selectedVaccines.fold(0, (sum, v) => sum + v.currentPrice * _qtyFor(v.vaccineId))}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookAppointmentScreen(
                              services: _selectedVaccines
                                  .map((v) => SelectedService(
                                        title: v.title,
                                        mrp: v.currentPrice,
                                        qty: _qtyFor(v.vaccineId),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Continue',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Sub-service card (vertical layout, 2 per row) ─────────────────────────────
class _SubServiceCard extends StatefulWidget {
  final _VaccineItem vaccine;
  final Color color;
  final int qty;
  final List<Map<String, dynamic>> familyMembers;
  final bool familyLoading;
  final VoidCallback onMemberAdded;
  final VoidCallback onTap;
  final VoidCallback onArrowTap;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _SubServiceCard({
    required this.vaccine,
    required this.color,
    required this.qty,
    required this.familyMembers,
    required this.familyLoading,
    required this.onMemberAdded,
    required this.onTap,
    required this.onArrowTap,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  State<_SubServiceCard> createState() => _SubServiceCardState();
}

class _SubServiceCardState extends State<_SubServiceCard> {
  String _selected = 'Self';
  bool _open = false;

  double get _amount => widget.vaccine.currentPrice * widget.qty.toDouble();

  Widget _buildMemberRow(String label, Color color) {
    final isSelected = label == _selected;
    return GestureDetector(
      onTap: () => setState(() {
        _selected = label;
        _open = false;
      }),
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected ? color : const Color(0xFFBBBBBB),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 11)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? color : AppColors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddMemberDialog() {
    final nameCtrl = TextEditingController();
    final dobCtrl = TextEditingController();
    String? _gender;
    final color = widget.color;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setDialogState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Add a new family member',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Full name
                  _DialogField(
                    controller: nameCtrl,
                    hint: 'Full name',
                    keyboardType: TextInputType.name,
                    color: color,
                  ),
                  const SizedBox(height: 12),

                  // Date of birth
                  _DialogField(
                    controller: dobCtrl,
                    hint: 'dd-mm-yyyy',
                    keyboardType: TextInputType.datetime,
                    suffixIcon: Icons.calendar_today_outlined,
                    color: color,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: DateTime(2000),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (ctx, child) => Theme(
                          data: Theme.of(ctx).copyWith(
                            colorScheme: ColorScheme.light(primary: color),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        dobCtrl.text =
                            '${picked.day.toString().padLeft(2, '0')}-'
                            '${picked.month.toString().padLeft(2, '0')}-'
                            '${picked.year}';
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  // Gender dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFDDDDDD)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _gender,
                        isExpanded: true,
                        hint: Text('Select gender',
                            style: GoogleFonts.poppins(
                                fontSize: 13, color: AppColors.greyText)),
                        icon: Icon(Icons.keyboard_arrow_down_rounded,
                            color: color),
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: AppColors.deepPurple),
                        items: ['Male', 'Female', 'Other']
                            .map((g) => DropdownMenuItem(
                                value: g,
                                child: Text(g,
                                    style: GoogleFonts.poppins(fontSize: 13))))
                            .toList(),
                        onChanged: (v) => setDialogState(() => _gender = v),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Buttons
                  Row(
                    children: [
                      // Save member
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final name = nameCtrl.text.trim();
                            final dob = dobCtrl.text.trim();
                            if (name.isEmpty) return;

                            // Show loading on button
                            setDialogState(() {});

                            try {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              final userId =
                                  prefs.getString('user_id') ?? '';

                              final response = await http.post(
                                Uri.parse(
                                    AppConstants.ADD_FAMILY_MEMBER_API),
                                headers: {
                                  'Content-Type': 'application/json'
                                },
                                body: jsonEncode({
                                  'user_id': userId,
                                  'name': name,
                                  'dob': dob,
                                  'gender': _gender ?? '',
                                }),
                              ).timeout(const Duration(seconds: 10));

                              if (!ctx.mounted) return;

                              final body = jsonDecode(response.body)
                                  as Map<String, dynamic>;
                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                if (body['success'] == true) {
                                  final label = _gender != null &&
                                          _gender!.isNotEmpty
                                      ? '$name (${_gender!})'
                                      : name;
                                  setState(() {
                                    _selected = label;
                                    _open = false;
                                  });
                                  widget.onMemberAdded();
                                  Navigator.pop(ctx);
                                  return;
                                }
                              }
                              // Show error snackbar
                              final msg =
                                  body['message']?.toString() ??
                                      'Failed to add member.';
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text(msg,
                                      style: GoogleFonts.poppins(
                                          fontSize: 13)),
                                  backgroundColor: AppColors.red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                ),
                              );
                            } catch (e) {
                              debugPrint('Add member error: $e');
                              if (!ctx.mounted) return;
                              ScaffoldMessenger.of(ctx).showSnackBar(
                                SnackBar(
                                  content: Text('Network error: $e',
                                      style: GoogleFonts.poppins(
                                          fontSize: 13)),
                                  backgroundColor: AppColors.red,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF8C3E), Color(0xFFFF5C00)],
                              ),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Center(
                              child: Text('Save member',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Cancel
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: color, width: 1.5),
                            ),
                            child: Center(
                              child: Text('Cancel',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color;
    //final sub = widget.sub;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _open ? color.withOpacity(0.45) : const Color(0xFFEEEEEE),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card body ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon + discount badge row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.vaccines_outlined, color: color, size: 22),
                    ),
                    const Spacer(),
                    if (widget.vaccine.discount != '0' &&
                        widget.vaccine.discount.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${widget.vaccine.discount}% OFF',
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                // Title
                Text(
                  widget.vaccine.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepPurple,
                      height: 1.3),
                ),
                const SizedBox(height: 3),
                // Description
                Text(
                  widget.vaccine.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: AppColors.greyText,
                      height: 1.4),
                ),
                const SizedBox(height: 8),
                // Vaccine badges (Doctor Verified, Safe for Children…)
                if (widget.vaccine.vaccineBadges.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: widget.vaccine.vaccineBadges
                        .take(2)
                        .map((b) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.purple.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                b.trim(),
                                style: GoogleFonts.poppins(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.purple,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                const SizedBox(height: 10),
                // Price row: current + struck old + eye button
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Current price
                    Text(
                      '₹${widget.vaccine.currentPrice}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepPurple,
                      ),
                    ),
                    const SizedBox(width: 5),
                    // Old price struck through
                    if (widget.vaccine.oldPrice > widget.vaccine.currentPrice)
                      Text(
                        '₹${widget.vaccine.oldPrice}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: AppColors.greyText,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),

          // ── Family member dropdown ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Text(
                  'SELECT FAMILY MEMBERS',
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greyText,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 4),

                // Trigger row
                GestureDetector(
                  onTap: () => setState(() => _open = !_open),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft: Radius.circular(_open ? 0 : 10),
                        bottomRight: Radius.circular(_open ? 0 : 10),
                      ),
                      border: Border.all(
                        color: color.withOpacity(0.4),
                        width: 1.2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: widget.familyLoading
                              ? SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 1.5, color: color),
                                )
                              : Text(
                                  _selected,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.deepPurple,
                                  ),
                                ),
                        ),
                        Icon(
                          _open
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: color,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),

                // Dropdown list
                if (_open)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      border: Border.all(
                        color: color.withOpacity(0.4),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ...[
                          _buildMemberRow('Self', color),
                          ...widget.familyMembers.map((m) =>
                              _buildMemberRow(m['label'] as String, color)),
                        ],

                        // ── Add a family member ──────────────────────
                        const Divider(height: 1, color: Color(0xFFF0F0F0)),
                        GestureDetector(
                          onTap: () {
                            setState(() => _open = false);
                            _showAddMemberDialog();
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.add_rounded,
                                      color: color, size: 14),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Add a new\nfamily member',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // ── Quantity + Amount row ──────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1, color: Color(0xFFF0F0F0)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Quantity label + stepper
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('QUANTITY',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: AppColors.greyText,
                              letterSpacing: 0.6,
                            )),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            _QtyButton(
                              icon: Icons.remove_rounded,
                              color: color,
                              onTap: widget.onDecrement,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '${widget.qty}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepPurple,
                                ),
                              ),
                            ),
                            _QtyButton(
                              icon: Icons.add_rounded,
                              color: color,
                              onTap: widget.onIncrement,
                              outlined: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    // Amount
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('AMOUNT',
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: AppColors.greyText,
                                letterSpacing: 0.6,
                              )),
                          const SizedBox(height: 6),
                          Text(
                            '₹${(_amount).toStringAsFixed(0)}',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Dialog text field ─────────────────────────────────────────────────────────
class _DialogField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final IconData? suffixIcon;
  final Color color;
  final VoidCallback? onTap;

  const _DialogField({
    required this.controller,
    required this.hint,
    required this.keyboardType,
    required this.color,
    this.suffixIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        absorbing: onTap != null,
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.deepPurple),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.poppins(fontSize: 13, color: AppColors.greyText),
            suffixIcon: suffixIcon != null
                ? Icon(suffixIcon, size: 18, color: AppColors.greyText)
                : null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: color, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Quantity button ───────────────────────────────────────────────────────────
class _QtyButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool outlined;

  const _QtyButton({
    required this.icon,
    required this.color,
    required this.onTap,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: outlined ? Colors.transparent : color.withOpacity(0.12),
          shape: BoxShape.circle,
          border: outlined
              ? Border.all(color: color, width: 1.5)
              : null,
        ),
        child: Icon(icon, size: 15, color: color),
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────
class _VaccineItem {
  final int vaccineId;
  final String title;
  final String description;
  final int currentPrice;
  final int oldPrice;
  final String discount;
  final List<String> targetGroup;
  final List<String> vaccineBadges;
  final int categoryId;

  const _VaccineItem({
    required this.vaccineId,
    required this.title,
    required this.description,
    required this.currentPrice,
    required this.oldPrice,
    required this.discount,
    required this.targetGroup,
    required this.vaccineBadges,
    required this.categoryId,
  });

  factory _VaccineItem.fromJson(Map<String, dynamic> json) {
    return _VaccineItem(
      vaccineId: json['vaccine_id'] as int? ?? 0,
      title: json['vaccine_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      currentPrice: int.tryParse(json['current_price']?.toString() ?? '0') ?? 0,
      oldPrice: int.tryParse(json['old_price']?.toString() ?? '0') ?? 0,
      discount: json['discount']?.toString() ?? '0',
      targetGroup: (json['target_group'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      vaccineBadges: (json['vaccine_badges'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      categoryId: json['category_id'] as int? ?? 0,
    );
  }
}
