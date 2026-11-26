import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'appointments_patient_screen.dart';
import 'login_screen.dart';

class HomeNurseScreen extends StatefulWidget {
  const HomeNurseScreen({super.key});

  @override
  State<HomeNurseScreen> createState() => _HomeNurseScreenState();
}

class _HomeNurseScreenState extends State<HomeNurseScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  // ── Data ───────────────────────────────────────────────────────────────────
  static final _patients = [
    _PatientData(
      name: 'Riya Sharma',
      service: 'Home Nursing',
      time: '10:00 AM',
      address: '12, Park Street, Bangalore',
      status: 'Confirmed',
      statusColor: const Color(0xFF2E7D32),
      statusBg: const Color(0xFFE8F5E9),
      bookingId: 'BMJ202609020001',
      icon: Icons.home_outlined,
      price: '₹739',
      isCompleted: true,
    ),
    _PatientData(
      name: 'Arjun Mehta',
      service: 'Vaccination',
      time: '11:30 AM',
      address: '45, MG Road, Bangalore',
      status: 'In Progress',
      statusColor: const Color(0xFF1565C0),
      statusBg: const Color(0xFFE3F2FD),
      bookingId: 'BMJ202609020002',
      icon: Icons.vaccines_outlined,
      price: '₹299',
      isCompleted: false,
    ),
    _PatientData(
      name: 'Sunita Joshi',
      service: 'Elder Care',
      time: '02:00 PM',
      address: '8, Koramangala, Bangalore',
      status: 'Pending',
      statusColor: const Color(0xFFE65100),
      statusBg: const Color(0xFFFFF3E0),
      bookingId: 'BMJ202609020003',
      icon: Icons.elderly_outlined,
      price: '₹599',
      isCompleted: false,
    ),
    _PatientData(
      name: 'Karan Patel',
      service: 'Physiotherapy',
      time: '04:00 PM',
      address: '22, Indiranagar, Bangalore',
      status: 'Pending',
      statusColor: const Color(0xFFE65100),
      statusBg: const Color(0xFFFFF3E0),
      bookingId: 'BMJ202609020004',
      icon: Icons.accessibility_new_outlined,
      price: '₹899',
      isCompleted: false,
    ),
  ];

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.red.withOpacity(0.15),
                      AppColors.red.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.logout_rounded, color: AppColors.red, size: 30),
              ),
              const SizedBox(height: 18),
              Text('Logout',
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepPurple)),
              const SizedBox(height: 8),
              Text(
                'You have 3 pending visits today.\nAre you sure you want to logout?',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.greyText, height: 1.6),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: AppColors.orange, size: 16),
                    const SizedBox(width: 6),
                    Text('Pending visits will be reassigned',
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.orange)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.purple,
                        side: const BorderSide(
                            color: AppColors.purple, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Stay',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Logout',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Gradient Header ──────────────────────────────────────
            _GradientHeader(onLogout: _showLogoutDialog),

            // ── Stats ────────────────────────────────────────────────
            Transform.translate(
              offset: const Offset(0, -28),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _StatsRow(),
              ),
            ),

            // ── Progress Bar ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: _DayProgressCard(
                total: _patients.length,
                completed:
                    _patients.where((p) => p.isCompleted).length,
              ),
            ),

            // ── Today's Appointments ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                "Today's Appointments",
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepPurple),
              ),
            ),
            const SizedBox(height: 14),

            // Appointments summary card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _AppointmentsSummaryCard(
                count: _patients.length,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AppointmentsPatientScreen()),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Gradient Header ───────────────────────────────────────────────────────────
