class WatchlistModel {
  final String symbol;
  final String name;

  WatchlistModel({required this.symbol, required this.name});

  // Convert object to Map for Hive
  Map<String, dynamic> toMap() {
    return {'symbol': symbol, 'name': name};
  }

  // Convert Hive Map back to object
  factory WatchlistModel.fromMap(Map<dynamic, dynamic> map) {
    return WatchlistModel(symbol: map['symbol'] ?? '', name: map['name'] ?? '');
  }
}
