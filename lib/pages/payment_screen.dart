import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'appointment_detail_screen.dart';
import 'home_screen.dart';

class PaymentScreen extends StatelessWidget {
  final String serviceName;
  final int totalAmount;
  final String selectedDate;
  final String selectedTime;

  const PaymentScreen({
    super.key,
    required this.serviceName,
    required this.totalAmount,
    required this.selectedDate,
    required this.selectedTime,
  });

  // Format today's date/time for the consent timestamp
  String get _consentTimestamp {
    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final h = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final ampm = now.hour >= 12 ? 'pm' : 'am';
    final min = now.minute.toString().padLeft(2, '0');
    return '${now.day} ${months[now.month - 1]} ${now.year}, $h:$min $ampm';
  }

  String get _bookingDate =>
      selectedDate.isNotEmpty ? selectedDate : '01-09-2026';

  String get _bookingId => 'BMJ${totalAmount}001';

  void _showInvoice(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _InvoiceSheet(
        serviceName: serviceName,
        bookingDate: _bookingDate,
        selectedTime: selectedTime,
        totalAmount: totalAmount,
        bookingId: _bookingId,
        consentTimestamp: _consentTimestamp,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFF0F0F0)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            // ── Orange circle check icon ──────────────────────────────
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.orange.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.orange,
                size: 52,
              ),
            ),
            const SizedBox(height: 28),

            // ── Heading ───────────────────────────────────────────────
            Text(
              'Booking Request Received',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: AppColors.deepPurple,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 14),

            // ── Subtitle ──────────────────────────────────────────────
            Text(
              'Our team will review your request and\nconfirm slot availability.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.greyText,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),

            // ── Request detail paragraph ──────────────────────────────
            Text(
              'Your request for $serviceName on $_bookingDate has been received. '
              'We will reach out on WhatsApp or call to confirm availability, '
              'prescription/doctor review and payment details before the appointment is confirmed.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.greyText,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 20),

            // ── Safety notice card ────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8F5),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.orange.withOpacity(0.25)),
              ),
              child: Text(
                'If you or the recipient experience any symptoms such as difficulty '
                'breathing, chest pain or persistent reactions, seek emergency '
                'medical care immediately and contact BookMyJab support.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.greyText,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Consent timestamp ─────────────────────────────────────
            Text(
              'Consent accepted on $_consentTimestamp. A copy of the '
              'applicable terms is available in your booking record.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.greyText,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () {},
              child: Text(
                'View accepted consent',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.orange,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.orange,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ── View Request button ───────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AppointmentDetailScreen(
                      serviceName: serviceName,
                      selectedDate: selectedDate.isNotEmpty
                          ? selectedDate
                          : '01-09-2026',
                      selectedTime: selectedTime.isNotEmpty
                          ? selectedTime
                          : '5:00 PM – 6:00 PM',
                      address: 'UI, I, U, Gurgaon',
                      bookingId: 'BMJ${totalAmount}001',
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  'View Request',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Download Invoice button ───────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton.icon(
                onPressed: () => _showInvoice(context),
                icon: const Icon(Icons.download_outlined,
                    color: AppColors.deepPurple, size: 20),
                label: Text(
                  'Download Invoice',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepPurple,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: Color(0xFFDDDDDD), width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Go Home button ────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: Color(0xFFDDDDDD), width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  backgroundColor: Colors.white,
                ),
                child: Text(
                  'Go Home',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepPurple,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Invoice Sheet ─────────────────────────────────────────────────────────────
class _InvoiceSheet extends StatelessWidget {
  final String serviceName;
  final String bookingDate;
  final String selectedTime;
  final int totalAmount;
  final String bookingId;
  final String consentTimestamp;

  const _InvoiceSheet({
    required this.serviceName,
    required this.bookingDate,
    required this.selectedTime,
    required this.totalAmount,
    required this.bookingId,
    required this.consentTimestamp,
  });

  static const double _vaccineCharge = 268;
  static const double _adminCharge = 499;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // ── Drag handle ───────────────────────────────────────────
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 4),

            // ── Header row with title + download icon ─────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Invoice',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepPurple,
                      ),
                    ),
                  ),
                  // Download icon button (top-right)
                  GestureDetector(
                    onTap: () {
                      // TODO: implement actual PDF download
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Invoice downloaded',
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                          backgroundColor: AppColors.deepPurple,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.deepPurple.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.download_rounded,
                        color: AppColors.deepPurple,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),

            // ── Scrollable invoice body ───────────────────────────────
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                children: [
                  // Brand header
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.purple.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.medical_services_rounded,
                            color: AppColors.purple, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BookMyJab',
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepPurple)),
                          Text('Tax Invoice',
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: AppColors.greyText)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Invoice meta
                  _InvoiceRow(label: 'Invoice No.', value: bookingId),
                  _InvoiceRow(label: 'Date', value: bookingDate),
                  _InvoiceRow(
                      label: 'Slot',
                      value: selectedTime.isNotEmpty
                          ? selectedTime
                          : '5:00 PM – 6:00 PM'),
                  _InvoiceRow(label: 'Patient', value: 'Test'),
                  _InvoiceRow(label: 'Payment', value: 'Cash on Delivery'),

                  const SizedBox(height: 20),
                  const Divider(color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 14),

                  // Line items
                  Text('ITEMS',
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.orange,
                          letterSpacing: 1.0)),
                  const SizedBox(height: 12),

                  _LineItem(
                    description: serviceName.isNotEmpty ? serviceName : 'OPV',
                    sub: 'Vaccine',
                    amount: _vaccineCharge,
                  ),
                  const SizedBox(height: 10),
                  _LineItem(
                    description: 'Home Administration',
                    sub: '& Coordination × 1',
                    amount: _adminCharge,
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 12),

                  // Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Estimated Total',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.deepPurple)),
                      Text(
                        '₹${(_vaccineCharge + _adminCharge).toStringAsFixed(0)}',
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.deepPurple),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Final amount confirmed against pharmacy invoice on appointment day.',
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.greyText,
                        height: 1.5),
                  ),

                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 14),

                  // Consent footer
                  Text(
                    'Consent accepted on $consentTimestamp.',
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.greyText,
                        height: 1.5),
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

// ── Invoice helper widgets ────────────────────────────────────────────────────
class _InvoiceRow extends StatelessWidget {
  final String label;
  final String value;
  const _InvoiceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.greyText)),
          ),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepPurple)),
          ),
        ],
      ),
    );
  }
}

class _LineItem extends StatelessWidget {
  final String description;
  final String sub;
  final double amount;
  const _LineItem(
      {required this.description, required this.sub, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(description,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepPurple)),
              Text(sub,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.greyText)),
            ],
          ),
        ),
        Text('₹${amount.toStringAsFixed(0)}',
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.deepPurple)),
      ],
    );
  }
}
