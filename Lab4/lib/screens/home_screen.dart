import 'package:flutter/material.dart';
import 'package:flutter_calculator_vohoangtuan/providers/weather_provider.dart';
import 'package:flutter_calculator_vohoangtuan/screens/current_screen.dart';
import 'package:flutter_calculator_vohoangtuan/screens/search_screen.dart';
import 'package:flutter_calculator_vohoangtuan/widgets/daily_forecast_card.dart';
import 'package:flutter_calculator_vohoangtuan/widgets/hourly_forecast_list.dart';
import 'package:flutter_calculator_vohoangtuan/widgets/weather_details_grid.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(weatherProvider.notifier).fetchWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final weatherAsyncValue = ref.watch(weatherProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Màu nền nhẹ
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(weatherProvider.notifier).refreshWeather();
        },
        child: weatherAsyncValue.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Lỗi: ${error.toString()}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref
                      .read(weatherProvider.notifier)
                      .fetchWeatherByLocation(),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
          data: (weatherState) {
            if (weatherState.currentWeather == null) {
              return const Center(child: Text('Đang định vị...'));
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Current Weather (Card chính)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CurrentWeatherCard(
                        weather: weatherState.currentWeather!,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: WeatherDetailsGrid(
                        weather: weatherState.currentWeather!,
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Hourly Forecast",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    HourlyForecastList(forecasts: weatherState.forecast),
                    const SizedBox(height: 20),
                    DailyForecastCard(forecasts: weatherState.forecast),
                    const SizedBox(height: 20),
                  ],
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
