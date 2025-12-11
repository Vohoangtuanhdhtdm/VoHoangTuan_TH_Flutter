import 'package:flutter_calculator_vohoangtuan/models/weather_state.dart';
import 'package:flutter_calculator_vohoangtuan/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final weatherProvider = AsyncNotifierProvider<WeatherNotifier, WeatherState>(
  () {
    return WeatherNotifier();
  },
);

class WeatherNotifier extends AsyncNotifier<WeatherState> {
  // Hàm build() khởi tạo state ban đầu
  @override
  Future<WeatherState> build() async {
    return WeatherState();
  }

  // Fetch theo thành phố
  Future<void> fetchWeatherByCity(String cityName) async {
    // Set state về loading
    state = const AsyncValue.loading();

    // Thực hiện logic và bắt lỗi tự động với AsyncValue.guard
    state = await AsyncValue.guard(() async {
      final weatherService = ref.read(weatherServiceProvider);
      final storageService = ref.read(storageServiceProvider);

      final current = await weatherService.getCurrentWeatherByCity(cityName);
      final forecast = await weatherService.getForecast(cityName);

      // Lưu cache
      await storageService.saveWeatherData(current);

      return WeatherState(currentWeather: current, forecast: forecast);
    });
  }

  // Fetch theo vị trí hiện tại
  Future<void> fetchWeatherByLocation() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final weatherService = ref.read(weatherServiceProvider);
      final locationService = ref.read(locationServiceProvider);
      final storageService = ref.read(storageServiceProvider);

      try {
        final position = await locationService.getCurrentLocation();

        final current = await weatherService.getCurrentWeatherByCoordinates(
          position.latitude,
          position.longitude,
        );

        final cityName = await locationService.getCityName(
          position.latitude,
          position.longitude,
        );

        final forecast = await weatherService.getForecast(cityName);

        await storageService.saveWeatherData(current);

        return WeatherState(currentWeather: current, forecast: forecast);
      } catch (e) {
        // Nếu lỗi location/mạng, thử load cache
        final cached = await storageService.getCachedWeather();
        if (cached != null) {
          // Lưu ý: Cache cũ của bạn chỉ lưu WeatherModel, không lưu Forecast
          // Nên ở đây forecast có thể rỗng hoặc bạn cần sửa StorageService để cache cả 2
          return WeatherState(currentWeather: cached, forecast: []);
        }
        rethrow; // Ném lỗi tiếp để UI hiển thị nếu không có cache
      }
    });
  }

  // Refresh lại dữ liệu đang có
  Future<void> refreshWeather() async {
    final currentState = state.value;
    if (currentState?.currentWeather != null) {
      await fetchWeatherByCity(currentState!.currentWeather!.cityName);
    } else {
      await fetchWeatherByLocation();
    }
  }
}
