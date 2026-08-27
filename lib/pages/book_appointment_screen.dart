import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'select_address_screen.dart';

class BookAppointmentScreen extends StatefulWidget {
  final String serviceName;
  final String servicePrice;

  const BookAppointmentScreen({
    super.key,
    required this.serviceName,
    required this.servicePrice,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;
  String? _selectedTime;
  String? _selectedNurse;

  // ── Static data ────────────────────────────────────────────────────────────
  static const _timeSlots = [
    '09:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '02:00 PM', '03:00 PM',
    '04:00 PM', '05:00 PM', '06:00 PM',
  ];

  static const _nurses = [
    _NurseOption('Priya Sharma',  '5 Yrs Exp · 4.8 ★', 'assets/images/nurse.png'),
    _NurseOption('Anjali Verma',  '3 Yrs Exp · 4.6 ★', 'assets/images/nurse.png'),
    _NurseOption('Meena Rao',     '4 Yrs Exp · 4.7 ★', 'assets/images/nurse.png'),
    _NurseOption('Sunita Joshi',  '7 Yrs Exp · 4.9 ★', 'assets/images/nurse.png'),
    _NurseOption('Rekha Pillai',  '6 Yrs Exp · 4.8 ★', 'assets/images/nurse.png'),
  ];

  static const _weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  // ── Calendar helpers ───────────────────────────────────────────────────────
  List<DateTime?> _buildCalendarDays() {
    final first = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final last  = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    final List<DateTime?> days = [];
    for (int i = 0; i < first.weekday % 7; i++) days.add(null);
    for (int i = 1; i <= last.day; i++) {
      days.add(DateTime(_focusedMonth.year, _focusedMonth.month, i));
    }
    // pad trailing to complete the last row
    while (days.length % 7 != 0) days.add(null);
    return days;
  }

  String get _monthLabel {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[_focusedMonth.month]} ${_focusedMonth.year}';
  }

  // ── Formatted selected date ────────────────────────────────────────────────
  String get _formattedDate {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${_selectedDate.day} ${months[_selectedDate.month]} ${_selectedDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    final calDays = _buildCalendarDays();
    final today   = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

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
        title: Text('Book Appointment',
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
          // ── Step indicator ───────────────────────────────────────────
          _StepIndicator(currentStep: 1),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── 1. Selected service card ───────────────────────
                  _ServiceSummaryCard(
                    serviceName: widget.serviceName,
                    servicePrice: widget.servicePrice,
                  ),
                  const SizedBox(height: 20),

                  // ── 2. Calendar ────────────────────────────────────
                  _SectionLabel(label: 'Select Date'),
                  const SizedBox(height: 10),
                  _CalendarCard(
                    focusedMonth: _focusedMonth,
                    selectedDate: _selectedDate,
                    monthLabel: _monthLabel,
                    calDays: calDays,
                    today: today,
                    weekDays: _weekDays,
                    onPrevMonth: () => setState(() {
                      _focusedMonth = DateTime(
                          _focusedMonth.year, _focusedMonth.month - 1);
                    }),
                    onNextMonth: () => setState(() {
                      _focusedMonth = DateTime(
                          _focusedMonth.year, _focusedMonth.month + 1);
                    }),
                    onDayTap: (day) => setState(() => _selectedDate = day),
                  ),
                  const SizedBox(height: 20),

                  // ── 3. Time slots ──────────────────────────────────
                  _SectionLabel(label: 'Select Time'),
                  const SizedBox(height: 10),
                  _TimeSlotGrid(
                    slots: _timeSlots,
                    selected: _selectedTime,
                    onSelect: (t) => setState(() => _selectedTime = t),
                  ),
                  const SizedBox(height: 20),

                  // ── 4. Nurse dropdown ──────────────────────────────
                  _SectionLabel(label: 'Select Nurse'),
                  const SizedBox(height: 10),
                  _NurseDropdown(
                    nurses: _nurses,
                    selected: _selectedNurse,
                    onSelect: (n) => setState(() => _selectedNurse = n),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // ── Next button ──────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 12,
                  offset: Offset(0, -3),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _selectedTime == null
                    ? null
                    : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SelectAddressScreen(
                              serviceName: widget.serviceName,
                              servicePrice: widget.servicePrice,
                              selectedDate: _formattedDate,
                              selectedTime: _selectedTime!,
                            ),
                          ),
                        ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  disabledBackgroundColor:
                      AppColors.orange.withOpacity(0.4),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Next',
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

// ─────────────────────────────────────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.deepPurple));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Selected service summary card
// ─────────────────────────────────────────────────────────────────────────────
class _ServiceSummaryCard extends StatelessWidget {
  final String serviceName;
  final String servicePrice;
  const _ServiceSummaryCard(
      {required this.serviceName, required this.servicePrice});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.purple.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medical_services_outlined,
                color: AppColors.purple, size: 24),
          ),
          const SizedBox(width: 12),
          // Name & label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selected Service',
                    style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.greyText,
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 2),
                Text(serviceName,
                    style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepPurple)),
              ],
            ),
          ),
          // Price badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.orange.withOpacity(0.10),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(servicePrice,
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.orange)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Improved Calendar Card
// ─────────────────────────────────────────────────────────────────────────────
class _CalendarCard extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final DateTime today;
  final String monthLabel;
  final List<DateTime?> calDays;
  final List<String> weekDays;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<DateTime> onDayTap;

  const _CalendarCard({
    required this.focusedMonth,
    required this.selectedDate,
    required this.today,
    required this.monthLabel,
    required this.calDays,
    required this.weekDays,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
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
          // ── Month navigation ──────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavButton(icon: Icons.chevron_left_rounded, onTap: onPrevMonth),
              Text(monthLabel,
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepPurple)),
              _NavButton(icon: Icons.chevron_right_rounded, onTap: onNextMonth),
            ],
          ),
          const SizedBox(height: 14),

          // ── Weekday headers ───────────────────────────────────────
          Row(
            children: weekDays.map((d) {
              final isSun = d == 'Sun';
              final isSat = d == 'Sat';
              return Expanded(
                child: Center(
                  child: Text(d,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: (isSun || isSat)
                              ? AppColors.orange.withOpacity(0.8)
                              : AppColors.greyText)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // ── Day cells ─────────────────────────────────────────────
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 0,
              childAspectRatio: 1,
            ),
            itemCount: calDays.length,
            itemBuilder: (_, i) {
              final day = calDays[i];
              if (day == null) return const SizedBox();

              final isSelected = day.year == selectedDate.year &&
                  day.month == selectedDate.month &&
                  day.day == selectedDate.day;
              final isToday = day.year == today.year &&
                  day.month == today.month &&
                  day.day == today.day;
              final isPast = day.isBefore(today);
              // weekend columns
              final col = i % 7;
              final isWeekend = col == 0 || col == 6;

              return GestureDetector(
                onTap: isPast ? null : () => onDayTap(day),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.purple
                        : isToday
                            ? AppColors.orange.withOpacity(0.12)
                            : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isToday && !isSelected
                        ? Border.all(
                            color: AppColors.orange, width: 1.5)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: isSelected || isToday
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isSelected
                            ? Colors.white
                            : isPast
                                ? const Color(0xFFCCCCCC)
                                : isWeekend
                                    ? AppColors.orange
                                    : AppColors.deepPurple,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// small icon button for prev/next month
class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.purple.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.deepPurple, size: 22),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Time slot grid
// ─────────────────────────────────────────────────────────────────────────────
class _TimeSlotGrid extends StatelessWidget {
  final List<String> slots;
  final String? selected;
  final ValueChanged<String> onSelect;
  const _TimeSlotGrid(
      {required this.slots,
      required this.selected,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.6,
      ),
      itemCount: slots.length,
      itemBuilder: (_, i) {
        final t = slots[i];
        final sel = selected == t;
        return GestureDetector(
          onTap: () => onSelect(t),
          child: Container(
            decoration: BoxDecoration(
              color: sel ? AppColors.purple : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: sel
                    ? AppColors.purple
                    : const Color(0xFFE0E0E0),
              ),
              boxShadow: sel
                  ? [
                      BoxShadow(
                          color: AppColors.purple.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ]
                  : [],
            ),
            child: Center(
              child: Text(t,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: sel
                          ? Colors.white
                          : AppColors.deepPurple)),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Nurse dropdown
// ─────────────────────────────────────────────────────────────────────────────
class _NurseDropdown extends StatefulWidget {
  final List<_NurseOption> nurses;
  final String? selected;
  final ValueChanged<String> onSelect;

  const _NurseDropdown({
    required this.nurses,
    required this.selected,
    required this.onSelect,
  });

  @override
  State<_NurseDropdown> createState() => _NurseDropdownState();
}

class _NurseDropdownState extends State<_NurseDropdown> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.nurses
        .cast<_NurseOption?>()
        .firstWhere((n) => n!.name == widget.selected, orElse: () => null);

    return Column(
      children: [
        // ── Trigger ──────────────────────────────────────────────────
        GestureDetector(
          onTap: () => setState(() => _open = !_open),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: _open
                  ? const BorderRadius.vertical(top: Radius.circular(14))
                  : BorderRadius.circular(14),
              border: Border.all(
                  color: _open
                      ? AppColors.purple
                      : const Color(0xFFE0E0E0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Row(
              children: [
                // Avatar or placeholder
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.purple.withOpacity(0.10),
                  ),
                  child: selected != null
                      ? ClipOval(
                          child: Image.asset(
                            selected.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.person_rounded,
                                size: 22,
                                color: AppColors.purple),
                          ),
                        )
                      : const Icon(Icons.person_outline_rounded,
                          size: 22, color: AppColors.purple),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selected != null
                            ? selected.name
                            : 'Choose a Nurse',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: selected != null
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: selected != null
                              ? AppColors.deepPurple
                              : AppColors.greyText,
                        ),
                      ),
                      if (selected != null) ...[
                        const SizedBox(height: 1),
                        Text(selected.meta,
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.greyText)),
                      ],
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down_rounded,
                      color: AppColors.deepPurple, size: 22),
                ),
              ],
            ),
          ),
        ),

        // ── Options list ──────────────────────────────────────────────
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 200),
          crossFadeState: _open
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(14)),
              border: Border.all(color: AppColors.purple),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              children: widget.nurses.asMap().entries.map((entry) {
                final i = entry.key;
                final nurse = entry.value;
                final isSelected = widget.selected == nurse.name;
                final isLast = i == widget.nurses.length - 1;

                return GestureDetector(
                  onTap: () {
                    widget.onSelect(nurse.name);
                    setState(() => _open = false);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        color: isSelected
                            ? AppColors.purple.withOpacity(0.05)
                            : Colors.transparent,
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.purple.withOpacity(0.10),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  nurse.imagePath,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.person_rounded,
                                          size: 22,
                                          color: AppColors.purple),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(nurse.name,
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.deepPurple)),
                                  Text(nurse.meta,
                                      style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: AppColors.greyText)),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle_rounded,
                                  color: AppColors.purple, size: 18),
                          ],
                        ),
                      ),
                      if (!isLast)
                        const Divider(
                            height: 1,
                            indent: 64,
                            endIndent: 14,
                            color: Color(0xFFF0F0F0)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          secondChild: const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

// ── Nurse option model ────────────────────────────────────────────────────────
class _NurseOption {
  final String name;
  final String meta;
  final String imagePath;
  const _NurseOption(this.name, this.meta, this.imagePath);
}

// ─────────────────────────────────────────────────────────────────────────────
// Step Indicator  (active step → orange)
// ─────────────────────────────────────────────────────────────────────────────
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
                color: done ? AppColors.purple : const Color(0xFFE0E0E0),
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final done   = stepIndex < currentStep;
          final active = stepIndex == currentStep;

          // active → orange background; done → purple; future → grey
          final bgColor = active
              ? AppColors.orange
              : done
                  ? AppColors.purple
                  : const Color(0xFFE0E0E0);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: bgColor,
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
