import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'appointment_detail_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _activeTab = 0;

  // ── Data ───────────────────────────────────────────────────────────────────
  static final _upcoming = [
    _AppointmentData(
      service: 'Home Nursing',
      date: '24 May 2025',
      time: '10:00 AM',
      nurse: 'Priya Sharma',
      price: '₹739',
      status: 'Confirmed',
      statusColor: const Color(0xFF2E7D32),
      statusBg: const Color(0xFFE8F5E9),
      bookingId: 'BMJ202505240001',
      address: '12, Park Street, Bangalore,\nKarnataka - 560001',
      icon: Icons.home_outlined,
    ),
    _AppointmentData(
      service: 'Physiotherapy',
      date: '25 May 2025',
      time: '04:00 PM',
      nurse: 'Ankit Verma',
      price: '₹899',
      status: 'Confirmed',
      statusColor: const Color(0xFF2E7D32),
      statusBg: const Color(0xFFE8F5E9),
      bookingId: 'BMJ202505250002',
      address: '12, Park Street, Bangalore,\nKarnataka - 560001',
      icon: Icons.accessibility_new_outlined,
    ),
    _AppointmentData(
      service: 'Vaccination',
      date: '27 May 2025',
      time: '11:00 AM',
      nurse: 'Neha Reddy',
      price: '₹299',
      status: 'Pending',
      statusColor: const Color(0xFFE65100),
      statusBg: const Color(0xFFFFF3E0),
      bookingId: 'BMJ202505270003',
      address: '12, Park Street, Bangalore,\nKarnataka - 560001',
      icon: Icons.vaccines_outlined,
    ),
    _AppointmentData(
      service: 'Lab Test',
      date: '30 May 2025',
      time: '09:00 AM',
      nurse: 'Sample Collection',
      price: '₹399',
      status: 'Confirmed',
      statusColor: const Color(0xFF2E7D32),
      statusBg: const Color(0xFFE8F5E9),
      bookingId: 'BMJ202505300004',
      address: '12, Park Street, Bangalore,\nKarnataka - 560001',
      icon: Icons.science_outlined,
    ),
  ];

  static final _completed = [
    _AppointmentData(
      service: 'Elder Care',
      date: '10 May 2025',
      time: '09:00 AM',
      nurse: 'Sunita Joshi',
      price: '₹599',
      status: 'Completed',
      statusColor: const Color(0xFF1565C0),
      statusBg: const Color(0xFFE3F2FD),
      bookingId: 'BMJ202505100001',
      address: '12, Park Street, Bangalore,\nKarnataka - 560001',
      icon: Icons.elderly_outlined,
    ),
    _AppointmentData(
      service: 'Home Nursing',
      date: '05 May 2025',
      time: '11:00 AM',
      nurse: 'Priya Sharma',
      price: '₹739',
      status: 'Completed',
      statusColor: const Color(0xFF1565C0),
      statusBg: const Color(0xFFE3F2FD),
      bookingId: 'BMJ202505050002',
      address: '12, Park Street, Bangalore,\nKarnataka - 560001',
      icon: Icons.home_outlined,
    ),
  ];

  static final _cancelled = [
    _AppointmentData(
      service: 'Medical Assistance',
      date: '08 May 2025',
      time: '02:00 PM',
      nurse: 'Dr. Ramesh Kumar',
      price: '₹799',
      status: 'Cancelled',
      statusColor: const Color(0xFFC62828),
      statusBg: const Color(0xFFFFEBEE),
      bookingId: 'BMJ202505080001',
      address: '12, Park Street, Bangalore,\nKarnataka - 560001',
      icon: Icons.local_hospital_outlined,
    ),
  ];

  static const _tabs = ['Upcoming', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        if (!_tabController.indexIsChanging) {
          setState(() => _activeTab = _tabController.index);
        }
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_AppointmentData> get _currentList =>
      [_upcoming, _completed, _cancelled][_activeTab];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Appointments',
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepPurple)),
                  const SizedBox(height: 4),
                  Text('Track and manage your bookings',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.greyText)),
                  const SizedBox(height: 16),

                  // ── Pill Tab Bar ──────────────────────────────
                  Container(
                    height: 44,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EBF8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      onTap: (i) => setState(() => _activeTab = i),
                      indicator: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.circular(9),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.purple.withOpacity(0.30),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelPadding: EdgeInsets.zero,
                      labelStyle: GoogleFonts.poppins(
                          fontSize: 12, fontWeight: FontWeight.w600),
                      unselectedLabelStyle: GoogleFonts.poppins(
                          fontSize: 12, fontWeight: FontWeight.w500),
                      labelColor: Colors.white,
                      unselectedLabelColor: AppColors.greyText,
                      tabs: List.generate(_tabs.length, (i) {
                        final count = [
                          _upcoming.length,
                          _completed.length,
                          _cancelled.length
                        ][i];
                        return Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_tabs[i]),
                              const SizedBox(width: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: _activeTab == i
                                      ? Colors.white.withOpacity(0.25)
                                      : AppColors.purple.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$count',
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: _activeTab == i
                                        ? Colors.white
                                        : AppColors.purple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),

            // ── Tab content ────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _AppointmentList(appointments: _upcoming),
                  _AppointmentList(appointments: _completed),
                  _AppointmentList(appointments: _cancelled),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Appointment list
// ─────────────────────────────────────────────────────────────────────────────
class _AppointmentList extends StatelessWidget {
  final List<_AppointmentData> appointments;
  const _AppointmentList({required this.appointments});

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.purple.withOpacity(0.07),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.calendar_today_rounded,
                  size: 36, color: AppColors.purple.withOpacity(0.4)),
            ),
            const SizedBox(height: 16),
            Text('No appointments here',
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepPurple)),
            const SizedBox(height: 4),
            Text('Your bookings will appear here',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.greyText)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: appointments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _AppointmentCard(data: appointments[i]),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Appointment card
