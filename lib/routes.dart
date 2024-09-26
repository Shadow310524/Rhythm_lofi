// lib/routes.dart

import 'package:flutter/material.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/player_screen.dart';
import 'ui/screens/splash_screen.dart';
import 'song.dart'; // Ensure you import the Song class

final routes = {
  '/': (context) => const SplashScreen(), // Use const if SplashScreen is stateless

  '/home': (context) =>  HomeScreen(), // Use const if HomeScreen is stateless

  // Update the route for PlayerScreen to accept a Song parameter
  '/player': (context) => PlayerScreen(song: ModalRoute.of(context)!.settings.arguments as Song),
};
