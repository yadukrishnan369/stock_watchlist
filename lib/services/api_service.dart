
import 'dart:convert';
import 'dart:isolate';

import 'package:http/http.dart' as http;
import 'package:stock_watchlist/models/stock_model.dart';

class ApiService {
  static const String _baseUrl =
      'https://www.alphavantage.co/query';

  // Read the API key from the run configuration.
  static const String _apiKey =
      String.fromEnvironment('ALPHA_VANTAGE_API_KEY');

  // Check whether the API key is configured.
  void _checkApiKey() {
    if (_apiKey.isEmpty) {
      throw Exception('API key is not configured');
    }
  }

  // Search stocks by company name or symbol.
  Future<List<StockModel>> searchStocks(String keyword) async {
    _checkApiKey();

    final Uri url = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'function': 'SYMBOL_SEARCH',
        'keywords': keyword,
        'apikey': _apiKey,
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body);

      // Handle Alpha Vantage API errors.
      if (data.containsKey('Information')) {
        throw Exception('API request limit reached');
      } else if (data.containsKey('Error Message')) {
        throw Exception('Stock data not found');
      }

      // Parse search results in a separate Isolate.
      final List<dynamic> matches =
          await _parseJsonWithIsolate(response.body);

      return matches
          .map(
            (item) => StockModel.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } else {
      // Handle other HTTP status codes.
      _handleStatusCode(response.statusCode);
      return [];
    }
  }

  // Get the latest stock price.
  Future<double> getStockPrice(String symbol) async {
    _checkApiKey();

    final Uri url = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'function': 'GLOBAL_QUOTE',
        'symbol': symbol,
        'apikey': _apiKey,
      },
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          jsonDecode(response.body);

      // Handle Alpha Vantage API errors.
      if (data.containsKey('Information')) {
        throw Exception('API request limit reached');
      } else if (data.containsKey('Error Message')) {
        throw Exception('Stock data not found');
      }

      final Map<String, dynamic> quote =
          data['Global Quote'] ?? {};

      // Check whether the price is available.
      if (quote.isEmpty || quote['05. price'] == null) {
        throw Exception('Stock price not available');
      }

      final String price = quote['05. price'].toString();

      final double? parsedPrice = double.tryParse(price);

      if (parsedPrice == null) {
        throw Exception('Invalid stock price');
      }

      return parsedPrice;
    } else {
      // Handle other HTTP status codes.
      _handleStatusCode(response.statusCode);
      return 0.0;
    }
  }

  // Handle HTTP errors.
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
      throw Exception(
        'Request failed with status code $statusCode',
      );
    }
  }

  // Parse search results in a separate Isolate.
  Future<List<dynamic>> _parseJsonWithIsolate(
    String responseBody,
  ) async {
    final ReceivePort receivePort = ReceivePort();

    await Isolate.spawn(
      _parseJson,
      [receivePort.sendPort, responseBody],
    );

    try {
      return await receivePort.first as List<dynamic>;
    } finally {
      receivePort.close();
    }
  }

  // Runs inside the new Isolate.
  static void _parseJson(List<dynamic> args) {
    final SendPort sendPort = args[0];
    final String responseBody = args[1];

    final Map<String, dynamic> data =
        jsonDecode(responseBody);

    final List<dynamic> matches = data['bestMatches'] ?? [];

    sendPort.send(matches);
  }
}