import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefScreen extends StatefulWidget {
  const SharedPrefScreen({super.key});

  @override
  SharedPrefScreenState createState() => SharedPrefScreenState();
}

class SharedPrefScreenState extends State<SharedPrefScreen> {
  final TextEditingController _controller = TextEditingController();
  String _savedName = "No data";

  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _controller.text);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Name Saved!")));
  }

  Future<void> _showName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('username') ?? "No data available";
    });
  }

  Future<void> _clearName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    setState(() {
      _savedName = "No data";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Enter Name"),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: _saveName, child: Text("Save Name")),
              ElevatedButton(onPressed: _showName, child: Text("Show Name")),
            ],
          ),
          SizedBox(height: 20),
          Text(
            "Saved Name: $_savedName",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          TextButton(
            onPressed: _clearName,
            child: Text("Clear Data", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