// ─────────────────────────────────────────────────────────────────────────────
class _AppointmentCard extends StatelessWidget {
  final _AppointmentData data;
  const _AppointmentCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AppointmentDetailScreen(
            serviceName: data.service,
            selectedDate: data.date,
            selectedTime: data.time,
            address: data.address,
            bookingId: data.bookingId,
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
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          children: [
            // ── Top row ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.purple.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(data.icon,
                        color: AppColors.purple, size: 24),
                  ),
                  const SizedBox(width: 12),

                  // Name + date/time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.service,
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepPurple)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                size: 12, color: AppColors.greyText),
                            const SizedBox(width: 4),
                            Text(data.date,
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppColors.greyText)),
                            const SizedBox(width: 8),
                            const Icon(Icons.access_time_rounded,
                                size: 12, color: AppColors.greyText),
                            const SizedBox(width: 4),
                            Text(data.time,
                                style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppColors.greyText)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: data.statusBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(data.status,
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: data.statusColor)),
                  ),
                ],
              ),
            ),

            // ── Divider ─────────────────────────────────────────
            const Divider(height: 1, indent: 14, endIndent: 14,
                color: Color(0xFFF0F0F0)),

            // ── Bottom row: nurse + price + arrow ────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Row(
                children: [
                  // Nurse avatar
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.purple.withOpacity(0.10),
                      border: Border.all(
                          color: AppColors.purple.withOpacity(0.2),
                          width: 1.5),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/nurse.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.person_rounded,
                            size: 16,
                            color: AppColors.purple),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(data.nurse,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.greyText)),
                  ),

                  // Price
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.orange.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(data.price,
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.orange)),
                  ),
                  const SizedBox(width: 8),

                  // Arrow
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColors.purple.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward_rounded,
                        color: AppColors.purple, size: 14),
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

// ─────────────────────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────────────────────
class _AppointmentData {
  final String service;
  final String date;
  final String time;
  final String nurse;
  final String price;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final String bookingId;
  final String address;
  final IconData icon;

  const _AppointmentData({
    required this.service,
    required this.date,
    required this.time,
    required this.nurse,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.bookingId,
    required this.address,
    required this.icon,
  });
}
