import 'package:flutter_calculator_vohoangtuan/data/implementation/calculator_repository.dart';
import 'package:flutter_calculator_vohoangtuan/data/interface/i_calculator_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final calculatorRepositoryProvider = Provider<ICalculatorRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return CalculatorRepository(prefs);
});
