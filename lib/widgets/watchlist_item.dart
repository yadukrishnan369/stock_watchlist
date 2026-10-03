import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_watchlist/models/watchlist_model.dart';
import 'package:stock_watchlist/providers/watchlist_provider.dart';
import 'package:stock_watchlist/utils/app_colors.dart';
import 'package:stock_watchlist/widgets/custom_snackbar.dart';

// Watch list Item
class WatchlistItem extends StatelessWidget {
  final WatchlistModel stock;
  final double? price;
  final bool hasPriceError;

  const WatchlistItem({
    super.key,
    required this.stock,
    required this.price,
    required this.hasPriceError,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          // Company information
          Expanded(
            flex: 5,
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
                const SizedBox(height: 3),
                Text(
                  stock.symbol,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),

          // Stock price
          Expanded(flex: 3, child: Center(child: _buildPrice())),

          // Delete stock
          SizedBox(
            width: 38,
            height: 38,
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: 'Remove',
              onPressed: () async {
                await context.read<WatchlistProvider>().removeStock(
                  stock.symbol,
                );

                if (!context.mounted) return;

                CustomSnackBar.success(context, 'Stock removed from watchlist');
              },
              icon: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.errorLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 17,
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show loading, error or latest price
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        '₹${price!.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.success,
        ),
      ),
    );
  }
}
