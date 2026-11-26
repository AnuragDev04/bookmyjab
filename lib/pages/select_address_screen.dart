import 'package:bookmyjab/pages/prescription_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';
import 'confirm_booking_screen.dart';

class SelectAddressScreen extends StatefulWidget {
  final String serviceName;
  final String servicePrice;
  final String selectedDate;
  final String selectedTime;

  const SelectAddressScreen({
    super.key,
    required this.serviceName,
    required this.servicePrice,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  int _selectedAddressIndex = 0;

  final List<_AddressData> _addresses = [
    _AddressData(
      label: 'Home',
      icon: Icons.home_outlined,
      address: '12, Park Street, Bangalore,\nKarnataka - 560001',
    ),
    _AddressData(
      label: 'Office',
      icon: Icons.work_outline_rounded,
      address: '3rd Floor, Block A, Koramangala,\nBangalore - 560095',
    ),
    _AddressData(
      label: 'Other',
      icon: Icons.location_on_outlined,
      address: '78, MG Road, Bangalore - 560001',
    ),
  ];

  void _showAddAddressDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddAddressSheet(
        onSave: (newAddress) {
          setState(() {
            _addresses.add(newAddress);
            _selectedAddressIndex = _addresses.length - 1;
          });
        },
      ),
    );
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
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.deepPurple, size: 20),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Address',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.deepPurple)),
            Text('Step 3 of 7',
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
              child: const Icon(Icons.location_on_outlined,
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
                widthFactor: 3 / 7,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Map placeholder ──────────────────────────────
                 /* Container(
                    height: 180,
                    width: double.infinity,
                    color: const Color(0xFFE8E8F0),
                    child: Stack(
                      children: [
                        CustomPaint(
                          size: const Size(double.infinity, 180),
                          painter: _MapGridPainter(),
                        ),
                        const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on_rounded,
                                  color: AppColors.purple, size: 40),
                              SizedBox(height: 4),
                              CircleAvatar(
                                  radius: 4,
                                  backgroundColor: AppColors.purple),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),*/

                  // ── Current Location ─────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFE8E8E8)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.purple.withOpacity(0.10),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.my_location_rounded,
                                color: AppColors.purple, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Current Location',
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.deepPurple)),
                                Text(
                                    '12, Park Street, Bangalore,\nKarnataka - 560001',
                                    style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: AppColors.greyText,
                                        height: 1.4)),
                              ],
                            ),
                          ),
                          const Icon(Icons.my_location_rounded,
                              color: AppColors.orange, size: 20),
                        ],
                      ),
                    ),
                  ),

                  // ── Add New Address (below current location) ─────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: GestureDetector(
                      onTap: _showAddAddressDialog,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.purple.withOpacity(0.4),
                              width: 1.5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add_rounded,
                                color: AppColors.purple, size: 20),
                            const SizedBox(width: 8),
                            Text('Add New Address',
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.purple)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ── Saved Addresses ──────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    child: Text('Saved Addresses',
                        style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.deepPurple)),
                  ),
                  const SizedBox(height: 10),

                  ...List.generate(_addresses.length, (i) {
                    final addr = _addresses[i];
                    final selected = _selectedAddressIndex == i;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedAddressIndex = i),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: selected
                                ? AppColors.orange
                                : const Color(0xFFE8E8E8),
                            width: selected ? 1.5 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2))
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.purple.withOpacity(0.10)
                                    : const Color(0xFFF5F5FA),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(addr.icon,
                                  color: selected
                                      ? AppColors.orange
                                      : AppColors.greyText,
                                  size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(addr.label,
                                      style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.deepPurple)),
                                  Text(addr.address,
                                      style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: AppColors.greyText,
                                          height: 1.4)),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selected
                                    ? AppColors.orange
                                    : Colors.transparent,
                                border: Border.all(
                                  color: selected
                                      ? AppColors.orange
                                      : const Color(0xFFCCCCCC),
                                  width: 2,
                                ),
                              ),
                              child: selected
                                  ? const Icon(Icons.check_rounded,
                                      color: Colors.white, size: 13)
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),

          // ── Next button ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PrescriptionScreen(
                      serviceName: widget.serviceName,
                      servicePrice: widget.servicePrice,
                     /* selectedDate: widget.selectedDate,
                      selectedTime: widget.selectedTime,
                      address: _addresses[_selectedAddressIndex].address
                          .replaceAll('\n', ', '),*/
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange,
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

// ── Add Address Bottom Sheet ──────────────────────────────────────────────────
class _AddAddressSheet extends StatefulWidget {
  final Function(_AddressData) onSave;
  const _AddAddressSheet({required this.onSave});

