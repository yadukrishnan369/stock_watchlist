import 'package:flutter/material.dart';
import 'package:stock_watchlist/models/stock_model.dart';
import 'package:stock_watchlist/models/watchlist_model.dart';
import 'package:stock_watchlist/services/api_service.dart';
import 'package:stock_watchlist/services/local_storage_service.dart';
import 'package:stock_watchlist/utils/error_handler.dart';

class WatchlistProvider extends ChangeNotifier {
  final LocalStorageService _localStorageService = LocalStorageService();

  final ApiService _apiService = ApiService();

  List<WatchlistModel> _watchlist = [];

  final Map<String, double> _stockPrices = {};

  // Store symbols whose price request failed
  final Set<String> _priceErrors = {};

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<WatchlistModel> get watchlist => _watchlist;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get latest price
  double? getPrice(String symbol) {
    return _stockPrices[symbol];
  }

  // Check whether price request failed
  bool hasPriceError(String symbol) {
    return _priceErrors.contains(symbol);
  }

  // Load watchlist and latest prices
  Future<void> initializeWatchlist() async {
    await loadWatchlist();

    if (_watchlist.isNotEmpty) {
      await fetchWatchlistPrices();
    }
  }

  // Load saved stocks from Hive
  Future<void> loadWatchlist() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _watchlist = await _localStorageService.getWatchlist();
    } catch (e) {
      _errorMessage = ErrorHandler.getMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch latest prices for saved stocks
  Future<void> fetchWatchlistPrices() async {
    _priceErrors.clear();

    for (final stock in _watchlist) {
      try {
        _priceErrors.remove(stock.symbol);

        final price = await _apiService.getStockPrice(stock.symbol);

        // Store latest price
        _stockPrices[stock.symbol] = price;

        notifyListeners();

        // Avoid requests too quickly
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        // Mark this price as failed
        _priceErrors.add(stock.symbol);

        notifyListeners();

        debugPrint(
          'Price error for ${stock.symbol}: '
          '${ErrorHandler.getMessage(e)}',
        );
      }
    }
  }

  // Add stock to watchlist
  Future<void> addStock(StockModel stock) async {
    try {
      final watchlistStock = WatchlistModel(
        symbol: stock.symbol,
        name: stock.name,
      );

      await _localStorageService.addStock(watchlistStock);

      await loadWatchlist();
    } catch (e) {
      _errorMessage = ErrorHandler.getMessage(e);
      notifyListeners();
    }
  }

  // Remove stock from watchlist
  Future<void> removeStock(String symbol) async {
    try {
      await _localStorageService.removeStock(symbol);

      // Remove from current list
      _watchlist.removeWhere((stock) => stock.symbol == symbol);

      // Remove cached price
      _stockPrices.remove(symbol);

      // Remove price error
      _priceErrors.remove(symbol);

      notifyListeners();
    } catch (e) {
      _errorMessage = ErrorHandler.getMessage(e);
      notifyListeners();
    }
  }

  // Check whether stock is already saved
  bool isInWatchlist(String symbol) {
    return _watchlist.any((stock) => stock.symbol == symbol);
  }
}
