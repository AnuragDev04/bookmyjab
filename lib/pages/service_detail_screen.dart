import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'book_appointment_screen.dart';
import 'consent_screen.dart';
import 'nurse_detail_screen.dart';

class ServiceDetailScreen extends StatefulWidget {
  final String label;
  final String description;
  final IconData icon;
  final Color color;

  const ServiceDetailScreen({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
  });

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  bool _isFavourite = false;

  // Per-service metadata
  static const _meta = {
    'Home Nursing': _ServiceMeta(
      duration: '60 - 120 mins',
      price: '₹499 - ₹999',
      includes: [
        'Vital Signs Monitoring',
        'Medication Assistance',
        'Wound Care',
        'Personal Hygiene',
      ],
      fullDescription:
          'Professional nursing care at your home by verified and experienced nurses.',
    ),
    'Vaccination': _ServiceMeta(
      duration: '20 - 40 mins',
      price: '₹299 - ₹799',
      includes: [
        'All Age Group Vaccines',
        'Cold Chain Maintained',
        'Certified Nurses',
        'Post-vaccine Monitoring',
      ],
      fullDescription:
          'All age group vaccines administered at home by certified professionals.',
    ),
    'Patient Care': _ServiceMeta(
      duration: '60 - 180 mins',
      price: '₹599 - ₹1499',
      includes: [
        'Post Surgery Care',
        'Chronic Illness Support',
        'Dressing & IV Fluids',
        'Patient Mobility Aid',
      ],
      fullDescription:
          'Post surgery & chronic care at home by trained patient care specialists.',
    ),
    'Elder Care': _ServiceMeta(
      duration: '2 - 8 hrs',
      price: '₹499 - ₹1299',
      includes: [
        'Daily Activity Assistance',
        'Medication Reminders',
        'Companionship',
        'Health Monitoring',
      ],
      fullDescription:
          'Compassionate care for your loved ones provided by trained caregivers.',
    ),
    'Medical Assistance': _ServiceMeta(
      duration: '30 - 60 mins',
      price: '₹399 - ₹899',
      includes: [
        'Doctor Consultation',
        'Prescription Support',
        'Health Assessment',
        'Follow-up Care',
      ],
      fullDescription:
          'Doctor consultation and medical assistance at your doorstep.',
    ),
    'Physiotherapy': _ServiceMeta(
      duration: '45 - 90 mins',
      price: '₹499 - ₹999',
      includes: [
        'Pain Management',
        'Rehabilitation Exercises',
        'Mobility Training',
        'Electrotherapy',
      ],
      fullDescription:
          'Rehabilitation & pain management by certified physiotherapists at home.',
    ),
    'Lab Test': _ServiceMeta(
      duration: '15 - 30 mins',
      price: '₹199 - ₹1999',
      includes: [
        'Blood Sample Collection',
        'Urine & Stool Tests',
        'Reports in 24 hrs',
        'NABL Certified Labs',
      ],
      fullDescription:
          'Home sample collection with results delivered digitally within 24 hours.',
    ),
    'Emergency Care': _ServiceMeta(
      duration: '15 - 45 mins',
      price: '₹799 - ₹1999',
      includes: [
        'Immediate Response',
        'First Aid & Stabilisation',
        'ICU Trained Nurses',
        'Hospital Coordination',
      ],
      fullDescription:
          'Immediate care & assistance by ICU trained nurses available 24/7.',
    ),
  };

  _ServiceMeta get _info =>
      _meta[widget.label] ??
      const _ServiceMeta(
        duration: '30 - 60 mins',
        price: '₹499 - ₹999',
        includes: ['Professional Service', 'Certified Staff'],
        fullDescription: 'Quality healthcare at your doorstep.',
      );

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final info = _info;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero section ────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.deepPurple, size: 18),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() => _isFavourite = !_isFavourite);
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFavourite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: _isFavourite ? Colors.red : AppColors.greyText,
                        size: 20,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.color.withOpacity(0.15),
                          widget.color.withOpacity(0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Large faded icon background
                        Positioned(
                          right: -20,
                          top: 20,
                          child: Icon(
                            widget.icon,
                            size: 180,
                            color: widget.color.withOpacity(0.06),
                          ),
                        ),
                        // home_nurse image — fills hero fully, no crop
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/home_nurse.png',
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            errorBuilder: (_, __, ___) => Center(
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: widget.color.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(widget.icon,
                                    size: 60, color: widget.color),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Content ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + rating row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.label,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.deepPurple,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: Color(0xFFFFC107), size: 18),
                                const SizedBox(width: 3),
                                Text(
                                  '4.8 (1300+)',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          info.fullDescription,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.greyText,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Duration & Price row
                        Row(
                          children: [
                            _InfoTile(
                              icon: Icons.timer_outlined,
                              label: 'Duration',
                              value: info.duration,
                              color: widget.color,
                            ),
                            const SizedBox(width: 12),
                            _InfoTile(
                              icon: Icons.currency_rupee_rounded,
                              label: 'Price',
                              value: info.price,
                              color: widget.color,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Includes
                        Text(
                          'Includes',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...info.includes.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2E7D32).withOpacity(0.10),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.check_rounded,
                                        size: 14, color: Color(0xFF2E7D32)),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    item,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      color: AppColors.deepPurple,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 24),

                        // Available Nurses
                        Text(
                          'Available Nurses',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _AvailableNurses(color: widget.color),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Book Appointment button (pinned bottom) ─────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
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
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookAppointmentScreen(services: [],
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
                    'Book Appointment',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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

// ── Info Tile ─────────────────────────────────────────────────────────────────
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.20)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.greyText,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepPurple,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Available Nurses ──────────────────────────────────────────────────────────
class _AvailableNurses extends StatelessWidget {
  final Color color;
  const _AvailableNurses({required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 4 overlapping avatars
        SizedBox(
          width: 130,
          height: 48,
          child: Stack(
            children: List.generate(4, (i) {
              return Positioned(
                left: i * 28.0,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NurseDetailScreen(
                        name: const ['Priya Sharma', 'Anjali Verma', 'Meena Rao', 'Sunita Joshi'][i],
                        role: 'Staff Nurse',
                        rating: const ['4.8', '4.6', '4.7', '4.9'][i],
                        reviews: const ['120', '98', '110', '145'][i],
                        experience: const ['5 Years', '3 Years', '4 Years', '7 Years'][i],
                        distance: '1.2 km away',
                      ),
                    ),
                  ),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      color: color.withOpacity(0.12),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/nurse.png',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.person_rounded,
                          size: 24,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 4),
        // +12 badge
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.12),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Center(
            child: Text(
              '+12',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Service metadata ──────────────────────────────────────────────────────────
class _ServiceMeta {
  final String duration;
  final String price;
  final List<String> includes;
  final String fullDescription;
  const _ServiceMeta({
    required this.duration,
    required this.price,
    required this.includes,
    required this.fullDescription,
  });
}
