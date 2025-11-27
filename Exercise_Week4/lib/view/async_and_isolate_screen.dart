import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AsyncAndIsolateScreen extends StatefulWidget {
  const AsyncAndIsolateScreen({super.key});

  @override
  AsyncAndIsolateScreenState createState() => AsyncAndIsolateScreenState();
}

class AsyncAndIsolateScreenState extends State<AsyncAndIsolateScreen> {
  String _userStatus = "Press button to load user";

  String _factorialResult = "Result will appear here";
  bool _isCalculating = false;

  Future<void> loadUser() async {
    setState(() => _userStatus = "Loading user...");
    await Future.delayed(Duration(seconds: 3));
    setState(() => _userStatus = "User loaded successfully! HeHe");
  }

  // Hàm tính giai thừa phải là hàm tĩnh (static) hoặc hàm top-level để isolate gọi được
  static BigInt calculateFactorial(int n) {
    BigInt result = BigInt.from(1);
    for (int i = 1; i <= n; i++) {
      result *= BigInt.from(i);
    }
    return result;
  }

  Future<void> runHeavyTask() async {
    setState(() {
      _isCalculating = true;
      _factorialResult = "Calculating...";
    });

    BigInt result = await compute(calculateFactorial, 30000);

    setState(() {
      _isCalculating = false;

      _factorialResult =
          "Finished! Result has ${result.toString().length} digits. HeHe";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Async Task",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(_userStatus),
          ElevatedButton(
            onPressed: loadUser,
            child: Text("Load User (3s delay)"),
          ),

          Divider(height: 40, thickness: 2),

          Text(
            "Isolate Task (Factorial)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 10),
          if (_isCalculating) CircularProgressIndicator(),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_factorialResult, textAlign: TextAlign.center),
          ),
          ElevatedButton(
            onPressed: _isCalculating ? null : runHeavyTask,
            child: Text("Calculate 30,000!"),
          ),
        ],
      ),
    );
  }
}
