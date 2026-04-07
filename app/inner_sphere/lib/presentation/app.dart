import 'package:flutter/material.dart';

import 'theme_graph/home_graph_screen.dart';

class InnerSphereApp extends StatelessWidget {
  const InnerSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InnerSphere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        scaffoldBackgroundColor: const Color(0xFF0B1020),
        useMaterial3: true,
      ),
      home: const HomeGraphScreen(),
    );
  }
}
