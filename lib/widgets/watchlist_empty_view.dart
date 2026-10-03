import 'package:flutter/material.dart';
import 'package:stock_watchlist/utils/app_colors.dart';

// Watch list Empty View
class WatchlistEmptyView extends StatelessWidget {
  const WatchlistEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border_rounded,
            size: 56,
            color: AppColors.iconSecondary,
          ),
          SizedBox(height: 14),
          // Title
          Text(
            'Your watchlist is empty',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 6),
          // Subtitle
          Text(
            'Add stocks from the Home screen',
            style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }
}
