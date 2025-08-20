import 'package:dio/dio.dart';

class CurrencyApi {
  static final Dio _dio = Dio();
  static const String _apiKey = 'f66d31fedcd3cf8a7e6d30c7';
  static const String _baseUrl = 'https://v6.exchangerate-api.com/v6';

  static Future<Map<String, double>> fetchRates() async {
    final response = await _dio.get(
      '$_baseUrl/$_apiKey/latest/USD',
      options: Options(
        receiveTimeout: Duration(seconds: 10),
        sendTimeout: Duration(seconds: 10),
      ),
    );

    if (response.statusCode == 200 && response.data['result'] == 'success') {
      final rawRates =
          Map<String, dynamic>.from(response.data['conversion_rates']);
      return rawRates.map((key, value) => MapEntry(key, value.toDouble()));
    }

    throw Exception('Failed to fetch rates: ${response.statusCode}');
  }
}
