import 'dart:async';
import 'dart:io';

class ErrorHandler {
  // Convert errors into user friendly messages
  static String getMessage(Object error) {
    final message = error.toString().toLowerCase();

    // No internet / network problem
    if (error is SocketException ||
        message.contains('socketexception') ||
        message.contains('failed host lookup') ||
        message.contains('network is unreachable')) {
      return 'No internet connection. Please check your network.';
    }

    // Request timeout
    if (error is TimeoutException || message.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    // Alpha Vantage API limit
    if (message.contains('api request limit') ||
        message.contains('rate limit')) {
      return 'Stock Limit reached. Please try again later.';
    }

    // Too many requests
    if (message.contains('too many requests') || message.contains('429')) {
      return 'Too many requests. Please try again later.';
    }

    // Data not found
    if (message.contains('data not found') || message.contains('404')) {
      return 'Stock data not found.';
    }

    // Unauthorized request
    if (message.contains('unauthorized') || message.contains('401')) {
      return 'Unable to access stock data.';
    }

    // Server problems
    if (message.contains('server error') ||
        message.contains('500') ||
        message.contains('502') ||
        message.contains('503')) {
      return 'Server is unavailable. Please try again later.';
    }

    // Stock price unavailable
    if (message.contains('stock price not available')) {
      return 'Stock price is currently unavailable.';
    }

    // Default message for unexpected errors
    return 'Something went wrong. Please try again.';
  }
}
