// lib/main.dart

import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(RhythmLofiApp());
}

class RhythmLofiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rhythm Lofi',
      initialRoute: '/',
      routes: routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
