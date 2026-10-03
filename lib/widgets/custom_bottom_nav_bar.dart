import 'package:flutter/material.dart';
import 'package:stock_watchlist/utils/app_colors.dart';

// Custom Bottom NavBar
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Home section
          _buildNavItem(index: 0, icon: Icons.home_rounded, label: 'Home'),

          // Divider between two sections
          Container(width: 1, height: 70, color: AppColors.border),

          // Watchlist section
          _buildNavItem(
            index: 1,
            icon: Icons.bookmark_rounded,
            label: 'Watchlist',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Container(
          // Highlight selected section
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppColors.navSelected
                    : AppColors.navUnselected,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.navSelected
                      : AppColors.navUnselected,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
