import 'package:flutter/material.dart';
import 'package:flutter_calculator_vohoangtuan/presentation/logic/providers/di_providers.dart';
import 'package:flutter_calculator_vohoangtuan/presentation/theme/theme_provider.dart';
import 'package:flutter_calculator_vohoangtuan/presentation/ui/screens/calculator_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'VHT Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: CalculatorPage(),
    );
  }
}
