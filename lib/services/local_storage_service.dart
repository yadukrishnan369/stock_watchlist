import 'package:hive_flutter/hive_flutter.dart';
import 'package:stock_watchlist/models/watchlist_model.dart';

class LocalStorageService {
  static const String _boxName = 'watchlistBox';

  // Open the watchlist box
  Future<Box> _getBox() async {
    return await Hive.openBox(_boxName);
  }

  // Add stock to watchlist
  Future<void> addStock(WatchlistModel stock) async {
    final box = await _getBox();

    // Use symbol as key to prevent duplicate stocks
    await box.put(stock.symbol, stock.toMap());
  }

  // Get all saved stocks
  Future<List<WatchlistModel>> getWatchlist() async {
    final box = await _getBox();

    return box.values.map((item) {
      return WatchlistModel.fromMap(Map<dynamic, dynamic>.from(item));
    }).toList();
  }

  // Remove stock using its symbol
  Future<void> removeStock(String symbol) async {
    final box = await _getBox();

    await box.delete(symbol);
  }

  // Check whether stock is already saved
  Future<bool> isStockSaved(String symbol) async {
    final box = await _getBox();

    return box.containsKey(symbol);
  }
}
