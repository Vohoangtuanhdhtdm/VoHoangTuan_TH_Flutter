import 'package:flutter_calculator_vohoangtuan/config/api_config.dart';
import 'package:flutter_calculator_vohoangtuan/services/location_service.dart';
import 'package:flutter_calculator_vohoangtuan/services/storage_service.dart';
import 'package:flutter_calculator_vohoangtuan/services/weather_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final weatherServiceProvider = Provider<WeatherService>((ref) {
  return WeatherService(apiKey: ApiConfig.apiKey);
});

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});
