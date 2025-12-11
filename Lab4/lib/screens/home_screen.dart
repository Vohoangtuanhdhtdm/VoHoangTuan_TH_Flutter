import 'package:flutter/material.dart';
import 'package:flutter_calculator_vohoangtuan/providers/weather_provider.dart';
import 'package:flutter_calculator_vohoangtuan/screens/current_screen.dart';
import 'package:flutter_calculator_vohoangtuan/screens/search_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Gọi data ngay khi init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(weatherProvider.notifier).fetchWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch state
    final weatherAsyncValue = ref.watch(weatherProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(weatherProvider.notifier).refreshWeather();
        },
        child: weatherAsyncValue.when(
          // 1. Trạng thái Loading
          loading: () => const Center(child: CircularProgressIndicator()),

          // 2. Trạng thái Error
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Lỗi: ${error.toString()}'),
                ElevatedButton(
                  onPressed: () => ref
                      .read(weatherProvider.notifier)
                      .fetchWeatherByLocation(),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),

          // 3. Trạng thái Data
          data: (weatherState) {
            if (weatherState.currentWeather == null) {
              return const Center(child: Text('Đang định vị...'));
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Hiển thị thời tiết hiện tại
                      CurrentWeatherCard(weather: weatherState.currentWeather!),

                      // Hiển thị dự báo (List Forecast)
                      // Bạn có thể bỏ comment khi đã có widget hiển thị list
                      // SizedBox(height: 20),
                      // HourlyForecastList(forecasts: weatherState.forecast),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchScreen()),
        ),
        child: const Icon(Icons.search),
      ),
    );
  }
}
