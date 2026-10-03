import 'package:flutter/material.dart';
import 'package:stock_watchlist/utils/app_colors.dart';

// Watch list Header
class WatchlistHeader extends StatelessWidget {
  const WatchlistHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: const BoxDecoration(color: AppColors.primaryLight),
      child: const Row(
        children: [
          // Company heading
          Expanded(
            flex: 5,
            child: Text(
              'COMPANY',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppColors.secondaryText,
              ),
            ),
          ),

          // Price heading
          Expanded(
            flex: 3,
            child: Text(
              'PRICE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppColors.secondaryText,
              ),
            ),
          ),

          // Space for delete button
          SizedBox(width: 38),
        ],
      ),
    );
  }
}
