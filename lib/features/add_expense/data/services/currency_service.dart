// lib/features/add_expense/data/services/currency_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static const String _apiKey = 'f66d31fedcd3cf8a7e6d30c7';
  static const String _baseUrl = 'https://v6.exchangerate-api.com/v6';

  Future<Map<String, dynamic>> getExchangeRates(String baseCurrency) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$_apiKey/latest/$baseCurrency'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to load exchange rates: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load exchange rates: $e');
    }
  }

  double convertAmount(double amount, double exchangeRate) {
    return amount * exchangeRate;
  }
}
