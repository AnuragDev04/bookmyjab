import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

class NurseDetailScreen extends StatefulWidget {
  final String name;
  final String role;
  final String rating;
  final String reviews;
  final String experience;
  final String distance;

  const NurseDetailScreen({
    super.key,
    required this.name,
    required this.role,
    required this.rating,
    required this.reviews,
    required this.experience,
    required this.distance,
  });

  @override
  State<NurseDetailScreen> createState() => _NurseDetailScreenState();
}

class _NurseDetailScreenState extends State<NurseDetailScreen> {
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [

              // ── Hero image ──────────────────────────────────────────
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
                      color: Colors.white.withOpacity(0.92),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.10),
                            blurRadius: 8)
                      ],
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: AppColors.deepPurple, size: 18),
                  ),
                ),
                actions: [
                  GestureDetector(
                    onTap: () => setState(
                        () => _isFavourite = !_isFavourite),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 8)
                        ],
                      ),
                      child: Icon(
                        _isFavourite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: _isFavourite
                            ? Colors.red
                            : AppColors.greyText,
                        size: 20,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Gradient background
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.purple.withOpacity(0.18),
                              AppColors.purple.withOpacity(0.06),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      // Nurse image
                      Image.asset(
                        'assets/images/nurse.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        errorBuilder: (_, __, ___) => Center(
                          child: Icon(Icons.person_rounded,
                              size: 80,
                              color: AppColors.purple.withOpacity(0.4)),
                        ),
                      ),
                      // Bottom fade so white content slides over nicely
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 60,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Color(0xFFF5F5FA),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Content ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 0, 16, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── Identity card ────────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 12,
                                offset: const Offset(0, 3))
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name + badge row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.name,
                                          style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.deepPurple)),
                                      const SizedBox(height: 3),
                                      Text(widget.role,
                                          style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: AppColors.greyText)),
                                    ],
                                  ),
                                ),
                                // Verified badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2E7D32)
                                        .withOpacity(0.10),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.verified_rounded,
                                          size: 14,
                                          color: Color(0xFF2E7D32)),
                                      const SizedBox(width: 4),
                                      Text('Verified',
                                          style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color:
                                                  const Color(0xFF2E7D32))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Rating row
                            Row(
                              children: [
                                const Icon(Icons.star_rounded,
                                    color: Color(0xFFFFC107), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.rating}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.deepPurple),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(${widget.reviews} reviews)',
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.greyText),
                                ),
                                const Spacer(),
                                const Icon(Icons.location_on_outlined,
                                    size: 14, color: AppColors.greyText),
                                const SizedBox(width: 3),
                                Text(widget.distance,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: AppColors.greyText)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(
                                height: 1, color: Color(0xFFF0F0F0)),
                            const SizedBox(height: 16),

                            // Stats row
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                _StatItem(
                                  icon: Icons.work_outline_rounded,
                                  value: widget.experience
                                      .replaceAll(' Exp.', '')
                                      .replaceAll(' Years', 'y'),
                                  label: 'Experience',
                                ),
                                _VerticalDivider(),
                                const _StatItem(
                                  icon: Icons.people_alt_outlined,
                                  value: '320+',
                                  label: 'Patients',
                                ),
                                _VerticalDivider(),
                                const _StatItem(
                                  icon: Icons.thumb_up_alt_outlined,
                                  value: '98%',
                                  label: 'Satisfied',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── About ─────────────────────────────────────────
                      _SectionCard(
                        title: 'About',
                        child: Text(
                          'Compassionate and experienced nurse specialised in elderly and post-surgical care. Known for a calm bedside manner and thorough attention to patient wellbeing.',
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: AppColors.greyText,
                              height: 1.65),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Certifications ───────────────────────────────
                      _SectionCard(
                        title: 'Certifications',
                        child: Column(
                          children: const [
                            _CertTile(
                              title: 'Registered Nurse (RN)',
                              issuer: 'Indian Nursing Council',
                              year: '2018',
                              icon: Icons.local_hospital_outlined,
                            ),
                            _CertTile(
                              title: 'Basic Life Support (BLS / CPR)',
                              issuer: 'American Heart Association',
                              year: '2022',
                              icon: Icons.favorite_outline,
                            ),
                            _CertTile(
                              title: 'ICU / Critical Care Training',
                              issuer: 'Apollo Hospitals Institute',
                              year: '2020',
                              icon: Icons.monitor_heart_outlined,
                            ),
                            _CertTile(
                              title: 'Wound Care Specialist',
                              issuer: 'National Wound Care Board',
                              year: '2021',
                              icon: Icons.healing_outlined,
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Education ────────────────────────────────────
                      _SectionCard(
                        title: 'Education',
                        child: Column(
                          children: const [
                            _EduTile(
                              degree: 'B.Sc Nursing',
                              institute: 'Rajiv Gandhi University of Health Sciences',
                              year: '2015 – 2019',
                            ),
                            _EduTile(
                              degree: 'Diploma in Critical Care Nursing',
                              institute: 'NIMHANS, Bangalore',
                              year: '2019 – 2020',
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Languages ────────────────────────────────────
                      _SectionCard(
                        title: 'Languages',
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: const [
                            _LangChip('English'),
                            _LangChip('Hindi'),
                            _LangChip('Kannada'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Available Slots ──────────────────────────────
                      _SectionCard(
                        title: 'Available Slots',
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: const [
                            _SlotChip('9:00 AM'),
                            _SlotChip('11:00 AM'),
                            _SlotChip('2:00 PM'),
                            _SlotChip('4:00 PM'),
                            _SlotChip('6:00 PM'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Bottom action buttons ──────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 16,
                      offset: const Offset(0, -4))
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.call_rounded,
                            color: Colors.white, size: 20),
                        label: Text('Call',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.message_outlined,
                            color: Colors.white, size: 20),
                        label: Text('Message',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section card wrapper
// ─────────────────────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepPurple)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat item
// ─────────────────────────────────────────────────────────────────────────────
class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatItem(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.purple.withOpacity(0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: AppColors.purple),
        ),
        const SizedBox(height: 6),
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.deepPurple)),
        const SizedBox(height: 2),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 10,
                color: AppColors.greyText,
                fontWeight: FontWeight.w400)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vertical divider
// ─────────────────────────────────────────────────────────────────────────────
class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 48, color: const Color(0xFFE8E8E8));
}

// ─────────────────────────────────────────────────────────────────────────────
// Certificate tile
// ─────────────────────────────────────────────────────────────────────────────
class _CertTile extends StatelessWidget {
  final String title;
  final String issuer;
  final String year;
  final IconData icon;
  final bool isLast;

  const _CertTile({
    required this.title,
    required this.issuer,
    required this.year,
    required this.icon,
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
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: const Color(0xFF2E7D32)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.deepPurple)),
                    const SizedBox(height: 2),
                    Text(issuer,
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: AppColors.greyText)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.purple.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(year,
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.purple)),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Education tile
// ─────────────────────────────────────────────────────────────────────────────
class _EduTile extends StatelessWidget {
  final String degree;
  final String institute;
  final String year;
  final bool isLast;

  const _EduTile({
    required this.degree,
    required this.institute,
    required this.year,
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
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.school_outlined,
                    size: 18, color: AppColors.orange),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(degree,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.deepPurple)),
                    const SizedBox(height: 2),
                    Text(institute,
                        style: GoogleFonts.poppins(
                            fontSize: 11, color: AppColors.greyText)),
                    const SizedBox(height: 3),
                    Text(year,
                        style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.orange)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Language chip
// ─────────────────────────────────────────────────────────────────────────────
class _LangChip extends StatelessWidget {
  final String label;
  const _LangChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.purple.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.purple.withOpacity(0.22), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.language_rounded,
              size: 13, color: AppColors.purple),
          const SizedBox(width: 5),
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.purple)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Slot chip
// ─────────────────────────────────────────────────────────────────────────────
class _SlotChip extends StatelessWidget {
  final String time;
  const _SlotChip(this.time);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDDDDDD)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 1))
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.access_time_rounded,
              size: 13, color: AppColors.greyText),
          const SizedBox(width: 5),
          Text(time,
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.deepPurple)),
        ],
      ),
    );
  }
}
