import 'package:flutter_calculator_vohoangtuan/data/interface/i_calculator_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorRepository implements ICalculatorRepository {
  final SharedPreferences _prefs;
  CalculatorRepository(this._prefs);

  static const String _historyKey = 'calc_history_v1';

  @override
  Future<void> saveHistory(List<String> history) async {
    // Lưu tối đa 50 mục
    final truncatedHistory = history.length > 50
        ? history.sublist(history.length - 50)
        : history;
    await _prefs.setStringList(_historyKey, truncatedHistory);
  }

  @override
  Future<List<String>> getHistory() async {
    return _prefs.getStringList(_historyKey) ?? [];
  }
}
