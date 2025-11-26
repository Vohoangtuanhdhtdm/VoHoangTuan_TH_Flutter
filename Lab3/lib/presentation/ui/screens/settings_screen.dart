import 'package:flutter/material.dart';
import 'package:flutter_calculator_vohoangtuan/presentation/theme/theme_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Cài đặt")),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Giao diện",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            title: const Text("Chế độ Tối (Dark Mode)"),
            subtitle: const Text("Giao diện nền đen giúp bảo vệ mắt"),
            value: themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeNotifier.toggleTheme(value);
            },
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Dữ liệu",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text("Xóa toàn bộ lịch sử"),
            onTap: () {
              // Hiển thị dialog xác nhận
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text("Xác nhận"),
                  content: const Text(
                    "Bạn có chắc muốn xóa toàn bộ lịch sử tính toán không?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text("Hủy"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Đã xóa lịch sử!")),
                        );
                      },
                      child: const Text(
                        "Xóa",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const Divider(),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Thông tin",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),

          const ListTile(
            leading: Icon(Icons.person_outline),
            title: Text("Tác giả"),
            trailing: Text("Võ Hoàng Tuấn"),
          ),
        ],
      ),
    );
  }
}