  @override
  State<_AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<_AddAddressSheet> {
  int _selectedType = 0; // 0=Home, 1=Office, 2=Other
  final _houseController       = TextEditingController();
  final _apartmentController   = TextEditingController();
  final _areaController        = TextEditingController();
  final _cityController        = TextEditingController();
  final _landmarkController    = TextEditingController();
  final _contactNameController = TextEditingController();
  final _contactNumController  = TextEditingController();

  static const _types = [
    _TypeBadge('Home',   Icons.home_outlined),
    _TypeBadge('Office', Icons.work_outline_rounded),
    _TypeBadge('Other',  Icons.location_on_outlined),
  ];

  @override
  void dispose() {
    _houseController.dispose();
    _apartmentController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _landmarkController.dispose();
    _contactNameController.dispose();
    _contactNumController.dispose();
    super.dispose();
  }

  // per-field error messages
  final Map<String, String?> _errors = {};

  void _validate() {
    setState(() {
      _errors['house']       = _houseController.text.trim().isEmpty
          ? 'House / Flat / Villa No. is required' : null;
      _errors['area']        = _areaController.text.trim().isEmpty
          ? 'Area / Sector is required' : null;
      _errors['city']        = _cityController.text.trim().isEmpty
          ? 'City is required' : null;
      _errors['contactName'] = _contactNameController.text.trim().isEmpty
          ? 'Contact person name is required' : null;
      final num = _contactNumController.text.trim();
      if (num.isEmpty) {
        _errors['contactNum'] = 'Contact number is required';
      } else if (num.length != 10) {
        _errors['contactNum'] = 'Enter a valid 10-digit number';
      } else {
        _errors['contactNum'] = null;
      }
    });
  }

  void _save() {
    _validate();
    if (_errors.values.any((e) => e != null)) return;

    final house = _houseController.text.trim();
    final apt   = _apartmentController.text.trim();
    final area  = _areaController.text.trim();
    final city  = _cityController.text.trim();

    final parts = [house, if (apt.isNotEmpty) apt, area, city];
    final address = parts.join(', ');
    widget.onSave(_AddressData(
      label: _types[_selectedType].label,
      icon: _types[_selectedType].icon,
      address: address,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Text('Add New Address',
                  style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepPurple)),
              const SizedBox(height: 16),

              // ── Type badges ────────────────────────────────────
              Row(
                children: List.generate(_types.length, (i) {
                  final sel = _selectedType == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedType = i),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: sel
                            ? AppColors.purple
                            : AppColors.purple.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: sel
                              ? AppColors.purple
                              : AppColors.purple.withOpacity(0.25),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_types[i].icon,
                              size: 16,
                              color: sel ? Colors.white : AppColors.purple),
                          const SizedBox(width: 6),
                          Text(_types[i].label,
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: sel
                                      ? Colors.white
                                      : AppColors.purple)),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // ── House / Flat / Villa No. ───────────────────────
              _SheetField(
                controller: _houseController,
                label: 'House / Flat / Villa No.',
                hint: 'Enter house / flat / villa number',
                required: true,
                icon: Icons.home_outlined,
                error: _errors['house'],
                onChanged: (_) => setState(() => _errors['house'] = null),
              ),
              const SizedBox(height: 14),

              // ── Apartment / Society / Building ────────────────
              _SheetField(
                controller: _apartmentController,
                label: 'Apartment / Society / Building',
                hint: 'Enter apartment or society name',
                icon: Icons.apartment_outlined,
              ),
              const SizedBox(height: 14),

              // ── Area / Sector ─────────────────────────────────
              _SheetField(
                controller: _areaController,
                label: 'Area / Sector',
                hint: 'Enter area or sector',
                required: true,
                icon: Icons.place_outlined,
                error: _errors['area'],
                onChanged: (_) => setState(() => _errors['area'] = null),
              ),
              const SizedBox(height: 14),

              // ── City ──────────────────────────────────────────
              _SheetField(
                controller: _cityController,
                label: 'City',
                hint: 'Enter city name',
                required: true,
                icon: Icons.location_city_outlined,
                error: _errors['city'],
                onChanged: (_) => setState(() => _errors['city'] = null),
              ),
              const SizedBox(height: 14),

              // ── Landmark / Notes for Nurse ────────────────────
              _SheetField(
                controller: _landmarkController,
                label: 'Landmark / Notes for Nurse',
                hint: 'Enter nearby landmark or notes',
                icon: Icons.edit_note_rounded,
                maxLines: 2,
              ),
              const SizedBox(height: 22),

              // ── Contact Person Details heading ────────────────
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.orange.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.person_outline_rounded,
                        color: AppColors.orange, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Contact Person Details',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.deepPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Who should the nurse contact on arrival?',
                style: GoogleFonts.poppins(
                    fontSize: 11, color: AppColors.greyText),
              ),
              const SizedBox(height: 14),

              // ── Contact Person Name ───────────────────────────
              _SheetField(
                controller: _contactNameController,
                label: 'Contact Person Name',
                hint: 'Enter full name',
                required: true,
                icon: Icons.badge_outlined,
                error: _errors['contactName'],
                onChanged: (_) => setState(() => _errors['contactName'] = null),
              ),
              const SizedBox(height: 14),

              // ── Contact Number ────────────────────────────────
              _SheetField(
                controller: _contactNumController,
                label: 'Contact Number',
                hint: 'Enter 10-digit mobile number',
                required: true,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                error: _errors['contactNum'],
                onChanged: (_) => setState(() => _errors['contactNum'] = null),
              ),
              const SizedBox(height: 24),

              // ── Buttons ────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Save Address',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: Color(0xFFE0E0E0), width: 1.5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('Cancel',
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.greyText)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Address field (used in main screen form) ──────────────────────────────────
class _AddressField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final int? maxLength;
  final int maxLines;

  const _AddressField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.deepPurple,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7F6FC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE0E0EE)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 12, top: maxLines > 1 ? 13 : 0),
                child: Icon(icon, size: 18, color: AppColors.purple),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLength: maxLength,
                  maxLines: maxLines,
                  inputFormatters: keyboardType == TextInputType.phone
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : null,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.deepPurple),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.greyText),
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Sheet field ───────────────────────────────────────────────────────────────
class _SheetField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool required;
  final IconData icon;
  final TextInputType keyboardType;
  final int? maxLength;
  final int maxLines;
  final String? error;
  final ValueChanged<String>? onChanged;

  const _SheetField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.required = false,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.maxLines = 1,
    this.error,
    this.onChanged,
  });

  @override
  State<_SheetField> createState() => _SheetFieldState();
}

