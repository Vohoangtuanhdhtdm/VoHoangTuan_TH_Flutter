import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
// Import đúng đường dẫn model và provider settings của bạn
import 'package:flutter_calculator_vohoangtuan/models/weather_model.dart';
import 'package:flutter_calculator_vohoangtuan/providers/settings_provider.dart';

class CurrentWeatherCard extends ConsumerWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Lắng nghe trạng thái độ C/F từ Settings Provider
    // Nếu file provider của bạn chưa có, nó sẽ báo đỏ.
    // Hãy đảm bảo bạn đã tạo file settings_provider.dart như hướng dẫn trước.
    final isCelsius = ref.watch(unitProvider);

    // Hàm local để chuyển đổi nhiệt độ hiển thị
    int getDisplayTemp(double temp) {
      if (isCelsius) {
        return temp.round();
      } else {
        return ((temp * 9 / 5) + 32).round();
      }
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: _getWeatherGradient(weather.mainCondition),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _getShadowColor(weather.mainCondition).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Tên thành phố
          Text(
            weather.cityName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(0, 1),
                  blurRadius: 2,
                  color: Colors.black26,
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 5),

          // 2. Ngày tháng
          Text(
            DateFormat('EEEE, MMM d').format(weather.dateTime),
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),

          const SizedBox(height: 20),

          // 3. Ảnh thời tiết (Icon)
          CachedNetworkImage(
            imageUrl:
                'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
            height: 120,
            width: 120,
            fit: BoxFit.contain,
            placeholder: (context, url) => const SizedBox(
              height: 120,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white30),
              ),
            ),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: Colors.white, size: 50),
          ),

          // 4. Nhiệt độ chính (Đã xử lý logic C/F)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${getDisplayTemp(weather.temperature)}',
                style: const TextStyle(
                  fontSize: 80,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  height: 1.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  isCelsius ? '°C' : '°F',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 5. Mô tả thời tiết
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 5),

          // 6. Cảm giác như (Đã xử lý logic C/F)
          Text(
            'Feels like ${getDisplayTemp(weather.feelsLike)}°',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  // Helper: Màu nền Gradient dựa trên thời tiết
  LinearGradient _getWeatherGradient(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'rain':
      case 'drizzle':
      case 'thunderstorm':
        return const LinearGradient(
          colors: [Color(0xFF373B44), Color(0xFF4286f4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'clouds':
        return const LinearGradient(
          colors: [Color(0xFF636FA4), Color(0xFFE8CBC0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'snow':
        return const LinearGradient(
          colors: [Color(0xFF83a4d4), Color(0xFFb6fbff)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  // Helper: Màu bóng đổ (Shadow)
  Color _getShadowColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return const Color(0xFF4A90E2);
      case 'rain':
      case 'thunderstorm':
        return const Color(0xFF373B44);
      case 'clouds':
        return const Color(0xFF636FA4);
      default:
        return const Color(0xFF667EEA);
    }
  }
}
