import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_watchlist/providers/stock_provider.dart';
import 'package:stock_watchlist/providers/watchlist_provider.dart';
import 'package:stock_watchlist/utils/app_colors.dart';
import 'package:stock_watchlist/widgets/home_header.dart';
import 'package:stock_watchlist/widgets/search_empty_view.dart';
import 'package:stock_watchlist/widgets/search_error_view.dart';
import 'package:stock_watchlist/widgets/stock_list_view.dart';
import 'package:stock_watchlist/widgets/stock_search_bar.dart';

// Home Screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Home heading
              const HomeHeader(),

              const SizedBox(height: 22),

              // Search field
              StockSearchBar(
                onChanged: context.read<StockProvider>().onSearchChanged,
              ),

              const SizedBox(height: 22),

              // Search content
              Expanded(
                child: Consumer<StockProvider>(
                  builder: (context, stockProvider, child) {
                    // Search loading
                    if (stockProvider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    // Search error
                    if (stockProvider.errorMessage != null) {
                      return SearchErrorView(
                        message: stockProvider.errorMessage!,
                      );
                    }

                    // Default / empty state
                    if (stockProvider.stocks.isEmpty) {
                      return const SearchEmptyView();
                    }

                    // Listen to watchlist changes
                    return Consumer<WatchlistProvider>(
                      builder: (context, watchlistProvider, child) {
                        return StockListView(
                          stockProvider: stockProvider,
                          watchlistProvider: watchlistProvider,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
