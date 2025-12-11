import 'package:flutter/material.dart';
import 'package:flutter_calculator_vohoangtuan/models/weather_model.dart';

class WeatherDetailsSection extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsSection({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          GridView.count(
            crossAxisCount: 2, // 2 cột
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5, // Tỷ lệ khung hình chữ nhật
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            children: [
              WeatherDetailItem(
                icon: Icons.water_drop_outlined,
                title: "Humidity",
                value: "${weather.humidity}%",
                color: Colors.blueAccent,
              ),
              WeatherDetailItem(
                icon: Icons.air,
                title: "Wind",
                value: "${weather.windSpeed} m/s",
                color: Colors.green,
              ),
              WeatherDetailItem(
                icon: Icons.speed,
                title: "Pressure",
                value: "${weather.pressure} hPa",
                color: Colors.orange,
              ),
              WeatherDetailItem(
                icon: Icons.visibility_outlined,
                title: "Visibility",
                // Xử lý null nếu visibility không có
                value: "${(weather.visibility ?? 0) / 1000} km",
                color: Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WeatherDetailItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const WeatherDetailItem({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            radius: 18,
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