class _GradientHeader extends StatelessWidget {
  final VoidCallback onLogout;
  const _GradientHeader({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.purple.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.orange.withOpacity(0.05),
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 52),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: greeting + avatar + logout
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Good Morning 👋',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppColors.greyText,
                                    fontWeight: FontWeight.w400)),
                            const SizedBox(height: 4),
                            Text('Nurse Priya Sharma',
                                style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepPurple)),
                          ],
                        ),
                      ),
                      // Avatar
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.purple.withOpacity(0.4),
                              width: 2),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/nurse.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.purple.withOpacity(0.10),
                              child: const Icon(Icons.person_rounded,
                                  size: 24, color: AppColors.purple),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Logout
                      GestureDetector(
                        onTap: onLogout,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.red.withOpacity(0.08),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.red.withOpacity(0.20),
                                width: 1),
                          ),
                          child: const Icon(Icons.logout_rounded,
                              color: AppColors.red, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Date + shift pill
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.purple.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.purple.withOpacity(0.15),
                              width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                size: 13, color: AppColors.purple),
                            const SizedBox(width: 6),
                            Text('Wednesday, 02 Sep 2026',
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.deepPurple,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.orange.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.orange.withOpacity(0.25),
                              width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.wb_sunny_rounded,
                                size: 13, color: AppColors.orange),
                            const SizedBox(width: 6),
                            Text('Morning Shift',
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.orange,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats Row ─────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          _StatItem(
            value: '4',
            label: "Today's\nVisits",
            icon: Icons.medical_services_rounded,
            color: AppColors.purple,
          ),
          _Divider(),
          _StatItem(
            value: '1',
            label: 'Completed',
            icon: Icons.check_circle_rounded,
            color: const Color(0xFF2E7D32),
          ),
          _Divider(),
          _StatItem(
            value: '3',
            label: 'Remaining',
            icon: Icons.pending_rounded,
            color: AppColors.orange,
          ),
          _Divider(),
          _StatItem(
            value: '4.9',
            label: 'Rating',
            icon: Icons.star_rounded,
            color: const Color(0xFFFFA000),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const _StatItem(
      {required this.value,
      required this.label,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepPurple)),
          Text(label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: AppColors.greyText,
                  height: 1.3)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 50,
      color: const Color(0xFFF0F0F0),
    );
  }
}

// ── Day Progress Card ─────────────────────────────────────────────────────────
class _DayProgressCard extends StatelessWidget {
  final int total;
  final int completed;
  const _DayProgressCard(
      {required this.total, required this.completed});

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5B2D8E), Color(0xFF9C57D3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Today's Progress",
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.80),
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 4),
                Text('$completed of $total visits done',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 14),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.20),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                Text('${(progress * 100).toInt()}% completed',
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.70))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Circle progress indicator
          SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 7,
                  backgroundColor: Colors.white.withOpacity(0.20),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Appointments Summary Card ─────────────────────────────────────────────────
class _AppointmentsSummaryCard extends StatelessWidget {
  final int count;
  final VoidCallback onTap;
  const _AppointmentsSummaryCard(
      {required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.purple.withOpacity(0.10),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Orange bubble — top right
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.orange.withOpacity(0.12),
                  ),
                ),
              ),
              // Purple bubble — bottom left
              Positioned(
                bottom: -35,
                left: -20,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.purple.withOpacity(0.10),
                  ),
                ),
              ),
              // Small orange bubble — bottom right
              Positioned(
                bottom: -10,
                right: 40,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.orange.withOpacity(0.07),
                  ),
                ),
              ),
              // Content
              Row(
                children: [
                  // Icon box
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.purple.withOpacity(0.15),
                          AppColors.orange.withOpacity(0.10),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.purple.withOpacity(0.15),
                          width: 1),
                    ),
                    child: Icon(
                      Icons.calendar_month_rounded,
                      color: AppColors.purple,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 18),
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$count Appointments',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tap to view all appointment details',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.greyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Arrow
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.purple.withOpacity(0.10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward_rounded,
                        color: AppColors.purple, size: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ── Data Model ────────────────────────────────────────────────────────────────
class _PatientData {
  final String name;
  final String service;
  final String time;
  final String address;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final String bookingId;
  final IconData icon;
  final String price;
  final bool isCompleted;

  const _PatientData({
    required this.name,
    required this.service,
    required this.time,
    required this.address,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.bookingId,
    required this.icon,
    required this.price,
    required this.isCompleted,
  });
}
