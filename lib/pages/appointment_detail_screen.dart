import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

class AppointmentDetailScreen extends StatefulWidget {
  final String serviceName;
  final String selectedDate;
  final String selectedTime;
  final String address;
  final String bookingId;

  const AppointmentDetailScreen({
    super.key,
    required this.serviceName,
    required this.selectedDate,
    required this.selectedTime,
    required this.address,
    required this.bookingId,
  });

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.deepPurple, size: 20),
        ),
        title: Text('Appointment Details',
            style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.deepPurple)),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(right: 14),
              child: const Icon(Icons.share_outlined,
                  color: AppColors.deepPurple, size: 20),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFF0F0F0)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Booking Hero Card ──────────────────────────────
                  _BookingHeroCard(
                    serviceName: widget.serviceName,
                    date: widget.selectedDate,
                    time: widget.selectedTime,
                    bookingId: widget.bookingId,
                  ),
                  const SizedBox(height: 16),

                  // ── Live Tracking ──────────────────────────────────
                  _LiveTrackingCard(),
                  const SizedBox(height: 16),

                  // ── Nurse Card ─────────────────────────────────────
                  _NurseCard(),
                  const SizedBox(height: 16),

                  // ── Address Card ───────────────────────────────────
                  _AddressCard(address: widget.address),
                  const SizedBox(height: 16),

                  // ── Price Summary ──────────────────────────────────
                  _PriceSummaryCard(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // ── Bottom buttons ─────────────────────────────────────────
          _BottomActions(
            onReschedule: () {},
            onCancel: () => _showCancelDialog(),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18)),
        title: Text('Cancel Appointment',
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.deepPurple)),
        content: Text(
            'Are you sure you want to cancel this appointment?',
            style: GoogleFonts.poppins(
                fontSize: 13, color: AppColors.greyText, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: AppColors.greyText)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Yes, Cancel',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Booking Hero Card
// ─────────────────────────────────────────────────────────────────────────────
class _BookingHeroCard extends StatelessWidget {
  final String serviceName;
  final String date;
  final String time;
  final String bookingId;

  const _BookingHeroCard({
    required this.serviceName,
    required this.date,
    required this.time,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3E1A6E), Color(0xFF7B4EBF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.purple.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -24,
            top: -24,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -30,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service name + status row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service icon
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(Icons.medical_services_outlined,
                          color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(serviceName,
                              style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                          const SizedBox(height: 2),
                          Text('Home Healthcare Service',
                              style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.75))),
                        ],
                      ),
                    ),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.22),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xFF4CAF50), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle_outline_rounded,
                              color: Color(0xFF81C784), size: 12),
                          const SizedBox(width: 4),
                          Text('Confirmed',
                              style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF81C784))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Divider
                Container(
                    height: 1, color: Colors.white.withOpacity(0.15)),
                const SizedBox(height: 14),

                // Date / Time / Booking ID row
                Row(
                  children: [
                    _HeroInfoItem(
                        icon: Icons.calendar_today_rounded,
                        label: 'Date',
                        value: date),
                    Container(
                        width: 1,
                        height: 32,
                        color: Colors.white.withOpacity(0.2)),
                    _HeroInfoItem(
                        icon: Icons.access_time_rounded,
                        label: 'Time',
                        value: time),
                    Container(
                        width: 1,
                        height: 32,
                        color: Colors.white.withOpacity(0.2)),
                    _HeroInfoItem(
                        icon: Icons.tag_rounded,
                        label: 'Booking ID',
                        value: bookingId.length > 12
                            ? bookingId.substring(0, 12) + '…'
                            : bookingId),
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

class _HeroInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _HeroInfoItem(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.7), size: 14),
            const SizedBox(height: 3),
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 9,
                    color: Colors.white.withOpacity(0.6))),
            const SizedBox(height: 2),
            Text(value,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Live Tracking Card
// ─────────────────────────────────────────────────────────────────────────────
class _LiveTrackingCard extends StatelessWidget {
  static const _steps = [
    _TrackStep('Booked',      Icons.check_circle_rounded,       true,  true),
    _TrackStep('Confirmed',   Icons.verified_rounded,           true,  true),
    _TrackStep('On the Way',  Icons.directions_bike_rounded,    true,  false),
    _TrackStep('Arrived',     Icons.home_rounded,               false, false),
    _TrackStep('Completed',   Icons.task_alt_rounded,           false, false),
  ];

  const _LiveTrackingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text('Live Tracking',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepPurple)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('ETA: 15 mins',
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E7D32))),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Step tracker
          Row(
            children: List.generate(_steps.length * 2 - 1, (i) {
              if (i.isOdd) {
                // Connector line
                final prev = _steps[i ~/ 2];
                final next = _steps[i ~/ 2 + 1];
                final filled = prev.done && next.done;
                final halfFilled = prev.done && !next.done;
                return Expanded(
                  child: Stack(
                    children: [
                      Container(
                          height: 3,
                          color: const Color(0xFFE0E0E0)),
                      if (filled)
                        Container(
                            height: 3,
                            color: AppColors.purple),
                      if (halfFilled)
                        FractionallySizedBox(
                          widthFactor: 0.5,
                          child: Container(
                              height: 3,
                              color: AppColors.purple),
                        ),
                    ],
                  ),
                );
              }
              final step = _steps[i ~/ 2];
              return _TrackStepDot(step: step);
            }),
          ),
          const SizedBox(height: 10),

          // Labels row
          Row(
            children: List.generate(_steps.length * 2 - 1, (i) {
              if (i.isOdd) return const Expanded(child: SizedBox());
              final step = _steps[i ~/ 2];
              return SizedBox(
                width: 52,
                child: Text(step.label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: step.active
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: step.active
                            ? AppColors.purple
                            : AppColors.greyText)),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _TrackStep {
  final String label;
  final IconData icon;
  final bool done;
  final bool active;
  const _TrackStep(this.label, this.icon, this.done, this.active);
}

class _TrackStepDot extends StatelessWidget {
  final _TrackStep step;
  const _TrackStepDot({required this.step});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      child: Center(
        child: Container(
          width: step.active ? 38 : 32,
          height: step.active ? 38 : 32,
          decoration: BoxDecoration(
            color: step.done
                ? AppColors.purple
                : const Color(0xFFEEEEEE),
            shape: BoxShape.circle,
            border: step.active
                ? Border.all(
                    color: AppColors.purple.withOpacity(0.3), width: 3)
                : null,
            boxShadow: step.active
                ? [
                    BoxShadow(
                        color: AppColors.purple.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 3))
                  ]
                : [],
          ),
          child: Icon(step.icon,
              size: step.active ? 18 : 15,
              color: step.done ? Colors.white : AppColors.greyText),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Nurse Card
// ─────────────────────────────────────────────────────────────────────────────
class _NurseCard extends StatelessWidget {
  const _NurseCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Assigned Nurse',
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.greyText)),
          const SizedBox(height: 12),
          Row(
            children: [
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.purple.withOpacity(0.10),
                      border: Border.all(
                          color: AppColors.purple.withOpacity(0.25),
                          width: 2),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/nurse.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.person_rounded,
                            color: AppColors.purple,
                            size: 30),
                      ),
                    ),
                  ),
                  // Online dot
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Priya Sharma',
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepPurple)),
                    const SizedBox(height: 2),
                    Text('Staff Nurse · 5 Years Exp.',
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.greyText)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFFFC107), size: 14),
                        const SizedBox(width: 3),
                        Text('4.8',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.deepPurple)),
                        Text(' (120 reviews)',
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.greyText)),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              Column(
                children: [
                  _RoundBtn(
                      icon: Icons.call_rounded,
                      color: AppColors.purple,
                      onTap: () {}),
                  const SizedBox(height: 8),
                  _RoundBtn(
                      icon: Icons.chat_bubble_outline_rounded,
                      color: AppColors.orange,
                      onTap: () {}),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Address Card
// ─────────────────────────────────────────────────────────────────────────────
class _AddressCard extends StatelessWidget {
  final String address;
  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.location_on_rounded,
                color: AppColors.orange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Service Address',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepPurple)),
                const SizedBox(height: 3),
                Text(address,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.greyText,
                        height: 1.5)),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.purple.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Map',
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.purple)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Price Summary Card
// ─────────────────────────────────────────────────────────────────────────────
class _PriceSummaryCard extends StatelessWidget {
  const _PriceSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Price Summary',
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepPurple)),
          const SizedBox(height: 14),
          _PriceRow(label: 'Service Fee',   value: '₹719'),
          const SizedBox(height: 8),
          _PriceRow(label: 'Platform Fee',  value: '₹20'),
          const SizedBox(height: 8),
          _PriceRow(
              label: 'Discount (CARE20)',
              value: '−₹180',
              valueColor: const Color(0xFF2E7D32)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFF0F0F0)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Paid',
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepPurple)),
              Text('₹739',
                  style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.orange)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _PriceRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.greyText,
                fontWeight: FontWeight.w400)),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: valueColor ?? AppColors.deepPurple)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom actions
// ─────────────────────────────────────────────────────────────────────────────
class _BottomActions extends StatelessWidget {
  final VoidCallback onReschedule;
  final VoidCallback onCancel;
  const _BottomActions(
      {required this.onReschedule, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, -4))
        ],
      ),
      child: Row(
        children: [
          // Reschedule
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: onReschedule,
                icon: const Icon(Icons.edit_calendar_rounded,
                    size: 18, color: AppColors.purple),
                label: Text('Reschedule',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.purple)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: AppColors.purple, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Cancel
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.cancel_outlined,
                    size: 18, color: Colors.white),
                label: Text('Cancel Appointment',
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Round icon button
// ─────────────────────────────────────────────────────────────────────────────
class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _RoundBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withOpacity(0.10),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
