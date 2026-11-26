import 'package:bookmyjab/pages/select_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/selected_service.dart';
import '../utils/colors.dart';

class BookAppointmentScreen extends StatefulWidget {
  final List<SelectedService> services;

  const BookAppointmentScreen({
    super.key,
    required this.services,
  });

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  // Per-service selections: index → (date, time)
  late final List<DateTime> _selectedDates;
  late final List<String?> _selectedTimes;

  // Shared focusedMonth per service
  late final List<DateTime> _focusedMonths;

  // Which service card is expanded (showing calendar+time)
  int _expandedIndex = 0;

  static const _timeSlots = [
    '09:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '02:00 PM', '03:00 PM',
    '04:00 PM', '05:00 PM', '06:00 PM',
  ];
  static const _weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _selectedDates  = List.generate(widget.services.length, (_) => today);
    _selectedTimes  = List.generate(widget.services.length, (_) => null);
    _focusedMonths  = List.generate(
        widget.services.length, (_) => DateTime(now.year, now.month));
  }

  bool get _allSelected => _selectedTimes.every((t) => t != null);

  String _formattedDate(DateTime d) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${months[d.month]} ${d.year}';
  }

  String _monthLabel(DateTime d) {
    const months = ['', 'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[d.month]} ${d.year}';
  }

  List<DateTime?> _buildCalendarDays(DateTime focused) {
    final first = DateTime(focused.year, focused.month, 1);
    final last  = DateTime(focused.year, focused.month + 1, 0);
    final List<DateTime?> days = [];
    for (int i = 0; i < first.weekday % 7; i++) days.add(null);
    for (int i = 1; i <= last.day; i++) {
      days.add(DateTime(focused.year, focused.month, i));
    }
    while (days.length % 7 != 0) days.add(null);
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);

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
            Text('Book Appointment',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepPurple)),
            Text('Step 1 of 7',
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.greyText,
                    fontWeight: FontWeight.w400)),
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
              child: const Icon(Icons.calendar_today_outlined,
                  color: AppColors.orange, size: 18),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: Stack(
            children: [
              Container(height: 5, color: const Color(0xFFEEEEEE)),
              FractionallySizedBox(
                widthFactor: 1 / 7,
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
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Heading ──────────────────────────────────────────
                  Text(
                    'Select Date & Time',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepPurple,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pick a date and time slot for each selected service.',
                    style: GoogleFonts.poppins(
                        fontSize: 12, color: AppColors.greyText, height: 1.5),
                  ),
                  const SizedBox(height: 20),

                  // ── Per-service accordion cards ───────────────────────
                  ...List.generate(widget.services.length, (i) {
                    final svc      = widget.services[i];
                    final isOpen   = _expandedIndex == i;
                    final hasTime  = _selectedTimes[i] != null;
                    final calDays  = _buildCalendarDays(_focusedMonths[i]);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isOpen
                                ? AppColors.purple.withOpacity(0.5)
                                : hasTime
                                    ? AppColors.orange.withOpacity(0.4)
                                    : const Color(0xFFEEEEEE),
                            width: isOpen ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [

                            // ── Service header row ──────────────────
                            GestureDetector(
                              onTap: () => setState(() =>
                                  _expandedIndex = isOpen ? -1 : i),
                              child: Padding(
                                padding: const EdgeInsets.all(14),
                                child: Row(
                                  children: [
                                    // Service icon
                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: AppColors.purple
                                            .withOpacity(0.10),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                          Icons.medical_services_outlined,
                                          color: AppColors.purple,
                                          size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    // Name + price + qty
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(svc.title,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      AppColors.deepPurple)),
                                          const SizedBox(height: 3),
                                          Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 8,
                                                    vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: AppColors.orange
                                                      .withOpacity(0.10),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20),
                                                ),
                                                child: Text(
                                                  svc.priceLabel,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w700,
                                                    color: AppColors.orange,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text('Qty: ${svc.qty}',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 11,
                                                      color:
                                                          AppColors.greyText)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Status / chevron
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (hasTime)
                                          Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 8, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE8F5E9),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              '✓ Set',
                                              style: GoogleFonts.poppins(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color: const Color(
                                                      0xFF2E7D32)),
                                            ),
                                          ),
                                        const SizedBox(height: 4),
                                        AnimatedRotation(
                                          turns: isOpen ? 0.5 : 0,
                                          duration: const Duration(
                                              milliseconds: 200),
                                          child: const Icon(
                                              Icons
                                                  .keyboard_arrow_down_rounded,
                                              color: AppColors.greyText,
                                              size: 20),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // ── Selected summary (when collapsed + set) ─
                            if (!isOpen && hasTime) ...[
                              const Divider(
                                  height: 1, color: Color(0xFFF5F5F5)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                child: Row(
                                  children: [
                                    const Icon(
                                        Icons.calendar_today_rounded,
                                        size: 13,
                                        color: AppColors.purple),
                                    const SizedBox(width: 6),
                                    Text(
                                      _formattedDate(_selectedDates[i]),
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.deepPurple),
                                    ),
                                    const SizedBox(width: 14),
                                    const Icon(Icons.access_time_rounded,
                                        size: 13,
                                        color: AppColors.orange),
                                    const SizedBox(width: 6),
                                    Text(
                                      _selectedTimes[i]!,
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.deepPurple),
                                    ),
                                  ],
                                ),
                              ),
                            ],

                            // ── Expanded: calendar + time slots ────────
                            if (isOpen) ...[
                              const Divider(
                                  height: 1, color: Color(0xFFF0F0F0)),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    14, 14, 14, 14),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [

                                    // Calendar
                                    Text('Select Date',
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.deepPurple)),
                                    const SizedBox(height: 10),
                                    _CalendarCard(
                                      focusedMonth: _focusedMonths[i],
                                      selectedDate: _selectedDates[i],
                                      today: today,
                                      monthLabel:
                                          _monthLabel(_focusedMonths[i]),
                                      calDays: calDays,
                                      weekDays: _weekDays,
                                      onPrevMonth: () => setState(() {
                                        _focusedMonths[i] = DateTime(
                                            _focusedMonths[i].year,
                                            _focusedMonths[i].month - 1);
                                      }),
                                      onNextMonth: () => setState(() {
                                        _focusedMonths[i] = DateTime(
                                            _focusedMonths[i].year,
                                            _focusedMonths[i].month + 1);
                                      }),
                                      onDayTap: (day) => setState(() {
                                        _selectedDates[i] = day;
                                        _selectedTimes[i] = null;
                                      }),
                                    ),
                                    const SizedBox(height: 16),

                                    // Time slots
                                    Text('Select Time',
                                        style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.deepPurple)),
                                    const SizedBox(height: 10),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        childAspectRatio: 2.6,
                                      ),
                                      itemCount: _timeSlots.length,
                                      itemBuilder: (_, ti) {
                                        final t = _timeSlots[ti];
                                        final sel = _selectedTimes[i] == t;
                                        return GestureDetector(
                                          onTap: () => setState(() {
                                            _selectedTimes[i] = t;
                                            // auto-collapse after picking
                                            if (i < widget.services.length - 1) {
                                              _expandedIndex = i + 1;
                                            } else {
                                              _expandedIndex = -1;
                                            }
                                          }),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: sel
                                                  ? AppColors.purple
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: sel
                                                    ? AppColors.purple
                                                    : const Color(
                                                        0xFFE0E0E0),
                                              ),
                                              boxShadow: sel
                                                  ? [
                                                      BoxShadow(
                                                          color: AppColors
                                                              .purple
                                                              .withOpacity(
                                                                  0.25),
                                                          blurRadius: 8,
                                                          offset: const Offset(
                                                              0, 3))
                                                    ]
                                                  : [],
                                            ),
                                            child: Center(
                                              child: Text(t,
                                                  style:
                                                      GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    color: sel
                                                        ? Colors.white
                                                        : AppColors
                                                            .deepPurple,
                                                  )),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),

                  // ── Administration Charge card ────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: AppColors.purple.withOpacity(0.25),
                          width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Purple circle check icon
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: AppColors.deepPurple,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded,
                              color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        // Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Administration Charge',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepPurple,
                                ),
                              ),
                              const SizedBox(height: 2),
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppColors.greyText,
                                  ),
                                  children: const [
                                    TextSpan(
                                        text:
                                            'Nurse visit + administration at home  '),
                                    TextSpan(
                                      text: '(mandatory)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Price + qty
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '₹299 / vaccination',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '× 1',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.greyText,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // ── Next button ────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20)),
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
                onPressed: _allSelected
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SelectAddressScreen(
                              serviceName: widget.services
                                  .map((s) => s.title)
                                  .join(', '),
                              servicePrice:
                                  '₹${widget.services.fold(0, (sum, s) => sum + s.mrp * s.qty)}',
                              selectedDate: _formattedDate(_selectedDates[0]),
                              selectedTime: _selectedTimes[0] ?? '',
                            ),
                          ),
                        )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  disabledBackgroundColor:
                      AppColors.orange.withOpacity(0.4),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  _allSelected
                      ? 'Next'
                      : 'Select time for all services',
                  style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
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
// Calendar Card
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
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F8FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _NavButton(
                  icon: Icons.chevron_left_rounded, onTap: onPrevMonth),
              Text(monthLabel,
                  style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepPurple)),
              _NavButton(
                  icon: Icons.chevron_right_rounded, onTap: onNextMonth),
            ],
          ),
          const SizedBox(height: 10),

          // Weekday headers
          Row(
            children: weekDays.map((d) {
              final isWeekend = d == 'Sun' || d == 'Sat';
              return Expanded(
                child: Center(
                  child: Text(d,
                      style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isWeekend
                              ? AppColors.orange.withOpacity(0.8)
                              : AppColors.greyText)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 6),

          // Days grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 2,
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
              final isWeekend = i % 7 == 0 || i % 7 == 6;

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
                        ? Border.all(color: AppColors.orange, width: 1.5)
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
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

// Nav button
class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: AppColors.purple.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.deepPurple, size: 20),
      ),
    );
  }
}
