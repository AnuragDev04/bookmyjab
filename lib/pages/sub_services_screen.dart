import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'service_detail_screen.dart';

class SubServicesScreen extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final Color color;

  const SubServicesScreen({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.color,
  });

  // Sub-service data per parent service
  static const Map<String, List<_SubService>> _subServices = {
    'Home Nursing': [
      _SubService('Basic Nursing Care',   'Vital signs & daily monitoring',     Icons.monitor_heart_outlined,    699),
      _SubService('Post-Op Care',         'After surgery recovery at home',      Icons.healing_outlined,          1299),
      _SubService('Wound Dressing',       'Professional wound management',       Icons.medical_services_outlined, 499),
      _SubService('IV & Injections',      'IV fluids and medication shots',      Icons.vaccines_outlined,         399),
      _SubService('Catheter Care',        'Catheter management at home',         Icons.water_drop_outlined,       599),
      _SubService('Bed Bath',             'Hygiene & personal care',             Icons.bathtub_outlined,          349),
    ],
    'Vaccination': [
      _SubService('Child Vaccines',       'For infants and children',            Icons.child_care_outlined,       299),
      _SubService('Adult Vaccines',       'For teenagers and adults',            Icons.person_outlined,           399),
      _SubService('Travel Vaccines',      'Stay protected while you travel',     Icons.flight_outlined,           799),
      _SubService('Specialty Vaccines',   'For specific health conditions',      Icons.science_outlined,          899),
      _SubService('Annual Flu Shot',      'Seasonal influenza protection',       Icons.vaccines_outlined,         249),
      _SubService('COVID Booster',        'Booster doses at home',               Icons.add_circle_outline,        199),
    ],
    'Patient Care': [
      _SubService('Post Surgery',         'Recovery support after surgery',      Icons.local_hospital_outlined,   1499),
      _SubService('Chronic Care',         'Long-term illness management',        Icons.favorite_outline,          999),
      _SubService('Elderly Patient',      'Special care for senior patients',    Icons.elderly_outlined,          799),
      _SubService('Palliative Care',      'Comfort & pain management',           Icons.spa_outlined,              1199),
      _SubService('ICU Support',          'Critical care at home',               Icons.monitor_outlined,          1999),
      _SubService('Physiotherapy',        'Rehab exercises at home',             Icons.accessibility_new_outlined,699),
    ],
    'Elder Care': [
      _SubService('Daily Assistance',     'Help with daily activities',          Icons.handshake_outlined,        599),
      _SubService('Companion Care',       'Social support & companionship',      Icons.people_outline,            499),
      _SubService('Dementia Care',        'Specialised memory care',             Icons.psychology_outlined,       1299),
      _SubService('Medication Help',      'Timely medicine reminders',           Icons.medication_outlined,       299),
      _SubService('Mobility Aid',         'Support for movement & posture',      Icons.accessible_outlined,       449),
      _SubService('Night Care',           'Overnight care assistance',           Icons.nights_stay_outlined,      999),
    ],
    'Medical Assistance': [
      _SubService('Doctor Visit',         'Certified doctor at home',            Icons.local_hospital_outlined,   799),
      _SubService('Health Check-up',      'Complete health assessment',          Icons.health_and_safety_outlined,1199),
      _SubService('Prescription',         'Prescription review & support',       Icons.description_outlined,      299),
      _SubService('Follow-up Care',       'Post-treatment monitoring',           Icons.track_changes_outlined,    499),
      _SubService('ECG at Home',          'Cardiac health monitoring',           Icons.monitor_heart_outlined,    699),
      _SubService('Blood Pressure',       'BP monitoring at home',               Icons.bloodtype_outlined,        199),
    ],
    'Physiotherapy': [
      _SubService('Orthopaedic',          'Joint & bone rehabilitation',         Icons.accessibility_new_outlined,899),
      _SubService('Neurological',         'Stroke & nerve rehab',                Icons.psychology_outlined,       1099),
      _SubService('Sports Injury',        'Athlete injury recovery',             Icons.sports_outlined,           799),
      _SubService('Back & Spine',         'Posture & spine treatment',           Icons.airline_seat_flat_outlined,699),
      _SubService('Paediatric',           'Physio for children',                 Icons.child_care_outlined,       599),
      _SubService('Electrotherapy',       'Pain relief using electrical stim',   Icons.flash_on_outlined,         499),
    ],
    'Lab Test': [
      _SubService('Blood Test',           'Complete blood count & more',         Icons.bloodtype_outlined,        399),
      _SubService('Urine Test',           'Urinalysis at home',                  Icons.water_drop_outlined,       199),
      _SubService('HbA1c / Sugar',        'Diabetes monitoring',                 Icons.monitor_heart_outlined,    299),
      _SubService('Thyroid Panel',        'T3, T4 & TSH tests',                  Icons.science_outlined,          599),
      _SubService('Lipid Profile',        'Cholesterol & triglycerides',         Icons.favorite_outline,          499),
      _SubService('Covid / Swab Test',    'Rapid & RT-PCR tests',                Icons.coronavirus_outlined,      349),
    ],
    'Emergency Care': [
      _SubService('First Aid',            'Immediate first aid response',        Icons.medical_services_outlined, 299),
      _SubService('Ambulance Support',    'Coordination with ambulance',         Icons.local_taxi_outlined,       499),
      _SubService('ICU Nurse',            'Critical care trained nurses',        Icons.monitor_outlined,          1999),
      _SubService('24/7 Response',        'Round the clock availability',        Icons.access_alarm_outlined,     999),
      _SubService('Cardiac Emergency',    'Heart attack response care',          Icons.favorite_outline,          1499),
      _SubService('Fracture Care',        'Splinting & fracture management',     Icons.health_and_safety_outlined,699),
    ],
  };

  List<_SubService> get _items =>
      _subServices[label] ??
      [
        _SubService('General Service', 'Standard home healthcare', Icons.home_outlined,    699),
        _SubService('Custom Care',     'Tailored to your needs',   Icons.settings_outlined, 499),
      ];

  // Hero banner subtitle per service
  static const Map<String, List<String>> _bannerText = {
    'Vaccination': ['Stay Protected,\nStay Healthy', 'Safe & trusted vaccines for you and your family.'],
    'Home Nursing': ['Care at Your\nDoorstep', 'Professional nursing care from the comfort of home.'],
    'Patient Care': ['Healing at\nHome', 'Expert patient care tailored to your recovery needs.'],
    'Elder Care': ['Love &\nCompassion', 'Dedicated care for your elderly loved ones at home.'],
    'Medical Assistance': ['Doctors\nAt Home', 'Certified doctors available whenever you need them.'],
    'Physiotherapy': ['Move Better,\nFeel Better', 'Expert physiotherapy in the comfort of your home.'],
    'Lab Test': ['Tests at\nYour Home', 'NABL-certified lab tests with doorstep collection.'],
    'Emergency Care': ['Always Ready,\nAlways Safe', 'Immediate emergency care available 24/7.'],
  };

  @override
  Widget build(BuildContext context) {
    final items = _items;
    final banner = _bannerText[label] ?? [label, description];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.deepPurple, size: 20),
        ),
        title: Text(label,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Hero Banner ────────────────────────────────────────
            Container(
              margin: const EdgeInsets.all(16),
              height: 140,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  // Background circles
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withOpacity(0.08),
                      ),
                    ),
                  ),
                  // Nurse illustration
                  Positioned(
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Image.asset(
                        'assets/images/home_nurse.png',
                        width: 130,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (_, __, ___) => Container(
                          width: 120,
                          child: Icon(icon, size: 80,
                              color: color.withOpacity(0.3)),
                        ),
                      ),
                    ),
                  ),
                  // Text
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 18, 140, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(banner[0],
                            style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.deepPurple,
                                height: 1.2)),
                        const SizedBox(height: 6),
                        Text(banner[1],
                            style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: AppColors.greyText,
                                height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Section title & subtitle ───────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$label & Care',
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepPurple)),
                  const SizedBox(height: 4),
                  Text('Choose from a wide range of services\nfor kids, adults and seniors.',
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.greyText,
                          height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Sub-service cards: 2 per row (horizontal pair) ─────
            ...List.generate((items.length / 2).ceil(), (rowIndex) {
              final left = rowIndex * 2;
              final right = left + 1;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: _SubServiceCard(
                        sub: items[left],
                        color: color,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ServiceDetailScreen(
                              label: label,
                              description: items[left].description,
                              icon: icon,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (right < items.length)
                      Expanded(
                        child: _SubServiceCard(
                          sub: items[right],
                          color: color,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ServiceDetailScreen(
                                label: label,
                                description: items[right].description,
                                icon: icon,
                                color: color,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      const Expanded(child: SizedBox()),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── Sub-service card (vertical layout, 2 per row) ─────────────────────────────
class _SubServiceCard extends StatelessWidget {
  final _SubService sub;
  final Color color;
  final VoidCallback onTap;
  const _SubServiceCard(
      {required this.sub, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(sub.icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            // Title
            Text(sub.title,
                style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepPurple)),
            const SizedBox(height: 3),
            // Description
            Text(sub.description,
                style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.greyText,
                    height: 1.4)),
            const SizedBox(height: 10),
            // Price + Arrow row
            Builder(builder: (context) {
              // Arrow uses the contrasting brand colour:
              // orange theme → purple arrow, purple theme → orange arrow
              final arrowColor = color == AppColors.orange
                  ? AppColors.purple
                  : AppColors.orange;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹ ${sub.mrp}',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepPurple,
                    ),
                  ),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: arrowColor.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.arrow_forward_rounded,
                        color: arrowColor, size: 14),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────
class _SubService {
  final String title;
  final String description;
  final IconData icon;
  final int mrp;
  const _SubService(this.title, this.description, this.icon, this.mrp);
}
