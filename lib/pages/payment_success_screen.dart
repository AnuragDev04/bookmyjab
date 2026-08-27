import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'appointment_detail_screen.dart';
import 'home_screen.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String serviceName;
  final int totalAmount;
  final String selectedDate;
  final String selectedTime;
  final String paymentMethod;

  const PaymentSuccessScreen({
    super.key,
    required this.serviceName,
    required this.totalAmount,
    required this.selectedDate,
    required this.selectedTime,
    required this.paymentMethod,
  });

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnim  = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _bookingId {
    final now = DateTime.now();
    return 'BMJ${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecondsSinceEpoch % 10000}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),

              // ── Animated success icon ──────────────────────────────
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: Color(0xFF2E7D32), size: 60),
                ),
              ),
              const SizedBox(height: 24),

              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    Text('Payment Successful!',
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepPurple)),
                    const SizedBox(height: 6),
                    Text(
                      'Your booking has been confirmed.\nWe\'ll see you soon!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.greyText,
                          height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // ── Booking details card ───────────────────────────────
              FadeTransition(
                opacity: _fadeAnim,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5FA),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFFE8E8E8)),
                  ),
                  child: Column(
                    children: [
                      _DetailRow(
                          icon: Icons.medical_services_outlined,
                          label: 'Service',
                          value: widget.serviceName),
                      const _RowDivider(),
                      _DetailRow(
                          icon: Icons.confirmation_number_outlined,
                          label: 'Booking ID',
                          value: _bookingId),
                      const _RowDivider(),
                      _DetailRow(
                          icon: Icons.calendar_today_rounded,
                          label: 'Date & Time',
                          value:
                              '${widget.selectedDate}, ${widget.selectedTime}'),
                      const _RowDivider(),
                      _DetailRow(
                          icon: Icons.payment_outlined,
                          label: 'Payment',
                          value: widget.paymentMethod),
                      const _RowDivider(),
                      _DetailRow(
                          icon: Icons.currency_rupee_rounded,
                          label: 'Amount Paid',
                          value: '₹${widget.totalAmount}',
                          valueColor: const Color(0xFF2E7D32)),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // ── Buttons ────────────────────────────────────────────
              FadeTransition(
                opacity: _fadeAnim,
                child: Column(
                  children: [
                    // View booking
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AppointmentDetailScreen(
                              serviceName: widget.serviceName,
                              selectedDate: widget.selectedDate,
                              selectedTime: widget.selectedTime,
                              address: '12, Park Street, Bangalore,\nKarnataka - 560001',
                              bookingId: _bookingId,
                            ),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: AppColors.purple, width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text('View Booking',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.purple)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Go to home
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HomeScreen()),
                          (route) => false,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text('Go to Home',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Detail row ────────────────────────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  const _DetailRow(
      {required this.icon,
      required this.label,
      required this.value,
      this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.purple),
          const SizedBox(width: 12),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.greyText,
                  fontWeight: FontWeight.w400)),
          const Spacer(),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppColors.deepPurple)),
          ),
        ],
      ),
    );
  }
}

class _RowDivider extends StatelessWidget {
  const _RowDivider();
  @override
  Widget build(BuildContext context) =>
      const Divider(color: Color(0xFFE8E8E8), thickness: 1, height: 1);
}
