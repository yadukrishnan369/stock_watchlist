import 'package:flutter/material.dart';
import 'package:stock_watchlist/providers/watchlist_provider.dart';
import 'package:stock_watchlist/utils/app_colors.dart';
import 'package:stock_watchlist/widgets/watchlist_header.dart';
import 'package:stock_watchlist/widgets/watchlist_item.dart';

// Watch list Table
class WatchlistTable extends StatelessWidget {
  final WatchlistProvider provider;

  const WatchlistTable({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Table heading
            const WatchlistHeader(),

            // Saved stock rows
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.watchlist.length,
              itemBuilder: (context, index) {
                final stock = provider.watchlist[index];

                return WatchlistItem(
                  stock: stock,

                  // Latest fetched price
                  price: provider.getPrice(stock.symbol),

                  // Price request failed
                  hasPriceError: provider.hasPriceError(stock.symbol),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
