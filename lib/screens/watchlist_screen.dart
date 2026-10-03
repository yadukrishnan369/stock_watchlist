import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_watchlist/providers/watchlist_provider.dart';
import 'package:stock_watchlist/utils/app_colors.dart';
import 'package:stock_watchlist/widgets/watchlist_empty_view.dart';
import 'package:stock_watchlist/widgets/watchlist_error_view.dart';
import 'package:stock_watchlist/widgets/watchlist_table.dart';

// Watch list Screen
class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Appbar
      appBar: AppBar(
        title: const Text(
          'Watchlist',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),

      body: Consumer<WatchlistProvider>(
        builder: (context, provider, child) {
          // Loading saved watchlist
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          // Watchlist loading error
          if (provider.errorMessage != null) {
            return WatchlistErrorView(message: provider.errorMessage!);
          }

          // No saved stocks
          if (provider.watchlist.isEmpty) {
            return const WatchlistEmptyView();
          }

          // Saved watchlist
          return WatchlistTable(provider: provider);
        },
      ),
    );
  }
}