class _SheetFieldState extends State<_SheetField> {
  late final FocusNode _focus;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode()
      ..addListener(() {
        setState(() => _isFocused = _focus.hasFocus);
      });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.error != null && widget.error!.isNotEmpty;
    final borderColor = hasError
        ? AppColors.red
        : _isFocused
            ? AppColors.purple
            : const Color(0xFFE0E0E0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row with optional required asterisk
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: widget.label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.deepPurple,
                ),
              ),
              if (widget.required)
                TextSpan(
                  text: ' *',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.red,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _isFocused
                ? AppColors.purple.withOpacity(0.03)
                : Colors.white,
            border: Border.all(color: borderColor, width: 1.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Icon(widget.icon,
                    size: 18,
                    color: hasError
                        ? AppColors.red
                        : _isFocused
                            ? AppColors.purple
                            : AppColors.purple),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  keyboardType: widget.keyboardType,
                  maxLength: widget.maxLength,
                  maxLines: widget.maxLines,
                  onChanged: widget.onChanged,
                  inputFormatters: widget.keyboardType == TextInputType.phone
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : null,
                  style: GoogleFonts.poppins(
                      fontSize: 13, color: AppColors.deepPurple),
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.greyText),
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Inline error
        if (hasError) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.error_outline_rounded,
                  size: 13, color: AppColors.red),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  widget.error!,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// ── Address data model ────────────────────────────────────────────────────────
class _AddressData {
  final String label;
  final IconData icon;
  final String address;
  const _AddressData(
      {required this.label, required this.icon, required this.address});
}

// ── Type badge data ───────────────────────────────────────────────────────────
class _TypeBadge {
  final String label;
  final IconData icon;
  const _TypeBadge(this.label, this.icon);
}

// ── Map grid painter ──────────────────────────────────────────────────────────
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD0D0E0)
      ..strokeWidth = 1;
    for (double y = 0; y < size.height; y += 30) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8;
    canvas.drawLine(Offset(0, size.height * 0.4),
        Offset(size.width, size.height * 0.4), roadPaint);
    canvas.drawLine(Offset(size.width * 0.4, 0),
        Offset(size.width * 0.4, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.7),
        Offset(size.width, size.height * 0.7), roadPaint);
  }

  @override
  bool shouldRepaint(_MapGridPainter old) => false;
}


