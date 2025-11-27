import 'package:flutter/material.dart';
import 'package:flutter_calculator_vohoangtuan/data/notifiers.dart';
import 'package:flutter_calculator_vohoangtuan/view/async_and_isolate_screen.dart';
import 'package:flutter_calculator_vohoangtuan/view/contact_list_screen.dart';
import 'package:flutter_calculator_vohoangtuan/view/grid_view_screen.dart';
import 'package:flutter_calculator_vohoangtuan/view/shared_pref_screen.dart';
import 'package:flutter_calculator_vohoangtuan/widgets/navbar_widget.dart';

List<Widget> pages = [
  ContactListScreen(),
  GridViewScreen(),
  SharedPrefScreen(),
  AsyncAndIsolateScreen(),
];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavbarWidget(),
      body: ValueListenableBuilder(
        valueListenable: selectPageNotifier,
        builder: (context, value, child) {
          return pages.elementAt(value);
        },
      ),
    );
  }
}
