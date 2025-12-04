import 'package:flutter/material.dart';

class GridViewScreen extends StatelessWidget {
  const GridViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Grid View Exercise")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Fixed Column Grid",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 300,
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
                padding: EdgeInsets.all(8),
                children: List.generate(
                  6,
                  (index) => _buildGridItem(index, "Item"),
                ),
              ),
            ),

            Divider(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Responsive Grid",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 300,
              child: GridView.extent(
                maxCrossAxisExtent: 150,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.8,
                padding: EdgeInsets.all(8),
                children: List.generate(
                  6,
                  (index) => _buildGridItem(index, "Item"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(int index, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber[100 * ((index % 9) + 1)],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 40),
          SizedBox(height: 8),
          Text("$label ${index + 1}"),
        ],
      ),
    );
  }
}
