import 'package:flutter/material.dart';
import 'screens/game_screen.dart';

void main() {
  runApp(const CandyCrushApp());
}

class CandyCrushApp extends StatelessWidget {
  const CandyCrushApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Candy Crush',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
