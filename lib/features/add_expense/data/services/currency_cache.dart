class CurrencyCache {
  static Map<String, double> _rates = {};
  static DateTime? _lastUpdate;

  static bool get isValid {
    return _lastUpdate != null &&
        DateTime.now().difference(_lastUpdate!) < const Duration(hours: 1) &&
        _rates.isNotEmpty;
  }

  static Map<String, double> get rates => _rates;

  static void update(Map<String, double> newRates) {
    _rates = newRates;
    _lastUpdate = DateTime.now();
  }
}
