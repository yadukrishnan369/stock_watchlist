import 'package:flutter/material.dart';
import 'package:stock_watchlist/utils/app_colors.dart';

// Stock Search Bar
class StockSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const StockSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search company or symbol',
        hintStyle: const TextStyle(color: AppColors.hintText, fontSize: 14),

        suffixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.iconSecondary,
        ),

        filled: true,
        fillColor: AppColors.surface,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
