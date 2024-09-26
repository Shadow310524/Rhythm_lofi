import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Controller to manage the duration of the animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Adjust time for rotation
    );

    // Rotation Animation to spin the logo like an infinity symbol
    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic, // Smooth spinning curve
      ),
    );

    // Scale Animation to smoothly position the logo at its final size
    _scaleAnimation = Tween<double>(begin: 1.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack, // Elastic effect to settle in position
      ),
    );

    // Start the animation
    _controller.forward().then((_) {
      // Navigate to home screen after the animation completes
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Combine RotationTransition and ScaleTransition for the infinity spin effect
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationAnimation.value, // Rotate the logo
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Image.asset(
                          'assets/icon/lofi.png', // Your infinity logo here
                          width: 200,
                          height: 200,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30), // Space between logo and text
                const Text(
                  'Welcome to Rhythm Lofi',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
