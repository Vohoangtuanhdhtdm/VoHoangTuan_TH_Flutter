import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/forecast_model.dart';

class DailyForecastCard extends StatelessWidget {
  final List<ForecastModel> forecasts;

  const DailyForecastCard({super.key, required this.forecasts});

  List<Map<String, dynamic>> _processDailyForecast() {
    final Map<String, List<ForecastModel>> groupedData = {};

    for (var item in forecasts) {
      final dateKey = DateFormat('yyyy-MM-dd').format(item.dateTime);
      if (!groupedData.containsKey(dateKey)) {
        groupedData[dateKey] = [];
      }
      groupedData[dateKey]!.add(item);
    }

    final List<Map<String, dynamic>> dailyList = [];
    groupedData.forEach((key, list) {
      double minTemp = list.first.tempMin;
      double maxTemp = list.first.tempMax;

      String icon = list.length > 4 ? list[4].icon : list[0].icon;

      for (var item in list) {
        if (item.tempMin < minTemp) minTemp = item.tempMin;
        if (item.tempMax > maxTemp) maxTemp = item.tempMax;
      }

      dailyList.add({
        'date': list.first.dateTime,
        'min': minTemp,
        'max': maxTemp,
        'icon': icon,
        'description': list.first.description,
      });
    });

    return dailyList.skip(1).take(5).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dailyData = _processDailyForecast();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Next 5 Days",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...dailyData.map((day) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      DateFormat('EEEE').format(day['date']),
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://openweathermap.org/img/wn/${day['icon']}@2x.png',
                      height: 30,
                      width: 30,
                    ),
                  ),
                  // Min / Max Temp
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${day['max'].round()}°',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${day['min'].round()}°',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
