import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_calculator_vohoangtuan/models/weather_model.dart'; // Giả định đường dẫn đúng

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Đảm bảo card full width
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ), // Cách lề màn hình
      padding: const EdgeInsets.all(24), // Tăng padding nội bộ
      decoration: BoxDecoration(
        gradient: _getWeatherGradient(weather.mainCondition),
        borderRadius: BorderRadius.circular(24), // Bo góc mềm mại
        boxShadow: [
          BoxShadow(
            color: _getShadowColor(weather.mainCondition).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8), // Đổ bóng xuống dưới
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Chỉ chiếm chiều cao cần thiết
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // City Name
          Text(
            weather.cityName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold, // In đậm tiêu đề
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis, // Xử lý tên dài
          ),

          const SizedBox(height: 5),

          // Date
          Text(
            DateFormat('EEEE, MMM d').format(weather.dateTime),
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),

          const SizedBox(height: 20),

          // Icon with Loading/Error handling
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

          // Temperature
          Text(
            '${weather.temperature.round()}°',
            style: const TextStyle(
              fontSize: 80,
              color: Colors.white,
              fontWeight: FontWeight.w300, // Font mỏng hiện đại hơn cho số to
              height:
                  1.0, // Giảm line-height mặc định để số không chiếm quá nhiều chỗ dọc
            ),
          ),

          const SizedBox(height: 10),

          // Description
          Text(
            weather.description.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2, // Tăng khoảng cách chữ cho dễ đọc
            ),
          ),

          const SizedBox(height: 5),

          // Feels Like
          Text(
            'Feels like ${weather.feelsLike.round()}°',
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

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
          colors: [Color(0xFF373B44), Color(0xFF4286f4)], // Darker Rain
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'clouds':
        return const LinearGradient(
          colors: [Color(0xFF636FA4), Color(0xFFE8CBC0)], // Cloudy sunset vibe
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

  // Hàm phụ trợ để lấy màu bóng tương ứng
  Color _getShadowColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return const Color(0xFF4A90E2);
      case 'rain':
        return const Color(0xFF373B44);
      default:
        return const Color(0xFF667EEA);
    }
  }
}
