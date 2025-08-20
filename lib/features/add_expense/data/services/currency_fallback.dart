class CurrencyFallback {
  static Map<String, double> getRates() {
    return {
      'USD': 1.0,
      'EUR': 0.85,
      'GBP': 0.75,
      'JPY': 110.0,
      'CAD': 1.25,
      'AUD': 1.35,
      'AED': 3.67,
      'INR': 83.0,
      'CNY': 7.18,
    };
  }

  static double convertToUSD(double amount, String fromCurrency) {
    final rate = getRates()[fromCurrency] ?? 1.0;
    return amount / rate;
  }

  static double convertFromUSD(double amount, String toCurrency) {
    final rate = getRates()[toCurrency] ?? 1.0;
    return amount * rate;
  }
}
