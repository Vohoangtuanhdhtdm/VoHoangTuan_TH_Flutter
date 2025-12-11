import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/forecast_model.dart';

class DailyForecastSection extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const DailyForecastSection({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Next Days",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Hiển thị danh sách dọc
          ListView.builder(
            shrinkWrap:
                true, // Quan trọng để nằm trong SingleChildScrollView của Home
            physics:
                const NeverScrollableScrollPhysics(), // Tắt cuộn riêng để dùng cuộn của Home
            itemCount: forecasts.length,
            itemBuilder: (context, index) {
              // Logic lọc đơn giản: API trả về 3h/lần -> có thể hiển thị tất cả hoặc lọc
              // Ở đây hiển thị tất cả dạng list cho đơn giản theo Lab
              return DailyForecastCard(forecast: forecasts[index]);
            },
          ),
        ],
      ),
    );
  }
}

class DailyForecastCard extends StatelessWidget {
  final ForecastModel forecast;

  const DailyForecastCard({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Ngày tháng
          Expanded(
            flex: 2,
            child: Text(
              DateFormat('EEE, MMM d').format(forecast.dateTime),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          // Nhiệt độ
          Expanded(
            flex: 1,
            child: Text(
              '${forecast.temperature.round()}°',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // Icon và trạng thái
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CachedNetworkImage(
                  imageUrl:
                      'https://openweathermap.org/img/wn/${forecast.icon}.png',
                  height: 30,
                  width: 30,
                ),
                const SizedBox(width: 5),
                Flexible(
                  // Tránh lỗi overflow text
                  child: Text(
                    forecast.description,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
