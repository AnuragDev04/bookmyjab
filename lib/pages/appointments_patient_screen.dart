import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'appointment_patient_detail_screen.dart';

class AppointmentsPatientScreen extends StatefulWidget {
  const AppointmentsPatientScreen({super.key});

  @override
  State<AppointmentsPatientScreen> createState() =>
      _AppointmentsPatientScreenState();
}

class _AppointmentsPatientScreenState extends State<AppointmentsPatientScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _activeTab = 0;

  // ── Data ───────────────────────────────────────────────────────────────────
  static final _upcoming = [
    _AppointmentData(
      patientName: 'Riya Sharma',
      service: 'Home Nursing',
      date: '24 May 2025',
      time: '10:00 AM',
      nurse: 'Priya Sharma',
      price: '₹739',
      bookingId: 'BMJ202505240001',
      address: '12, Park Street, Bangalore,\nKarnataka - 560001',
      icon: Icons.home_outlined,
    ),
    _AppointmentData(
      patientName: 'Arjun Mehta',
      service: 'Physiotherapy',
      date: '25 May 2025',
      time: '04:00 PM',
      nurse: 'Ankit Verma',
      price: '₹899',
      bookingId: 'BMJ202505250002',
      address: '12, Park Street, Bangalore,\nKarnataka - 560001',
      icon: Icons.accessibility_new_outlined,
    ),
    _AppointmentData(
      patientName: 'Sunita Joshi',
      service: 'Vaccination',
      date: '27 May 2025',
      time: '11:00 AM',
      nurse: 'Neha Reddy',
      price: '₹299',
      bookingId: 'BMJ202505270003',
      address: '12, Park Street, Bangalore,\nKarnataka - 560001',
      icon: Icons.vaccines_outlined,
    ),
    _AppointmentData(
      patientName: 'Karan Patel',
      service: 'Lab Test',
      date: '30 May 2025',
      time: '09:00 AM',
      nurse: 'Sample Collection',
      price: '₹399',
      bookingId: 'BMJ202505300004',
      address: '12, Park Street, Bangalore,\nKarnataka - 560001',
      icon: Icons.science_outlined,
    ),
  ];

  static final _completed = [
    _AppointmentData(
      patientName: 'Meena Iyer',
      service: 'Elder Care',
      date: '10 May 2025',
      time: '09:00 AM',
      nurse: 'Sunita Joshi',
      price: '₹599',
      bookingId: 'BMJ202505100001',
      address: '12, Park Street, Bangalore,\nKarnataka - 560001',
      icon: Icons.elderly_outlined,
    ),
    _AppointmentData(
      patientName: 'Riya Sharma',
      service: 'Home Nursing',
      date: '05 May 2025',
      time: '11:00 AM',
      nurse: 'Priya Sharma',
      price: '₹739',
      bookingId: 'BMJ202505050002',
      address: '12, Park Street, Bangalore,\nKarnataka - 560001',
      icon: Icons.home_outlined,
    ),
  ];

  static final _cancelled = [
    _AppointmentData(
      patientName: 'Dr. Ramesh Kumar',
      service: 'Medical Assistance',
      date: '08 May 2025',
      time: '02:00 PM',
      nurse: 'Dr. Ramesh Kumar',
      price: '₹799',
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
                  // Back + title
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.purple.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: AppColors.purple, size: 16),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Patient Appointments",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text(
                      'Manage and update visit statuses',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.greyText),
                    ),
                  ),
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
                          _cancelled.length,
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
// Appointment card (stateful for dropdown)
// ─────────────────────────────────────────────────────────────────────────────
class _AppointmentCard extends StatefulWidget {
  final _AppointmentData data;
  const _AppointmentCard({required this.data});

