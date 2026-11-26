import 'package:bookmyjab/pages/consent_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/colors.dart';
import 'select_address_screen.dart';

class  PrescriptionScreen extends StatefulWidget {
  final String serviceName;
  final String servicePrice;

  const PrescriptionScreen({
    super.key,
    required this.serviceName,
    required this.servicePrice,
  });

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  // null = nothing selected, 0 = prescription, 1 = consultation
  int? _selected;
  String? _fileName;
  XFile? _pickedFile;

  static const _totalSteps  = 7;
  static const _currentStep = 5;

  final _picker = ImagePicker();

  Future<void> _pickFile() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _PickerSheet(
        onCamera: () async {
          Navigator.pop(context);
          final f = await _picker.pickImage(source: ImageSource.camera);
          if (f != null) setState(() { _pickedFile = f; _fileName = f.name; });
        },
        onGallery: () async {
          Navigator.pop(context);
          final f = await _picker.pickImage(source: ImageSource.gallery);
          if (f != null) setState(() { _pickedFile = f; _fileName = f.name; });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool expanded = _selected == 0;

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
              'Step $_currentStep of $_totalSteps',
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
              child: const Icon(Icons.description_outlined,
                  color: AppColors.orange, size: 20),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: Stack(
            children: [
              Container(height: 5, color: const Color(0xFFEEEEEE)),
              FractionallySizedBox(
                widthFactor: _currentStep / _totalSteps,
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
                  // ── Page title & subtitle (shown when a card is selected) ─
                  if (_selected != null) ...[
                    Text(
                      'Prescription or Doctor Review',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.deepPurple,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${widget.serviceName} is a medical procedure, so every booking needs '
                      'either a valid doctor prescription or a short review by one of our '
                      'partner doctors. Choose one to continue.',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.greyText,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ] else
                    const SizedBox(height: 8),

                  // ── Card 1 : I have a prescription ─────────────────────────
                  _OptionCard(
                    icon: Icons.description_outlined,
                    title: 'I have a prescription',
                    subtitle:
                        'Upload a PDF or photo of your doctor\'s prescription. Max 10 MB.',
                    selected: _selected == 0,
                    onTap: () => setState(
                        () => _selected = _selected == 0 ? null : 0),
                    expandedContent: expanded
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 14),
                              const Divider(
                                  height: 1, color: Color(0xFFEEDDCC)),
                              const SizedBox(height: 14),

                              // Choose file button
                              GestureDetector(
                                onTap: _pickFile,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: _fileName != null
                                            ? AppColors.orange.withOpacity(0.5)
                                            : const Color(0xFFDDDDDD)),
                                  ),
                                  child: _fileName == null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.upload_rounded,
                                                color: AppColors.orange,
                                                size: 18),
                                            const SizedBox(width: 8),
                                            Text('Choose file',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.greyText,
                                                )),
                                          ],
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12),
                                          child: Row(
                                            children: [
                                              // Thumbnail
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  _pickedFile!.path,
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (_, __, ___) =>
                                                      Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: AppColors.orange
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: const Icon(
                                                        Icons.image_outlined,
                                                        color:
                                                            AppColors.orange,
                                                        size: 20),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  _fileName!,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColors.deepPurple,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                              // Remove
                                              GestureDetector(
                                                onTap: () => setState(() {
                                                  _fileName = null;
                                                  _pickedFile = null;
                                                }),
                                                child: const Icon(
                                                    Icons.close_rounded,
                                                    size: 18,
                                                    color: AppColors.greyText),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Helper note
                              Text(
                                'Our team will collect the prescription file from you on '
                                'WhatsApp or call before scheduling.',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppColors.greyText,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // ── Card 2 : Request a doctor consultation ──────────────────
                  _OptionCard(
                    icon: Icons.medical_services_outlined,
                    title: 'Request a doctor consultation',
                    subtitle:
                        'A partner doctor will review eligibility on a short video call '
                        'before your home visit is scheduled.',
                    selected: _selected == 1,
                    onTap: () => setState(
                        () => _selected = _selected == 1 ? null : 1),
                  ),
                  const SizedBox(height: 16),

                  // ── Card 3 : I don't have a prescription ───────────────────
                  _OptionCard(
                    icon: Icons.do_not_disturb_alt_outlined,
                    title: 'I don\'t have a prescription',
                    subtitle:
                        'No prescription? Our team will guide you through the next steps '
                        'and verify eligibility before confirming your booking.',
                    selected: _selected == 2,
                    onTap: () => setState(
                        () => _selected = _selected == 2 ? null : 2),
                  ),
                  const SizedBox(height: 32),

                  // ── Footer links ────────────────────────────────────────────
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _FooterLink('Terms & Conditions'),
                        _FooterDot(),
                        _FooterLink('Privacy Notice'),
                        _FooterDot(),
                        _FooterLink('Refund Policy'),
                        _FooterLink(
                            'Medical Declaration & Vaccination Consent'),
                        _FooterDot(),
                        _FooterLink('Grievance / Support Contact'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Social icons ────────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialIcon(Icons.camera_alt_outlined),
                      const SizedBox(width: 20),
                      _SocialIcon(Icons.work_outline_rounded),
                      const SizedBox(width: 20),
                      _SocialIcon(Icons.facebook_outlined),
                      const SizedBox(width: 20),
                      _SocialIcon(Icons.connect_without_contact_outlined),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Continue button ─────────────────────────────────────────────────
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
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _selected != null
                    ? () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConsentScreen(serviceName: '', servicePrice: '',
                             /* serviceName: widget.serviceName,
                              servicePrice: widget.servicePrice, selectedDate: '', selectedTime: '',*/
                            ),
                          ),
                        )
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
                  disabledBackgroundColor: AppColors.orange.withOpacity(0.45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: _selected != null ? 4 : 0,
                  shadowColor: AppColors.orange.withOpacity(0.4),
                ),
                child: Text(
                  'Continue',
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

// ── Source picker bottom sheet ────────────────────────────────────────────────
class _PickerSheet extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onGallery;

  const _PickerSheet({required this.onCamera, required this.onGallery});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Upload Prescription',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.deepPurple,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose how you\'d like to add your prescription',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.greyText,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Camera option
          _SheetTile(
            icon: Icons.camera_alt_outlined,
            label: 'Take a Photo',
            subtitle: 'Use your camera to capture the prescription',
            onTap: onCamera,
          ),
          const SizedBox(height: 12),

          // Gallery option
          _SheetTile(
            icon: Icons.photo_library_outlined,
            label: 'Choose from Gallery',
            subtitle: 'Select an existing photo or PDF from your device',
            onTap: onGallery,
          ),
          const SizedBox(height: 16),

          // Cancel
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text('Cancel',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greyText,
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _SheetTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.orange.withOpacity(0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.orange.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.orange.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.orange, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.deepPurple,
                      )),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: AppColors.greyText,
                      )),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.greyText, size: 18),
          ],
        ),
      ),
    );
  }
}

// ── Option card ───────────────────────────────────────────────────────────────
class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;
  final Widget? expandedContent;

  const _OptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
    this.expandedContent,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.orange.withOpacity(0.06)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected
              ? AppColors.orange.withOpacity(0.55)
              : const Color(0xFFEEEEEE),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon badge
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.orange.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(icon, color: AppColors.orange, size: 24),
                  ),
                  const SizedBox(width: 14),
                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.greyText,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Checkmark when selected
                  if (selected)
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 2),
                      child: Icon(Icons.check_rounded,
                          color: AppColors.orange, size: 20),
                    ),
                ],
              ),

              // Expanded slot (e.g. file picker)
              if (expandedContent != null) expandedContent!,
            ],
          ),
        ),
      ),
    );
  }
}

// ── Footer helpers ────────────────────────────────────────────────────────────
class _FooterLink extends StatelessWidget {
  final String text;
  const _FooterLink(this.text);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 11,
          color: AppColors.greyText,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.greyText,
        ),
      ),
    );
  }
}

class _FooterDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('·',
        style: GoogleFonts.poppins(
            fontSize: 13, color: AppColors.greyText));
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  const _SocialIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFF0EAF8),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.purple, size: 18),
    );
  }
}
