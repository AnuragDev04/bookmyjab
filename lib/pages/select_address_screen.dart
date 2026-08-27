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
        title: Text('Select Address',
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
          // ── Step indicator ─────────────────────────────────────────
          _StepIndicator(currentStep: 2),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Map placeholder ──────────────────────────────
                  Container(
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
                  ),

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
                      onTap: () {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() => _selectedAddressIndex = i);
                        });
                      },
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
                            const Icon(Icons.chevron_right_rounded,
                                color: AppColors.greyText, size: 20),
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
                    builder: (_) => ConfirmBookingScreen(
                      serviceName: widget.serviceName,
                      servicePrice: widget.servicePrice,
                      selectedDate: widget.selectedDate,
                      selectedTime: widget.selectedTime,
                      address: _addresses[_selectedAddressIndex].address
                          .replaceAll('\n', ', '),
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
  final _flatController     = TextEditingController();
  final _areaController     = TextEditingController();
  final _cityController     = TextEditingController();
  final _pincodeController  = TextEditingController();

  static const _types = [
    _TypeBadge('Home',   Icons.home_outlined),
    _TypeBadge('Office', Icons.work_outline_rounded),
    _TypeBadge('Other',  Icons.location_on_outlined),
  ];

  @override
  void dispose() {
    _flatController.dispose();
    _areaController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _save() {
    final flat    = _flatController.text.trim();
    final area    = _areaController.text.trim();
    final city    = _cityController.text.trim();
    final pincode = _pincodeController.text.trim();

    if (flat.isEmpty || area.isEmpty || city.isEmpty || pincode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields',
              style: GoogleFonts.poppins(fontSize: 13)),
          backgroundColor: AppColors.purple,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final address = '$flat, $area,\n$city - $pincode';
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
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() => _selectedType = i);
                      });
                    },
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
                              color:
                                  sel ? Colors.white : AppColors.purple),
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

              // ── Flat / House / Building ───────────────────────
              _SheetField(
                controller: _flatController,
                label: 'Flat / House / Building',
                hint: 'Enter flat, house or building no.',
                icon: Icons.home_work_outlined,
              ),
              const SizedBox(height: 14),

              // ── Area / Street / Landmark ─────────────────────
              _SheetField(
                controller: _areaController,
                label: 'Area / Street / Landmark',
                hint: 'Enter area, street or landmark',
                icon: Icons.place_outlined,
              ),
              const SizedBox(height: 14),

              // ── City & Pincode side by side ───────────────────
              Row(
                children: [
                  Expanded(
                    child: _SheetField(
                      controller: _cityController,
                      label: 'City',
                      hint: 'Enter city',
                      icon: Icons.location_city_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SheetField(
                      controller: _pincodeController,
                      label: 'Pincode',
                      hint: '6-digit pincode',
                      icon: Icons.pin_drop_outlined,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Buttons ────────────────────────────────────────
              Row(
                children: [
                  // Save
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
                  // Cancel
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

// ── Sheet field ───────────────────────────────────────────────────────────────
class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final int? maxLength;

  const _SheetField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.deepPurple)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Icon(icon, size: 18, color: AppColors.purple),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLength: maxLength,
                  inputFormatters: keyboardType == TextInputType.number
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
                        const EdgeInsets.symmetric(vertical: 12),
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

// ── Step indicator ────────────────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final steps = ['Service', 'Date & Time', 'Address', 'Confirm'];
    return Padding(
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
          final done = stepIndex < currentStep;
          final active = stepIndex == currentStep;

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
