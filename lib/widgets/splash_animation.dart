import 'package:flutter/material.dart';

class SplashAnimation {
  SplashAnimation(this.controller)
      : scale = Tween<double>(begin: 0.7, end: 0.9).animate(controller);

  final AnimationController controller;
  final Animation<double> scale;
}
