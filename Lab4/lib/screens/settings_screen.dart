import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCelsius = ref.watch(unitProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.thermostat),
            title: const Text("Temperature Unit"),
            subtitle: Text(isCelsius ? "Celsius (°C)" : "Fahrenheit (°F)"),
            trailing: Switch(
              value: isCelsius,
              onChanged: (value) {
                ref.read(unitProvider.notifier).toggleUnit();
              },
            ),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("About"),
            subtitle: Text("Weather App v1.0 - Student Project"),
          ),
        ],
      ),
    );
  }
}
