import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

// State: true = Celsius (độ C), false = Fahrenheit (độ F)
class UnitNotifier extends StateNotifier<bool> {
  UnitNotifier() : super(true) {
    _loadUnit();
  }

  Future<void> _loadUnit() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('is_celsius') ?? true;
  }

  Future<void> toggleUnit() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_celsius', state);
  }
}

final unitProvider = StateNotifierProvider<UnitNotifier, bool>((ref) {
  return UnitNotifier();
});
