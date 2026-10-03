import 'package:flutter/material.dart';
import 'package:stock_watchlist/utils/app_colors.dart';

// Home Header
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Title
        Text(
          'Stock Watchlist',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryText,
          ),
        ),
        SizedBox(height: 6),
        // Subtitle
        Text(
          'Find and track your favourite stocks',
          style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
        ),
      ],
    );
  }
}
