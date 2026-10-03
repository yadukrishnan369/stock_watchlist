import 'package:flutter/material.dart';
import 'package:stock_watchlist/utils/app_colors.dart';

// Search Empty View
class SearchEmptyView extends StatelessWidget {
  const SearchEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_rounded, size: 55, color: AppColors.iconSecondary),
          SizedBox(height: 14),
          // Title
          Text(
            'Search for a stock',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          SizedBox(height: 6),
          // Subtitle
          Text(
            'Enter a company name or symbol',
            style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }
}
