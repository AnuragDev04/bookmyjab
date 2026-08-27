import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Expandable section state
  bool _notifExpanded   = false;
  bool _paymentExpanded = false;
  bool _supportExpanded = false;

  // Notification toggles
  final Map<String, bool> _notifToggles = {
    'Appointment Confirmation': true,
    'Payment Confirmation': true,
    'Appointment Reminders': true,
    'Service Status Updates': true,
    'Promotional Notifications': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Profile',
            style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.deepPurple)),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFF0F0F0)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // ── Profile card ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.purple.withOpacity(0.3),
                          width: 2),
                      color: AppColors.purple.withOpacity(0.08),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/profile.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.person_rounded,
                            size: 36,
                            color: AppColors.purple),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Riya Sharma',
                            style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepPurple)),
                        const SizedBox(height: 3),
                        Text('+91 98765 43210',
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.greyText,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.purple.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit_outlined,
                          color: AppColors.purple, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Menu card ────────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                children: [

                  // Simple rows
                  _SimpleRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Personal Information',
                    onTap: () {},
                    isFirst: true,
                  ),
                  _SimpleRow(
                    icon: Icons.medical_information_outlined,
                    label: 'Medical Records',
                    onTap: () {},
                  ),
                  _SimpleRow(
                    icon: Icons.location_on_outlined,
                    label: 'Saved Addresses',
                    onTap: () {},
                  ),

                  // ── Payment Methods (expandable) ──────────────────
                  _ExpandableRow(
                    icon: Icons.payment_outlined,
                    label: 'Payment Methods',
                    expanded: _paymentExpanded,
                    onTap: () => setState(
                        () => _paymentExpanded = !_paymentExpanded),
                    children: const [
                      _SubItem(
                          icon: Icons.lock_outline_rounded,
                          label: 'Secure Online Payment',
                          iconColor: Color(0xFF2E7D32)),
                      _SubItem(
                          icon: Icons.account_balance_wallet_outlined,
                          label: 'UPI',
                          iconColor: Color(0xFF1565C0)),
                      _SubItem(
                          icon: Icons.credit_card_rounded,
                          label: 'Credit / Debit Cards',
                          iconColor: AppColors.orange),
                      _SubItem(
                          icon: Icons.account_balance_outlined,
                          label: 'Net Banking',
                          iconColor: Color(0xFF2E7D32)),
                      _SubItem(
                          icon: Icons.wallet_rounded,
                          label: 'Digital Wallets',
                          iconColor: AppColors.purple),
                      _SubItem(
                          icon: Icons.check_circle_outline_rounded,
                          label: 'Payment Confirmation',
                          iconColor: AppColors.orange),
                      _SubItem(
                          icon: Icons.receipt_long_outlined,
                          label: 'Invoice Generation',
                          iconColor: AppColors.greyText),
                      _SubItem(
                          icon: Icons.history_rounded,
                          label: 'Payment History',
                          iconColor: AppColors.purple,
                          isLast: true),
                    ],
                  ),

                  // ── Notifications (expandable) ────────────────────
                  _ExpandableRow(
                    icon: Icons.notifications_outlined,
                    label: 'Notifications',
                    expanded: _notifExpanded,
                    onTap: () => setState(
                        () => _notifExpanded = !_notifExpanded),
                    children: _notifToggles.entries
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                      final idx   = entry.key;
                      final key   = entry.value.key;
                      final value = entry.value.value;
                      final isLast =
                          idx == _notifToggles.length - 1;
                      return _ToggleSubItem(
                        label: key,
                        value: value,
                        isLast: isLast,
                        onChanged: (v) =>
                            setState(() => _notifToggles[key] = v),
                      );
                    }).toList(),
                  ),

                  // ── Customer Support (expandable) ─────────────────
                  _ExpandableRow(
                    icon: Icons.headset_mic_outlined,
                    label: 'Customer Support',
                    expanded: _supportExpanded,
                    onTap: () => setState(
                        () => _supportExpanded = !_supportExpanded),
                    children: const [
                      _SubItem(
                          icon: Icons.chat_bubble_outline_rounded,
                          label: 'Contact Support',
                          iconColor: AppColors.purple),
                      _SubItem(
                          icon: Icons.call_outlined,
                          label: 'Call Support',
                          iconColor: Color(0xFF2E7D32)),
                      _SubItem(
                          icon: Icons.help_outline_rounded,
                          label: 'FAQ Section',
                          iconColor: AppColors.orange),
                      _SubItem(
                          icon: Icons.star_outline_rounded,
                          label: 'Feedback & Ratings',
                          iconColor: Color(0xFFFFC107),
                          isLast: true),
                    ],
                  ),

                  // Settings — last simple row
                  _SimpleRow(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () {},
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Logout button ────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout_rounded,
                    color: AppColors.alertColor, size: 20),
                label: Text('Logout',
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.alertColor)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: AppColors.alertColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 32),

            Text('Bookmyjab v1.0.0',
                style: GoogleFonts.poppins(
                    fontSize: 11, color: AppColors.greyText)),
            const SizedBox(height: 4),
            Text('Healthcare at Your Doorstep',
                style: GoogleFonts.poppins(
                    fontSize: 11, color: AppColors.greyText)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18)),
        title: Text('Logout',
            style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.deepPurple)),
        content: Text('Are you sure you want to logout?',
            style: GoogleFonts.poppins(
                fontSize: 13, color: AppColors.greyText)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: AppColors.greyText)),
          ),
          ElevatedButton(
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
              backgroundColor: AppColors.alertColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Logout',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Simple menu row
// ─────────────────────────────────────────────────────────────────────────────
class _SimpleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _SimpleRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.purple.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Icon(icon, color: AppColors.purple, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(label,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.deepPurple)),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.greyText, size: 22),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(
              height: 1,
              thickness: 1,
              indent: 68,
              color: Color(0xFFF5F5F5)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Expandable menu row with children
// ─────────────────────────────────────────────────────────────────────────────
class _ExpandableRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool expanded;
  final VoidCallback onTap;
  final List<Widget> children;

  const _ExpandableRow({
    required this.icon,
    required this.label,
    required this.expanded,
    required this.onTap,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
            height: 1,
            thickness: 1,
            indent: 68,
            color: Color(0xFFF5F5F5)),

        // Header
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.purple.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon,
                      color: AppColors.purple, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(label,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.deepPurple)),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.chevron_right_rounded,
                      color: AppColors.greyText, size: 22),
                ),
              ],
            ),
          ),
        ),

        // Expandable children
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          crossFadeState: expanded
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Container(
            margin: const EdgeInsets.only(
                left: 16, right: 16, bottom: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F5FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.purple.withOpacity(0.12)),
            ),
            child: Column(children: children),
          ),
          secondChild: const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-item (icon + label + chevron)
// ─────────────────────────────────────────────────────────────────────────────
class _SubItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final bool isLast;

  const _SubItem({
    required this.icon,
    required this.label,
    required this.iconColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      Icon(icon, size: 16, color: iconColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(label,
                      style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.deepPurple)),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: AppColors.greyText.withOpacity(0.6),
                    size: 18),
              ],
            ),
          ),
        ),
        if (!isLast)
          const Divider(
              height: 1,
              indent: 58,
              color: Color(0xFFEEEEEE)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Toggle sub-item (for notifications)
// ─────────────────────────────────────────────────────────────────────────────
class _ToggleSubItem extends StatelessWidget {
  final String label;
  final bool value;
  final bool isLast;
  final ValueChanged<bool> onChanged;

  const _ToggleSubItem({
    required this.label,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  value
                      ? Icons.notifications_active_outlined
                      : Icons.notifications_off_outlined,
                  size: 16,
                  color: value
                      ? AppColors.purple
                      : AppColors.greyText,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(label,
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.deepPurple)),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.purple,
                materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
              height: 1,
              indent: 58,
              color: Color(0xFFEEEEEE)),
      ],
    );
  }
}
