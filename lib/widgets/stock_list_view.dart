import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_watchlist/providers/stock_provider.dart';
import 'package:stock_watchlist/providers/watchlist_provider.dart';
import 'package:stock_watchlist/utils/app_colors.dart';
import 'package:stock_watchlist/widgets/custom_snackbar.dart';
import 'package:stock_watchlist/widgets/stock_card.dart';

class StockListView extends StatelessWidget {
  final StockProvider stockProvider;
  final WatchlistProvider watchlistProvider;
  final String title;

  const StockListView({
    super.key,
    required this.stockProvider,
    required this.watchlistProvider,
    this.title = 'Search Results',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section heading.
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryText,
          ),
        ),

        const SizedBox(height: 12),

        // Display the stocks.
        Expanded(
          child: ListView.builder(
            itemCount: stockProvider.stocks.length,
            itemBuilder: (context, index) {
              final stock = stockProvider.stocks[index];

              return StockCard(
                stock: stock,
                price: stockProvider.getPrice(stock.symbol),
                hasPriceError: stockProvider.hasPriceError(stock.symbol),
                isAdded: watchlistProvider.isInWatchlist(stock.symbol),

                // Add the stock to the watchlist.
                onAdd: () async {
                  await context.read<WatchlistProvider>().addStock(stock);

                  if (!context.mounted) return;

                  CustomSnackBar.success(
                    context,
                    '${stock.name} added to watchlist',
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
