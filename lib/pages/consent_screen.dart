import 'package:bookmyjab/pages/confirm_booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'prescription_screen.dart';

class ConsentScreen extends StatefulWidget {
  final String serviceName;
  final String servicePrice;

  const ConsentScreen({
    super.key,
    required this.serviceName,
    required this.servicePrice,
  });

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  bool _consentAccepted = false;

  static const _items = [
    _ConsentItem(
      icon: Icons.shield_outlined,
      title: 'Medical Declaration',
      body:
          'I confirm that the medical information provided is accurate and complete, '
          'including allergies, fever, illness, pregnancy status, prior vaccine reactions, '
          'chronic conditions and current medication.',
      linkText: 'View full declaration',
    ),
    _ConsentItem(
      icon: Icons.vaccines_outlined,
      title: 'Vaccination Consent',
      body:
          'I understand that vaccination is a medical procedure. Common side effects may occur, '
          'and rare serious adverse events are possible even when proper care is followed.',
      linkText: 'View full consent',
    ),
    _ConsentItem(
      icon: Icons.local_shipping_outlined,
      title: 'Procurement Authorisation',
      body:
          'I authorise BookMyJab to facilitate procurement and administration of the selected '
          'vaccine through authorised medical/pharmacy partners and qualified healthcare personnel.',
      linkText: 'View authorisation',
    ),
    _ConsentItem(
      icon: Icons.lock_outline_rounded,
      title: 'Privacy & Data Consent',
      body:
          'I consent to the collection and processing of my personal and health data solely '
          'for the purpose of delivering this service, in accordance with applicable privacy laws.',
      linkText: 'View privacy policy',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Step progress: 6 of 7 (matches screenshot)
    const totalSteps = 7;
    const currentStep = 6;

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Book ${widget.serviceName}',
              style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.deepPurple),
            ),
            Text(
              'Step $currentStep of $totalSteps',
              style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.greyText,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.orange.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.verified_user_outlined,
                  color: AppColors.orange, size: 20),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: Stack(
            children: [
              // Track
              Container(height: 5, color: const Color(0xFFEEEEEE)),
              // Fill
              FractionallySizedBox(
                widthFactor: currentStep / totalSteps,
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
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Heading ────────────────────────────────────────
                  Text(
                    'Consent & Safety Review',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepPurple,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Before we confirm your ${widget.serviceName.toLowerCase()} booking, '
                    'please review and accept the key medical, privacy and service terms.',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: AppColors.greyText,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Consent cards (no individual checkboxes) ──────
                  ...List.generate(_items.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _ConsentCard(item: _items[i]),
                    );
                  }),

                  // ── Single consent checkbox card ───────────────────
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0EDF8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _consentAccepted
                            ? AppColors.orange.withOpacity(0.5)
                            : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Square checkbox
                          GestureDetector(
                            onTap: () => setState(
                                () => _consentAccepted = !_consentAccepted),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: _consentAccepted
                                      ? AppColors.orange
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: _consentAccepted
                                        ? AppColors.orange
                                        : const Color(0xFFCCCCCC),
                                    width: 2,
                                  ),
                                ),
                                child: _consentAccepted
                                    ? const Icon(Icons.check_rounded,
                                        color: Colors.white, size: 14)
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Consent text
                          Expanded(
                            child: Text(
                              'I have read and understood BookMyJab\'s Terms & Conditions, Privacy Notice, Refund Policy, Medical Declaration and Vaccination Consent. I explicitly consent to BookMyJab facilitating procurement and administration of the selected vaccine through authorised medical/pharmacy partners and qualified healthcare personnel, subject to doctor/nurse approval, vaccine availability, cold-chain integrity and applicable law. I confirm that all medical information provided is true and complete, and I consent to processing of personal and health data for this booking.',
                              style: GoogleFonts.poppins(
                                fontSize: 12.5,
                                color: AppColors.greyText,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // ── Bottom CTA ─────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
            child: Column(
              children: [
                // Helper text when not all accepted
                if (!_consentAccepted)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline_rounded,
                            size: 14, color: AppColors.greyText),
                        const SizedBox(width: 6),
                        Text(
                          'Please accept the consent to continue',
                          style: GoogleFonts.poppins(
                              fontSize: 11, color: AppColors.greyText),
                        ),
                      ],
                    ),
                  ),

                // Confirm & Proceed button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _consentAccepted
                        ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ConfirmBookingScreen(
                                  serviceName: widget.serviceName,
                                  servicePrice: widget.servicePrice, selectedDate: '', selectedTime: '', address: '',
                                ),
                              ),
                            )
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      disabledBackgroundColor:
                          AppColors.orange.withOpacity(0.35),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: _consentAccepted ? 4 : 0,
                      shadowColor: AppColors.orange.withOpacity(0.4),
                    ),
                    child: Text(
                      'Confirm & Proceed',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
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

// ── Consent card (no individual checkbox) ────────────────────────────────────
class _ConsentCard extends StatelessWidget {
  final _ConsentItem item;

  const _ConsentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon + title row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.orange.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(item.icon, color: AppColors.orange, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      item.title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepPurple,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Body text
            Text(
              item.body,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.greyText,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 10),

            // View link
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.linkText,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.orange,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded,
                      color: AppColors.orange, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────
class _ConsentItem {
  final IconData icon;
  final String title;
  final String body;
  final String linkText;

  const _ConsentItem({
    required this.icon,
    required this.title,
    required this.body,
    required this.linkText,
  });
}