  @override
  State<_AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<_AppointmentCard> {
  static const _statusOptions = ['Start', 'In Progress', 'Completed'];

  String _selectedStatus = 'Start';

  Color get _statusColor {
    switch (_selectedStatus) {
      case 'In Progress':
        return const Color(0xFF1565C0);
      case 'Completed':
        return const Color(0xFF2E7D32);
      default:
        return AppColors.orange;
    }
  }

  Color get _statusBg {
    switch (_selectedStatus) {
      case 'In Progress':
        return const Color(0xFFE3F2FD);
      case 'Completed':
        return const Color(0xFFE8F5E9);
      default:
        return const Color(0xFFFFF3E0);
    }
  }

  IconData get _statusIcon {
    switch (_selectedStatus) {
      case 'In Progress':
        return Icons.timelapse_rounded;
      case 'Completed':
        return Icons.check_circle_rounded;
      default:
        return Icons.play_circle_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AppointmentPatientDetailScreen(
            patientName: d.patientName,
            serviceName: d.service,
            selectedDate: d.date,
            selectedTime: d.time,
            address: d.address,
            bookingId: d.bookingId,
            nurseName: d.nurse,
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
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // ── Top section ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service icon
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.purple.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child:
                        Icon(d.icon, color: AppColors.purple, size: 24),
                  ),
                  const SizedBox(width: 12),

                  // Patient name + service
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.patientName,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          d.service,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.greyText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Booking ID badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.purple.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '#${d.bookingId.substring(d.bookingId.length - 4)}',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.purple,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Date & Time row ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Row(
                children: [
                  // Date chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today_rounded,
                            size: 13, color: AppColors.purple),
                        const SizedBox(width: 5),
                        Text(
                          d.date,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Time chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.access_time_rounded,
                            size: 13, color: AppColors.orange),
                        const SizedBox(width: 5),
                        Text(
                          d.time,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Divider ─────────────────────────────────────────
            const Divider(
                height: 1, indent: 14, endIndent: 14,
                color: Color(0xFFF0F0F0)),

            // ── Status Dropdown + price ──────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
              child: Row(
                children: [
                  // Status dropdown
                  Expanded(
                    child: GestureDetector(
                      // prevent card tap from firing
                      onTap: () {},
                      child: Container(
                        height: 38,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: _statusBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: _statusColor.withOpacity(0.30)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedStatus,
                            isExpanded: true,
                            isDense: true,
                            icon: Icon(Icons.keyboard_arrow_down_rounded,
                                color: _statusColor, size: 18),
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _statusColor,
                            ),
                            dropdownColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            items: _statusOptions.map((s) {
                              final c = s == 'Start'
                                  ? AppColors.orange
                                  : s == 'In Progress'
                                      ? const Color(0xFF1565C0)
                                      : const Color(0xFF2E7D32);
                              final bg = s == 'Start'
                                  ? const Color(0xFFFFF3E0)
                                  : s == 'In Progress'
                                      ? const Color(0xFFE3F2FD)
                                      : const Color(0xFFE8F5E9);
                              final ic = s == 'Start'
                                  ? Icons.play_circle_outline_rounded
                                  : s == 'In Progress'
                                      ? Icons.timelapse_rounded
                                      : Icons.check_circle_rounded;
                              return DropdownMenuItem(
                                value: s,
                                child: Row(
                                  children: [
                                    Icon(ic, color: c, size: 16),
                                    const SizedBox(width: 8),
                                    Text(s,
                                        style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: c)),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (v) {
                              if (v != null) {
                                setState(() => _selectedStatus = v);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Price badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.orange.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      d.price,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.orange,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Arrow
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.purple.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward_rounded,
                        color: AppColors.purple, size: 15),
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
  final String patientName;
  final String service;
  final String date;
  final String time;
  final String nurse;
  final String price;
  final String bookingId;
  final String address;
  final IconData icon;

  const _AppointmentData({
    required this.patientName,
    required this.service,
    required this.date,
    required this.time,
    required this.nurse,
    required this.price,
    required this.bookingId,
    required this.address,
    required this.icon,
  });
}
