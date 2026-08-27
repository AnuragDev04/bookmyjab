import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'payment_success_screen.dart';

class PaymentScreen extends StatefulWidget {
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

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _couponController = TextEditingController();
  String? _selectedMethod; // 'upi' | 'card' | 'netbanking' | 'wallet'
  bool _couponApplied = false;
  bool _isProcessing = false;

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  // ─── Coupon apply ────────────────────────────────────────────────────────
  void _applyCoupon() {
    final code = _couponController.text.trim().toUpperCase();
    if (code == 'CARE20') {
      setState(() => _couponApplied = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Coupon CARE20 applied!',
              style: GoogleFonts.poppins(fontSize: 13)),
          backgroundColor: AppColors.accentGreen,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid coupon code',
              style: GoogleFonts.poppins(fontSize: 13)),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  // ─── Pay now ─────────────────────────────────────────────────────────────
  void _payNow() async {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a payment method',
              style: GoogleFonts.poppins(fontSize: 13)),
          backgroundColor: AppColors.orange,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _isProcessing = false);

    // Map method id to display name
    const methodLabels = {
      'upi': 'UPI',
      'card': 'Credit / Debit Card',
      'netbanking': 'Net Banking',
      'wallet': 'Wallets',
    };

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSuccessScreen(
          serviceName: widget.serviceName,
          totalAmount: widget.totalAmount,
          selectedDate: widget.selectedDate,
          selectedTime: widget.selectedTime,
          paymentMethod: methodLabels[_selectedMethod] ?? 'UPI',
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
        title: Text(
          'Payment',
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Appointment Summary ─────────────────────────────────
                  _SectionLabel(label: 'Appointment Summary'),
                  const SizedBox(height: 10),
                  _AppointmentSummaryCard(
                    serviceName: widget.serviceName,
                    selectedDate: widget.selectedDate,
                    selectedTime: widget.selectedTime,
                    amount: widget.totalAmount,
                  ),
                  const SizedBox(height: 20),

                  // ── Coupon Code ─────────────────────────────────────────
                  _SectionLabel(label: 'Coupon Code'),
                  const SizedBox(height: 10),
                  _CouponField(
                    controller: _couponController,
                    applied: _couponApplied,
                    onApply: _applyCoupon,
                  ),
                  const SizedBox(height: 20),

                  // ── Payment Methods ─────────────────────────────────────
                  _SectionLabel(label: 'Payment Methods'),
                  const SizedBox(height: 10),
                  _PaymentMethodsCard(
                    selectedMethod: _selectedMethod,
                    onMethodSelected: (method) =>
                        setState(() => _selectedMethod = method),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // ── Bottom bar: Total + Pay Now ──────────────────────────────────
          _BottomPayBar(
            totalAmount: widget.totalAmount,
            isProcessing: _isProcessing,
            onPay: _payNow,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section Label
// ─────────────────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.deepPurple,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Appointment Summary Card
// ─────────────────────────────────────────────────────────────────────────────
class _AppointmentSummaryCard extends StatelessWidget {
  final String serviceName;
  final String selectedDate;
  final String selectedTime;
  final int amount;

  const _AppointmentSummaryCard({
    required this.serviceName,
    required this.selectedDate,
    required this.selectedTime,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Service icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.purple.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/nurse.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.medical_services_outlined,
                  color: AppColors.purple,
                  size: 26,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepPurple,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$selectedDate, $selectedTime',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.greyText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '1 Hour',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),

          // Price
          Text(
            '₹$amount',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.deepPurple,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Coupon Field
// ─────────────────────────────────────────────────────────────────────────────
class _CouponField extends StatelessWidget {
  final TextEditingController controller;
  final bool applied;
  final VoidCallback onApply;

  const _CouponField({
    required this.controller,
    required this.applied,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: applied ? AppColors.accentGreen : const Color(0xFFEEEEEE),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !applied,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.deepPurple,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Enter coupon code...',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.greyText,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: applied ? null : onApply,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: applied
                    ? AppColors.accentGreen
                    : AppColors.purple,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(11),
                  bottomRight: Radius.circular(11),
                ),
              ),
              child: Text(
                applied ? 'Applied' : 'Apply',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
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
// Payment Methods Card
// ─────────────────────────────────────────────────────────────────────────────
class _PaymentMethodsCard extends StatelessWidget {
  final String? selectedMethod;
  final ValueChanged<String> onMethodSelected;

  const _PaymentMethodsCard({
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  static const _methods = [
    _PaymentMethod(
      id: 'upi',
      label: 'UPI',
      iconAsset: null,
      iconWidget: _UpiIcon(),
    ),
    _PaymentMethod(
      id: 'card',
      label: 'Credit / Debit Card',
      iconAsset: null,
      iconWidget: _CardIcon(),
    ),
    _PaymentMethod(
      id: 'netbanking',
      label: 'Net Banking',
      iconAsset: null,
      iconWidget: _NetBankingIcon(),
    ),
    _PaymentMethod(
      id: 'wallet',
      label: 'Wallets',
      iconAsset: null,
      iconWidget: _WalletIcon(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: List.generate(_methods.length, (i) {
          final method = _methods[i];
          final isSelected = selectedMethod == method.id;
          final isLast = i == _methods.length - 1;
          return _PaymentMethodTile(
            method: method,
            isSelected: isSelected,
            isLast: isLast,
            onTap: () => onMethodSelected(method.id),
          );
        }),
      ),
    );
  }
}

class _PaymentMethod {
  final String id;
  final String label;
  final String? iconAsset;
  final Widget iconWidget;

  const _PaymentMethod({
    required this.id,
    required this.label,
    required this.iconAsset,
    required this.iconWidget,
  });
}

class _PaymentMethodTile extends StatelessWidget {
  final _PaymentMethod method;
  final bool isSelected;
  final bool isLast;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.method,
    required this.isSelected,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.purple.withOpacity(0.04)
              : Colors.transparent,
          borderRadius: isLast
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(14),
                  bottomRight: Radius.circular(14),
                )
              : null,
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  // Method icon
                  method.iconWidget,
                  const SizedBox(width: 14),

                  // Label
                  Expanded(
                    child: Text(
                      method.label,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.deepPurple,
                      ),
                    ),
                  ),

                  // Chevron or selected indicator
                  isSelected
                      ? Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: AppColors.purple,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded,
                              color: Colors.white, size: 14),
                        )
                      : const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.greyText,
                          size: 22,
                        ),
                ],
              ),
            ),
            if (!isLast)
              const Divider(
                height: 1,
                thickness: 1,
                indent: 54,
                endIndent: 14,
                color: Color(0xFFF0F0F0),
              ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Payment method icon widgets
// ─────────────────────────────────────────────────────────────────────────────

/// UPI icon — colorful "UPI" text pill
class _UpiIcon extends StatelessWidget {
  const _UpiIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'U',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1565C0),
                ),
              ),
              TextSpan(
                text: 'P',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2E7D32),
                ),
              ),
              TextSpan(
                text: 'I',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFE53935),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Credit/Debit Card icon
class _CardIcon extends StatelessWidget {
  const _CardIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.credit_card_rounded,
        color: Color(0xFFF57C00),
        size: 22,
      ),
    );
  }
}

/// Net Banking icon
class _NetBankingIcon extends StatelessWidget {
  const _NetBankingIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.account_balance_rounded,
        color: Color(0xFF2E7D32),
        size: 20,
      ),
    );
  }
}

/// Wallets icon
class _WalletIcon extends StatelessWidget {
  const _WalletIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(
        Icons.account_balance_wallet_rounded,
        color: Color(0xFFC62828),
        size: 20,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Pay Bar
// ─────────────────────────────────────────────────────────────────────────────
class _BottomPayBar extends StatelessWidget {
  final int totalAmount;
  final bool isProcessing;
  final VoidCallback onPay;

  const _BottomPayBar({
    required this.totalAmount,
    required this.isProcessing,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Total
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
                '₹$totalAmount',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepPurple,
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Pay Now button
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: isProcessing ? null : onPay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  disabledBackgroundColor:
                      AppColors.orange.withOpacity(0.6),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isProcessing
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
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
    );
  }
}
