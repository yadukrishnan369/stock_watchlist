import 'dart:convert';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'package:stock_watchlist/models/stock_model.dart';

class ApiService {
  static const String _baseUrl = 'https://www.alphavantage.co/query';

  // Alpha Vantage API key
  static const String _apiKey = 'RDQR5SN6J6CNAVJU';

  // SEARCH STOCKS
  Future<List<StockModel>> searchStocks(String keyword) async {
    final Uri url = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'function': 'SYMBOL_SEARCH',
        'keywords': keyword,
        'apikey': _apiKey,
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Handle Alpha Vantage API limit
      if (data.containsKey('Information')) {
        throw Exception('API request limit reached');
      }

      // Handle Alpha Vantage API error
      if (data.containsKey('Error Message')) {
        throw Exception('Stock data not found');
      }

      // Parse search results in separate isolate
      final List<dynamic> matches = await _parseJsonWithIsolate(response.body);

      return matches
          .map((item) => StockModel.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }

    _handleStatusCode(response.statusCode);

    return [];
  }

  // GET STOCK PRICE
  Future<double> getStockPrice(String symbol) async {
    final Uri url = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'function': 'GLOBAL_QUOTE',
        'symbol': symbol,
        'apikey': _apiKey,
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Handle Alpha Vantage API limit
      if (data.containsKey('Information')) {
        throw Exception('API request limit reached');
      }

      // Handle Alpha Vantage API error
      if (data.containsKey('Error Message')) {
        throw Exception('Stock data not found');
      }

      final Map<String, dynamic> quote = data['Global Quote'] ?? {};

      // Make sure price data exists
      if (quote.isEmpty || quote['05. price'] == null) {
        throw Exception('Stock price not available');
      }

      final String price = quote['05. price'];

      return double.tryParse(price) ?? 0.0;
    }

    _handleStatusCode(response.statusCode);

    return 0.0;
  }

  // HTTP STATUS ERROR HANDLING
  void _handleStatusCode(int statusCode) {
    if (statusCode == 400) {
      throw Exception('Bad request');
    } else if (statusCode == 401) {
      throw Exception('Unauthorized request');
    } else if (statusCode == 404) {
      throw Exception('Data not found');
    } else if (statusCode == 429) {
      throw Exception('Too many requests');
    } else if (statusCode >= 500) {
      throw Exception('Server error');
    } else {
      throw Exception('Request failed with status code $statusCode');
    }
  }

  // ISOLATE
  Future<List<dynamic>> _parseJsonWithIsolate(String responseBody) async {
    final ReceivePort receivePort = ReceivePort();

    await Isolate.spawn(_parseJson, [receivePort.sendPort, responseBody]);

    final List<dynamic> result = await receivePort.first;

    receivePort.close();

    return result;
  }

  // Runs inside the new isolate
  static void _parseJson(List<dynamic> args) {
    final SendPort sendPort = args[0];
    final String responseBody = args[1];

    final Map<String, dynamic> data = jsonDecode(responseBody);

    final List<dynamic> matches = data['bestMatches'] ?? [];

    sendPort.send(matches);
  }
}
