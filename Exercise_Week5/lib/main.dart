import 'package:flutter/material.dart';

import 'package:flutter_calculator_vohoangtuan/providers/note_provider.dart';
import 'package:flutter_calculator_vohoangtuan/screens/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteProvider()..loadNotes(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Simple Note App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
