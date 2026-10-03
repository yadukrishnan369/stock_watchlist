class StockModel {
  final String symbol;
  final String name;
  final String region;
  final String currency;

  StockModel({
    required this.symbol,
    required this.name,
    required this.region,
    required this.currency,
  });

  // Convert Alpha Vantage JSON into a StockModel object
  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      symbol: json['1. symbol'] ?? '',
      name: json['2. name'] ?? '',
      region: json['4. region'] ?? '',
      currency: json['8. currency'] ?? '',
    );
  }
}
