import 'package:flutter/material.dart';
import '../widgets/onboarding_canvas_design.dart';
import '../widgets/splash_animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({required Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final splashController = SplashAnimation(_controller);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              CustomPaint(
                child: Container(),
                painter: CanvasDesign(context: context),
              ),
              Center(
                child: ScaleTransition(
                  scale: splashController.scale,
                  child: Image.asset("assets/icons/icon.png"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
