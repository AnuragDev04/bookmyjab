import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'nurse_detail_screen.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final String serviceName;
  final String selectedDate;
  final String selectedTime;
  final String address;
  final String bookingId;
  final String nurseName;
  final String nurseRole;
  final String nurseRating;
  final String nurseReviews;
  final String nurseExperience;

  const AppointmentDetailScreen({
    super.key,
    required this.serviceName,
    required this.selectedDate,
    required this.selectedTime,
    required this.address,
    required this.bookingId,
    this.nurseName = 'Priya Sharma',
    this.nurseRole = 'Home Nurse',
    this.nurseRating = '4.8',
    this.nurseReviews = '124',
    this.nurseExperience = '5 yrs',
  });

  // Generate a short ref like #4E2EA932 from bookingId
  String get _ref =>
      bookingId.startsWith('#') ? bookingId : '#${bookingId.toUpperCase()}';

  // Formatted date string
  String get _dateStr => selectedDate.isNotEmpty ? selectedDate : '08-08-2026';

  String get _consentTimestamp {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final h = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final ampm = now.hour >= 12 ? 'pm' : 'am';
    final min = now.minute.toString().padLeft(2, '0');
    return '${now.day} ${months[now.month - 1]} ${now.year}, $h:$min $ampm';
  }

  @override
  Widget build(BuildContext context) {
    // Charge calculations
    const double vaccineCharge = 268;
    const double adminCharge = 499;
    const double total = vaccineCharge + adminCharge;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.deepPurple,
            size: 20,
          ),
        ),
        title: Text(
          'Booking Details',
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
        ),
        child: Row(
          children: [
            // ── Reschedule ──────────────────────────────────────────
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // TODO: navigate to reschedule flow
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.purple,
                  side: const BorderSide(color: AppColors.purple, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Reschedule',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // ── Cancel Booking ──────────────────────────────────────
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: show cancel confirmation dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Cancel Booking',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body:
          // ── Scrollable body ────────────────────────────────────────
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Section label ─────────────────────────────────
                Text(
                  'BOOKING & CONSENT',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.orange,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Bookmyjab Booking & Consent\nSummary',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.deepPurple,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Reference $_ref',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.greyText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _dateStr,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.greyText,
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(color: Color(0xFFEEEEEE)),
                const SizedBox(height: 20),

                // ── ASSIGNED NURSE ────────────────────────────────
                Text(
                  'ASSIGNED NURSE',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.purple,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NurseDetailScreen(
                        name: nurseName,
                        role: nurseRole,
                        rating: nurseRating,
                        reviews: nurseReviews,
                        experience: nurseExperience,
                        distance: '2.4 km',
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.purple.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Avatar
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.purple.withOpacity(0.10),
                            border: Border.all(
                                color: AppColors.purple.withOpacity(0.2),
                                width: 2),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/nurse.png',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                  Icons.person_rounded,
                                  size: 28,
                                  color: AppColors.purple),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Name + role + stats
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nurseName,
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepPurple),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                nurseRole,
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.greyText),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  // Rating
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF8E1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star_rounded,
                                            size: 13,
                                            color: Color(0xFFFFA000)),
                                        const SizedBox(width: 3),
                                        Text(
                                          '$nurseRating ($nurseReviews)',
                                          style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFFFFA000)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  // Experience
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.purple.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.work_outline_rounded,
                                            size: 12,
                                            color: AppColors.purple),
                                        const SizedBox(width: 3),
                                        Text(
                                          nurseExperience,
                                          style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.purple),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // View profile arrow
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.purple.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward_rounded,
                              color: AppColors.purple, size: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ── BOOKING REQUEST ───────────────────────────────
                Text(
                  'BOOKING REQUEST',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.purple,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),

                // Details table card
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                  ),
                  child: Column(
                    children: [
                      _TableRow(
                        label: 'Patient',
                        value: 'Test',
                        valueBold: true,
                      ),
                      _TableRow(
                        label: 'Vaccine',
                        value: serviceName.isNotEmpty ? serviceName : 'OPV',
                        valueBold: true,
                      ),
                      _TableRow(
                        label: 'Date',
                        value: _dateStr,
                        valueBold: true,
                      ),
                      _TableRow(
                        label: 'Slot',
                        value: selectedTime.isNotEmpty
                            ? selectedTime
                            : '4:00 PM – 5:00 PM',
                        valueBold: true,
                      ),
                      _TableRow(
                        label: 'Address',
                        value: address.isNotEmpty
                            ? '$address\nContact: Test (+91 9325996893)'
                            : 'Dvv, Dgh, Fg, Cvn, Landmark: Tg,\nContact: Test (+91 9325996893)',
                        valueBold: true,
                      ),
                      _TableRow(
                        label: 'Payment mode',
                        value: 'Cash on Delivery',
                        valueBold: true,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Cash note card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8F2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border(
                      left: BorderSide(color: AppColors.orange, width: 4),
                    ),
                  ),
                  child: Text(
                    'to be collected in cash at the time of vaccination.\n'
                    'Booking Ref $_ref.',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.greyText,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ── CHARGE SUMMARY ────────────────────────────────
                Text(
                  'CHARGE SUMMARY',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.purple,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vaccine line
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${serviceName.isNotEmpty ? serviceName : 'OPV'} · Test',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.deepPurple,
                            ),
                          ),
                          Text(
                            '₹${vaccineCharge.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Admin charge line
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Home administration & coordination',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: AppColors.deepPurple,
                                ),
                              ),
                              Text(
                                '₹${adminCharge.toStringAsFixed(0)} × 1 injection',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppColors.greyText,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '₹${adminCharge.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                      ),

                      // Estimated total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Estimated total',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepPurple,
                            ),
                          ),
                          Text(
                            '₹${total.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Final amount will be confirmed against the pharmacy '
                        'invoice on the day of the appointment.',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: AppColors.greyText,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // ── ACCEPTED CONSENT ──────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ACCEPTED CONSENT',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.orange,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Accepted on $_consentTimestamp',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.greyText,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Bullet list
                      ...[
                        'Terms & Conditions, Privacy, Refund, Medical Declaration and Vaccination Consent',
                        'Medical Declaration',
                        'Vaccination Consent',
                        'Procurement Authorisation',
                        'Data & Privacy',
                        'Emergency & Limitation',
                      ].map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  right: 8,
                                ),
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: AppColors.deepPurple,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppColors.deepPurple,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      const SizedBox(height: 14),

                      // Legal versions
                      Text(
                        'LEGAL VERSIONS',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.purple,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...[
                        'BMJ-CONSENT-V1.0-2026-05',
                        'terms:BMJ-TERMS-V1.0-2026-05',
                        'privacy:BMJ-PRIVACY-V1.0-2026-05',
                        'refund:BMJ-REFUND-V1.0-2026-05',
                        'vaccine_consent:BMJ-VACCINE-CONSENT-V1.0-2026-05',
                        'medical_declaration:BMJ-MEDICAL-DECLARATION-V1.0-2026-05',
                        'procurement_auth:BMJ-PROCUREMENT-AUTH-V1.0-2026-05',
                        'emergency_limitation:BMJ-EMERGENCY-LIMITATION-V1.0-2026-05',
                      ].map(
                        (v) => Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Text(
                            v,
                            style: GoogleFonts.robotoMono(
                              fontSize: 10,
                              color: AppColors.greyText,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
    );
  }
}

// ── Table row ─────────────────────────────────────────────────────────────────
class _TableRow extends StatelessWidget {
  final String label;
  final String value;
  final bool valueBold;
  final bool isLast;

  const _TableRow({
    required this.label,
    required this.value,
    this.valueBold = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 110,
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.greyText,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: valueBold ? FontWeight.w700 : FontWeight.w400,
                    color: AppColors.deepPurple,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            color: Color(0xFFF5F5F5),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
