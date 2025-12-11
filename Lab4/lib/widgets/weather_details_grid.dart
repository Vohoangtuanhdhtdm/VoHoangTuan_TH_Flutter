import 'package:flutter/material.dart';
import 'package:flutter_calculator_vohoangtuan/models/weather_model.dart';
import 'package:intl/intl.dart';

class WeatherDetailsGrid extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsGrid({super.key, required this.weather});

  String _formatTime(int timestamp) {
    // API trả về timestamp dạng giây, cần * 1000 để ra milliseconds
    // Tuy nhiên OpenWeatherMap trả về UTC, cần xử lý múi giờ nếu muốn chính xác tuyệt đối
    // Ở mức cơ bản, ta cứ format theo giờ máy
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final details = [
      {
        'title': 'Humidity',
        'value': '${weather.humidity}%',
        'icon': Icons.water_drop,
      },
      {'title': 'Wind', 'value': '${weather.windSpeed} m/s', 'icon': Icons.air},
      {
        'title': 'Pressure',
        'value': '${weather.pressure} hPa',
        'icon': Icons.speed,
      },
      {
        'title': 'Sunrise',
        'value': _formatTime(weather.sunrise),
        'icon': Icons.wb_sunny_outlined,
      },
      {
        'title': 'Sunset',
        'value': _formatTime(weather.sunset),
        'icon': Icons.nightlight_round,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cột
              childAspectRatio: 2.5, // Tỷ lệ chiều rộng/cao
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: details.length,
            itemBuilder: (context, index) {
              final item = details[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(item['icon'] as IconData, color: Colors.blueGrey),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          item['value'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
