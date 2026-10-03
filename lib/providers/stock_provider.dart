import 'package:flutter/material.dart';
import 'package:stock_watchlist/models/stock_model.dart';
import 'package:stock_watchlist/services/api_service.dart';
import 'package:stock_watchlist/utils/debouncer.dart';
import 'package:stock_watchlist/utils/error_handler.dart';

class StockProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Handle search delay
  final Debouncer _debouncer = Debouncer();

  List<StockModel> _stocks = [];

  final Map<String, double> _stockPrices = {};

  // Store symbols whose price request failed
  final Set<String> _priceErrors = {};

  bool _isLoading = false;
  String? _errorMessage;

  // Used to ignore old search requests
  int _searchId = 0;

  // Getters
  List<StockModel> get stocks => _stocks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get stock price
  double? getPrice(String symbol) {
    return _stockPrices[symbol];
  }

  // Check whether price request failed
  bool hasPriceError(String symbol) {
    return _priceErrors.contains(symbol);
  }

  // Handle search field changes
  void onSearchChanged(String value) {
    final keyword = value.trim();

    // Clear search when field is empty
    if (keyword.isEmpty) {
      _debouncer.cancel();
      clearSearch();
      return;
    }

    // Search after user stops typing
    _debouncer.run(() {
      searchStocks(keyword);
    });
  }

  // Search stocks
  Future<void> searchStocks(String keyword) async {
    if (keyword.trim().isEmpty) {
      clearSearch();
      return;
    }

    // Create ID for this search
    final int currentSearchId = ++_searchId;

    _isLoading = true;
    _errorMessage = null;
    _stocks = [];
    _stockPrices.clear();
    _priceErrors.clear();

    notifyListeners();

    try {
      final results = await _apiService.searchStocks(keyword);

      // Ignore old search result
      if (currentSearchId != _searchId) {
        return;
      }

      // Show first 5 results
      _stocks = results.take(5).toList();

      _isLoading = false;
      notifyListeners();

      // Wait before fetching prices
      await Future.delayed(const Duration(seconds: 2));

      // Stop if search changed
      if (currentSearchId != _searchId) {
        return;
      }

      await _fetchPrices(currentSearchId);
    } catch (e) {
      // Ignore old search error
      if (currentSearchId != _searchId) {
        return;
      }

      _stocks = [];
      _errorMessage = ErrorHandler.getMessage(e);
      _isLoading = false;

      notifyListeners();
    }
  }

  // Fetch prices one by one
  Future<void> _fetchPrices(int currentSearchId) async {
    final stocksToFetch = List<StockModel>.from(_stocks);

    for (final stock in stocksToFetch) {
      // Stop old price requests
      if (currentSearchId != _searchId) {
        return;
      }

      try {
        final price = await _apiService.getStockPrice(stock.symbol);

        if (currentSearchId != _searchId) {
          return;
        }

        _stockPrices[stock.symbol] = price;
        _priceErrors.remove(stock.symbol);

        notifyListeners();

        // Avoid requests too quickly
        await Future.delayed(const Duration(seconds: 2));
      } catch (e) {
        if (currentSearchId != _searchId) {
          return;
        }

        // Mark price as failed
        _priceErrors.add(stock.symbol);

        notifyListeners();

        debugPrint(
          'Price error for ${stock.symbol}: '
          '${ErrorHandler.getMessage(e)}',
        );
      }
    }
  }

  // Clear search state
  void clearSearch() {
    // Invalidate running search
    _searchId++;

    _stocks = [];
    _stockPrices.clear();
    _priceErrors.clear();
    _errorMessage = null;
    _isLoading = false;

    notifyListeners();
  }

  @override
  void dispose() {
    // Cancel debounce timer
    _debouncer.dispose();
    super.dispose();
  }
}
