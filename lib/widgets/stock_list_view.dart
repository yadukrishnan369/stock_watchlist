import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_watchlist/providers/stock_provider.dart';
import 'package:stock_watchlist/providers/watchlist_provider.dart';
import 'package:stock_watchlist/widgets/custom_snackbar.dart';
import 'package:stock_watchlist/widgets/search_result_header.dart';
import 'package:stock_watchlist/widgets/stock_card.dart';

// Stock List View
class StockListView extends StatelessWidget {
  final StockProvider stockProvider;
  final WatchlistProvider watchlistProvider;

  const StockListView({
    super.key,
    required this.stockProvider,
    required this.watchlistProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search results heading
        const SearchResultHeader(),

        const SizedBox(height: 12),

        // Stock search results
        Expanded(
          child: ListView.builder(
            itemCount: stockProvider.stocks.length,
            itemBuilder: (context, index) {
              final stock = stockProvider.stocks[index];

              return StockCard(
                stock: stock,

                // Latest stock price
                price: stockProvider.getPrice(stock.symbol),

                // Price request failed
                hasPriceError: stockProvider.hasPriceError(stock.symbol),

                // Check whether stock is saved
                isAdded: watchlistProvider.isInWatchlist(stock.symbol),

                // Add stock to watchlist
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
