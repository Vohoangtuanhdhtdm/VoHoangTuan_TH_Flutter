import 'package:flutter/material.dart';
import 'package:flutter_calculator_vohoangtuan/data/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectPageNotifier,
      builder: (context, selected, child) {
        return NavigationBar(
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.play_lesson),
              label: "Bài 1",
            ),
            NavigationDestination(
              icon: Icon(Icons.play_lesson),
              label: "Bài 2",
            ),
            NavigationDestination(
              icon: Icon(Icons.play_lesson),
              label: "Bài 3",
            ),
            NavigationDestination(
              icon: Icon(Icons.play_lesson),
              label: "Bài 4&5",
            ),
          ],
          onDestinationSelected: (int index) {
            selectPageNotifier.value = index;
          },
          selectedIndex: selected,
        );
      },
    );
  }
}
