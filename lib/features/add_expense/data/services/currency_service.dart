import 'currency_api.dart';
import 'currency_cache.dart';
import 'currency_fallback.dart';

class CurrencyService {
  static Future<Map<String, double>> getConversionRates() async {
    if (CurrencyCache.isValid) {
      return CurrencyCache.rates;
    }

    try {
      final rates = await CurrencyApi.fetchRates();
      CurrencyCache.update(rates);
      return rates;
    } catch (e) {
      return CurrencyFallback.getRates();
    }
  }

  static Future<double> convertToUSD(double amount, String fromCurrency) async {
    final rates = await getConversionRates();

    if (fromCurrency == 'USD') return amount;
    final rate = rates[fromCurrency];

    if (rate == null) {
      return CurrencyFallback.convertToUSD(amount, fromCurrency);
    }

    return amount / rate;
  }

  static Future<double> convertFromUSD(double amount, String toCurrency) async {
    final rates = await getConversionRates();

    if (toCurrency == 'USD') return amount;
    final rate = rates[toCurrency];

    if (rate == null) {
      return CurrencyFallback.convertFromUSD(amount, toCurrency);
    }

    return amount * rate;
  }

  static Future<List<String>> getAvailableCurrencies() async {
    final rates = await getConversionRates();
    return rates.keys.toList();
  }
}
