import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'payment_screen.dart';

class ConfirmBookingScreen extends StatefulWidget {
  final String serviceName;
  final String servicePrice;
  final String selectedDate;
  final String selectedTime;
  final String address;

  const ConfirmBookingScreen({
    super.key,
    required this.serviceName,
    required this.servicePrice,
    required this.selectedDate,
    required this.selectedTime,
    required this.address,
  });

  @override
  State<ConfirmBookingScreen> createState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends State<ConfirmBookingScreen> {
  final _instructionsController = TextEditingController();

  // Parse price for breakdown (use base 899 if not parseable)
  int get _serviceFee {
    final raw = widget.servicePrice
        .replaceAll('₹', '')
        .replaceAll(' ', '')
        .split('-')
        .first
        .trim();
    return int.tryParse(raw) ?? 899;
  }

  static const int _platformFee = 20;
  static const int _discount = 180;

  int get _totalAmount => _serviceFee + _platformFee - _discount;

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  void _confirmBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          serviceName: widget.serviceName,
          totalAmount: _totalAmount,
          selectedDate: widget.selectedDate,
          selectedTime: widget.selectedTime,
        ),
      ),
    );
  }

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
        title: Text('Confirm Your Booking',
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
          // ── Step indicator ─────────────────────────────────────────
          _StepIndicator(currentStep: 3),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Service summary card ──────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Column(
                      children: [
                        // Service row
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.purple.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    'assets/images/nurse.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        const Icon(
                                            Icons.medical_services_outlined,
                                            color: AppColors.purple,
                                            size: 26),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(widget.serviceName,
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.deepPurple)),
                                    const SizedBox(height: 3),
                                    Text(
                                        '${widget.selectedDate}, ${widget.selectedTime}',
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: AppColors.greyText)),
                                    const SizedBox(height: 2),
                                    Text(widget.address,
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: AppColors.greyText)),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded,
                                  color: AppColors.greyText, size: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Price Details card ────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Price Details',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.deepPurple)),
                        const SizedBox(height: 14),
                        _PriceRow(
                            label: 'Service Fee',
                            value: '₹$_serviceFee',
                            valueColor: AppColors.deepPurple),
                        const SizedBox(height: 10),
                        _PriceRow(
                            label: 'Platform Fee',
                            value: '₹$_platformFee',
                            valueColor: AppColors.deepPurple),
                        const SizedBox(height: 10),
                        _PriceRow(
                            label: 'Discount (CARE20)',
                            value: '-₹$_discount',
                            valueColor: const Color(0xFF2E7D32)),
                        const SizedBox(height: 14),
                        const Divider(
                            color: Color(0xFFE8E8E8), thickness: 1),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Amount',
                                style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepPurple)),
                            Text('₹$_totalAmount',
                                style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.deepPurple)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Special Instructions ──────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Special Instructions (Optional)',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.deepPurple)),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _instructionsController,
                          maxLines: 3,
                          style: GoogleFonts.poppins(
                              fontSize: 13, color: AppColors.deepPurple),
                          decoration: InputDecoration(
                            hintText: 'Type your instructions...',
                            hintStyle: GoogleFonts.poppins(
                                fontSize: 13, color: AppColors.greyText),
                            filled: true,
                            fillColor: const Color(0xFFF5F5FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // ── Confirm Booking button ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Confirm Booking',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Price row ─────────────────────────────────────────────────────────────────
class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  const _PriceRow(
      {required this.label,
      required this.value,
      required this.valueColor});

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
                color: valueColor)),
      ],
    );
  }
}

// ── Step indicator ────────────────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['Service', 'Date & Time', 'Address', 'Confirm'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIndex = i ~/ 2;
            final done = stepIndex < currentStep;
            return Expanded(
              child: Container(
                height: 2,
                color:
                    done ? AppColors.purple : const Color(0xFFE0E0E0),
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final done = stepIndex < currentStep;
          final active = stepIndex == currentStep;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: active
                      ? AppColors.orange
                      : done
                          ? AppColors.purple
                          : const Color(0xFFE0E0E0),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: done
                      ? const Icon(Icons.check_rounded,
                          color: Colors.white, size: 14)
                      : Text('${stepIndex + 1}',
                          style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? Colors.white
                                  : AppColors.greyText)),
                ),
              ),
              const SizedBox(height: 4),
              Text(steps[stepIndex],
                  style: GoogleFonts.poppins(
                      fontSize: 9,
                      fontWeight: active || done
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: active
                          ? AppColors.orange
                          : done
                              ? AppColors.purple
                              : AppColors.greyText)),
            ],
          );
        }),
      ),
    );
  }
}
