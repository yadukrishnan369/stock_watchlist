import 'package:flutter/material.dart';
import 'package:stock_watchlist/models/stock_model.dart';
import 'package:stock_watchlist/utils/app_colors.dart';

// Stock Card
class StockCard extends StatelessWidget {
  final StockModel stock;
  final double? price;
  final bool hasPriceError;
  final bool isAdded;
  final VoidCallback onAdd;

  const StockCard({
    super.key,
    required this.stock,
    required this.price,
    required this.hasPriceError,
    required this.isAdded,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Company information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stock.symbol,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // Price loading, error or success state
          _buildPrice(),

          const SizedBox(width: 10),

          // Add to watchlist button
          InkWell(
            onTap: isAdded ? null : onAdd,
            borderRadius: BorderRadius.circular(9),
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: isAdded
                    ? AppColors.successLight
                    : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                isAdded ? Icons.check_rounded : Icons.add_rounded,
                size: 19,
                color: isAdded ? AppColors.success : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build price based on API state
  Widget _buildPrice() {
    if (hasPriceError) {
      return const Text(
        'Unavailable',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.error,
        ),
      );
    }

    if (price == null) {
      return const SizedBox(
        width: 15,
        height: 15,
        child: CircularProgressIndicator(
          strokeWidth: 1.8,
          color: AppColors.primary,
        ),
      );
    }

    return Text(
      '₹${price!.toStringAsFixed(2)}',
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
      ),
    );
  }
}
