import 'package:flutter_calculator_vohoangtuan/models/forecast_model.dart';
import 'package:flutter_calculator_vohoangtuan/models/weather_model.dart';

class WeatherState {
  final WeatherModel? currentWeather;
  final List<ForecastModel> forecast;

  WeatherState({this.currentWeather, this.forecast = const []});

  WeatherState copyWith({
    WeatherModel? currentWeather,
    List<ForecastModel>? forecast,
  }) {
    return WeatherState(
      currentWeather: currentWeather ?? this.currentWeather,
      forecast: forecast ?? this.forecast,
    );
  }
}
