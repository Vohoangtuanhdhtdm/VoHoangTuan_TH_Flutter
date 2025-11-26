import 'package:flutter/material.dart';
import 'package:flutter_calculator_vohoangtuan/presentation/logic/providers/di_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF1E1E1E), // Màu nền nút số
      secondary: Color(0xFF2E4F3E), // Màu nút phép tính
      tertiary: Color(0xFFB04949), // Màu nút C/Delete
      surface: Color(0xFF0F6C44), // Màu nút =
    ),
    useMaterial3: true,
  );

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF3F3F3),
    colorScheme: const ColorScheme.light(
      primary: Colors.white, // Nền nút số trắng
      secondary: Color(0xFFD4D4D2), // Nền phép tính xám nhạt
      tertiary: Color(0xFFFF6B6B), // Màu đỏ tươi hơn
      surface: Color(0xFF4ECDC4), // Màu xanh ngọc cho nút =
      onSurface: Colors.black, // Chữ màu đen
    ),
    useMaterial3: true,
  );
}

// Notifier quản lý trạng thái Theme
class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final isDark = prefs.getBool('isDarkMode');

    if (isDark == null) {
      state = ThemeMode.system;
    } else {
      state = isDark ? ThemeMode.dark : ThemeMode.light;
    }
  }

  void toggleTheme(bool isDark) async {
    state = isDark ? ThemeMode.dark : ThemeMode.light;

    // Lưu vào SharedPreferences
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('isDarkMode', isDark);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});
