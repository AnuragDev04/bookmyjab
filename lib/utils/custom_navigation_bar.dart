// custom_navigation_bar.dart
import 'package:flutter/material.dart';
import 'package:bookmyjab/utils/colors.dart';

class CustomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Bottom navigation items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Leads - Index 1
                  _buildNavItem(
                    icon: Icons.leaderboard_rounded,
                    label: 'Lead',
                    isSelected: currentIndex == 1,
                    onTap: () => onTap(1),
                  ),

                  // Quotation - Index 2
                  _buildNavItem(
                    icon: Icons.article_rounded,
                    label: 'Quotation',
                    isSelected: currentIndex == 2,
                    onTap: () => onTap(2),
                  ),

                  // Spacer for center FAB
                  const SizedBox(width: 60),

                  // Billing - Index 3
                  _buildNavItem(
                    icon: Icons.receipt_long_rounded,
                    label: 'Bills',
                    isSelected: currentIndex == 3,
                    onTap: () => onTap(3),
                  ),

                  // More - Index 4
                  _buildNavItem(
                    icon: Icons.more_horiz_rounded,
                    label: 'More',
                    isSelected: currentIndex == 4,
                    onTap: () => onTap(4),
                  ),
                ],
              ),

              // Center FAB Button - Home (Index 0)
              Positioned(
                left: 0,
                right: 0,
                top: -28,
                child: Center(
                  child: _buildCenterFAB(
                    icon: Icons.home,
                    onTap: () => onTap(0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected
                    ? AppColors.primaryText
                    : Colors.grey.shade600,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected
                      ? AppColors.primaryText
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterFAB({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.primaryText,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.shade600.withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}