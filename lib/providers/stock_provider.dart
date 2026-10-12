import 'package:flutter/material.dart';
import 'package:stock_watchlist/models/stock_model.dart';
import 'package:stock_watchlist/services/api_service.dart';
import 'package:stock_watchlist/utils/debouncer.dart';
import 'package:stock_watchlist/utils/error_handler.dart';

class StockProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final Debouncer _debouncer = Debouncer();

  List<StockModel> _popularStocks = [];
  List<StockModel> _searchStocks = [];

  final Map<String, double> _stockPrices = {};
  final Set<String> _priceErrors = {};

  bool _isLoading = false;
  String? _errorMessage;
  String _searchKeyword = '';

  int _requestId = 0;

  StockProvider() {
    loadPopularStocks();
  }

  // Show popular stocks when search is empty.
  List<StockModel> get stocks => isSearching ? _searchStocks : _popularStocks;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSearching => _searchKeyword.isNotEmpty;

  double? getPrice(String symbol) => _stockPrices[symbol];

  bool hasPriceError(String symbol) => _priceErrors.contains(symbol);

  // Load five suggested stocks on startup.
  Future<void> loadPopularStocks() async {
    final int currentRequestId = ++_requestId;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // A broad keyword gives us dynamic suggestions.
      final results = await _apiService.searchStocks('a');

      if (currentRequestId != _requestId) return;

      _popularStocks = results.take(5).toList();
      _isLoading = false;
      notifyListeners();

      await _fetchPrices(_popularStocks, currentRequestId);
    } catch (e) {
      if (currentRequestId != _requestId) return;

      _popularStocks = [];
      _errorMessage = ErrorHandler.getMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  // Handle changes in the search field.
  void onSearchChanged(String value) {
    final keyword = value.trim();
    _searchKeyword = keyword;

    if (keyword.isEmpty) {
      _debouncer.cancel();
      clearSearch();
      return;
    }

    // Stop requests belonging to the previous screen state.
    ++_requestId;
    _isLoading = true;
    _errorMessage = null;
    _searchStocks = [];
    notifyListeners();

    _debouncer.run(() {
      searchStocks(keyword);
    });
  }

  // Search for matching stocks.
  Future<void> searchStocks(String keyword) async {
    if (keyword.trim().isEmpty) {
      clearSearch();
      return;
    }

    final int currentRequestId = ++_requestId;

    _isLoading = true;
    _errorMessage = null;
    _searchStocks = [];
    notifyListeners();

    try {
      final results = await _apiService.searchStocks(keyword);

      if (currentRequestId != _requestId) return;

      _searchStocks = results.take(5).toList();
      _isLoading = false;
      notifyListeners();

      await _fetchPrices(_searchStocks, currentRequestId);
    } catch (e) {
      if (currentRequestId != _requestId) return;

      _searchStocks = [];
      _errorMessage = ErrorHandler.getMessage(e);
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch prices one by one.
  Future<void> _fetchPrices(
    List<StockModel> stocksToFetch,
    int currentRequestId,
  ) async {
    for (final stock in stocksToFetch) {
      if (currentRequestId != _requestId) return;

      // Keep existing prices instead of requesting them again.
      if (_stockPrices.containsKey(stock.symbol) ||
          _priceErrors.contains(stock.symbol)) {
        continue;
      }

      try {
        final price = await _apiService.getStockPrice(stock.symbol);

        if (currentRequestId != _requestId) return;

        _stockPrices[stock.symbol] = price;
        _priceErrors.remove(stock.symbol);
      } catch (e) {
        if (currentRequestId != _requestId) return;

        _priceErrors.add(stock.symbol);

        debugPrint(
          'Price error for ${stock.symbol}: '
          '${ErrorHandler.getMessage(e)}',
        );
      }

      notifyListeners();

      // Avoid sending requests too quickly.
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  // Clear search and return to popular stocks.
  void clearSearch() {
    ++_requestId;

    _searchKeyword = '';
    _searchStocks = [];
    _errorMessage = null;
    _isLoading = false;

    notifyListeners();

    // Load suggestions again if they failed to load.
    if (_popularStocks.isEmpty) {
      loadPopularStocks();
    }
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}
