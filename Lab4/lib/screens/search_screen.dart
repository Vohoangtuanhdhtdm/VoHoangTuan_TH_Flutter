import 'package:flutter/material.dart';
import 'package:flutter_calculator_vohoangtuan/providers/weather_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  void _searchCity() {
    if (_controller.text.isNotEmpty) {
      ref.read(weatherProvider.notifier).fetchWeatherByCity(_controller.text);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search City"), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter city name (e.g., Hanoi)',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _controller.clear(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onSubmitted: (_) => _searchCity(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _searchCity,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text("Get Weather", style: TextStyle(fontSize: 16)),
            ),

            const SizedBox(height: 30),
            const Text(
              "Popular Cities",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            Wrap(
              spacing: 10,
              children: ["London", "New York", "Tokyo", "Ho Chi Minh"].map((
                city,
              ) {
                return ActionChip(
                  label: Text(city),
                  onPressed: () {
                    ref.read(weatherProvider.notifier).fetchWeatherByCity(city);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
