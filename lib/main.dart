import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MajistralApp());
}

class MajistralApp extends StatelessWidget {
  const MajistralApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Majistral',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const HomeScreen(),
    );
  }
}
