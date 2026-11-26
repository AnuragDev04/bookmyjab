import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
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
  int _selectedPayment = 0; // 0=Credit/Debit, 1=UPI, 2=Net Banking, 3=COD

  late final Razorpay _razorpay;

  static const _keyId = 'rzp_test_TTXiuWGssF8Oey';

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _onPaymentSuccess(PaymentSuccessResponse response) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          serviceName: widget.serviceName,
          totalAmount: _total.round(),
          selectedDate: widget.selectedDate,
          selectedTime: widget.selectedTime,
        ),
      ),
    );
  }

  void _onPaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment failed: ${response.message ?? 'Unknown error'}',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'External wallet selected: ${response.walletName}',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        backgroundColor: AppColors.purple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static const _paymentMethods = [
    'Credit / Debit Card',
    'UPI',
    'Net Banking',
    'Cash on Delivery',
  ];

  static const double _brandPrice = 85.56;
  static const double _adminCharge = 499.00;

  double get _total => _brandPrice + _adminCharge;

  void _confirmBooking() {
    // Amount must be in paise (multiply by 100)
    final options = {
      'key': _keyId,
      'amount': (_total * 100).round(), // paise
      'name': 'BookMyJab',
      'description': widget.serviceName,
      'prefill': {'contact': '9000000000', 'email': 'test@bookmyjab.com'},
      'theme': {
        'color': '#FF6B35', // AppColors.orange
      },
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Unable to open payment: $e',
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Book ${widget.serviceName}',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.deepPurple,
              ),
            ),
            Text(
              'Step 7 of 7',
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: AppColors.greyText,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: Stack(
            children: [
              Container(height: 5, color: const Color(0xFFEEEEEE)),
              FractionallySizedBox(
                widthFactor: 1.0,
                child: Container(
                  height: 5,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.orange, Color(0xFFFF5C00)],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Review & Confirm heading ──────────────────────
                  Text(
                    'Review & Confirm',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Booking details table card ────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    child: Column(
                      children: [
                        _DetailRow(
                          label: 'Vaccine',
                          value: widget.serviceName.isNotEmpty
                              ? widget.serviceName
                              : 'BCG',
                        ),
                        _DetailRow(
                          label: 'RECIPIENTS',
                          value: 'BCG          Test · 21y',
                          valueBold: false,
                        ),
                        _DetailRow(
                          label: 'Date',
                          value: widget.selectedDate.isNotEmpty
                              ? widget.selectedDate
                              : 'Tue, 1 Sept',
                        ),
                        _DetailRow(
                          label: 'Slot',
                          value: widget.selectedTime.isNotEmpty
                              ? widget.selectedTime
                              : '5:00 PM – 6:00 PM',
                        ),
                        _DetailRow(
                          label: 'Address',
                          value: widget.address.isNotEmpty
                              ? widget.address
                              : 'UI, I, U, Gurgaon\nContact: Test (+91 9325996893)',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Pricing section ───────────────────────────────
                  Text(
                    'Pricing',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand/Product label
                        Row(
                          children: [
                            const Icon(
                              Icons.local_pharmacy_outlined,
                              size: 16,
                              color: AppColors.orange,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.serviceName.isNotEmpty
                                  ? widget.serviceName
                                  : 'BCG',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Brand / Product',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.greyText,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Radio option — selected brand
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.orange.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.orange.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.orange,
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.orange,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tubervac BCG',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.deepPurple,
                                      ),
                                    ),
                                    Text(
                                      'Only brand available — auto-selected',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: AppColors.greyText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '₹${_brandPrice.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Availability note
                        Text(
                          'Price fulfilment depends on pharmacy availability. If a '
                          'selected brand is unavailable, our team will contact you '
                          'before authorisation or refund.',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: AppColors.greyText,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: Color(0xFFF0F0F0)),
                        const SizedBox(height: 14),

                        // Home administration row
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Home administration &\ncoordination',
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.deepPurple,
                                    ),
                                  ),
                                  Text(
                                    'Nurse + 1 injection = ₹499',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: AppColors.greyText,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      'View MRP breakdown',
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: AppColors.orange,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.orange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '₹${_adminCharge.toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepPurple,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1, color: Color(0xFFF0F0F0)),
                        const SizedBox(height: 14),

                        // Total payable
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total payable',
                              style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepPurple,
                              ),
                            ),
                            Text(
                              '₹${_total.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Payment Method ────────────────────────────────
                  Text(
                    'Select your preferred payment mode.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.greyText,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    'Payment Method',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Column(
                      children: List.generate(_paymentMethods.length, (i) {
                        final isLast = i == _paymentMethods.length - 1;
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _selectedPayment = i),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    // Radio circle
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: _selectedPayment == i
                                              ? AppColors.orange
                                              : const Color(0xFFCCCCCC),
                                          width: 2,
                                        ),
                                      ),
                                      child: _selectedPayment == i
                                          ? Center(
                                              child: Container(
                                                width: 9,
                                                height: 9,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColors.orange,
                                                ),
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 14),
                                    Text(
                                      _paymentMethods[i],
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: _selectedPayment == i
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: AppColors.deepPurple,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (!isLast)
                              const Divider(
                                height: 1,
                                color: Color(0xFFF0F0F0),
                                indent: 16,
                                endIndent: 16,
                              ),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const SizedBox(height: 12),

                  // ── Footer links ──────────────────────────────────
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children:
                        [
                              'Terms & Conditions',
                              'Privacy Notice',
                              'Refund Policy',
                              'Medical Declaration & Vaccination Consent',
                              'Grievance / Support Contact',
                            ]
                            .map(
                              (t) => GestureDetector(
                                onTap: () {},
                                child: Text(
                                  t,
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppColors.greyText,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.greyText,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 16),

                  // ── Social icons ──────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialIcon(Icons.camera_alt_outlined),
                      const SizedBox(width: 16),
                      _SocialIcon(Icons.work_outline_rounded),
                      const SizedBox(width: 16),
                      _SocialIcon(Icons.facebook_outlined),
                      const SizedBox(width: 16),
                      _SocialIcon(Icons.alternate_email_rounded),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── Sticky bottom bar: Total + Confirm Booking ────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 16, 28),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 16,
                  offset: Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Total payable
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Payable',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.greyText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${_total.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepPurple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                // Confirm Booking button
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _confirmBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Pay Now',
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

// ── Detail row ────────────────────────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool valueBold;
  final bool isLast;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueBold = true,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
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
                    fontWeight: valueBold ? FontWeight.w600 : FontWeight.w400,
                    color: AppColors.deepPurple,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, color: Color(0xFFF5F5F5)),
      ],
    );
  }
}

// ── Social icon ───────────────────────────────────────────────────────────────
class _SocialIcon extends StatelessWidget {
  final IconData icon;

  const _SocialIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: AppColors.greyText),
    );
  }
}
