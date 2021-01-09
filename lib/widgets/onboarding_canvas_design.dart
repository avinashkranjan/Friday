import 'package:flutter/material.dart';
import 'package:class_manager/constants.dart';

class CanvasDesign extends CustomPainter {
  final BuildContext context;
  CanvasDesign({this.context});

  @override
  void paint(Canvas canvas, Size size) {
    Offset smallestCircleCenter = Offset(size.width * .93, size.height * 0.035),
        mediumCircleCenter = Offset(size.width * .85, size.height * 0.12),
        largestCircleCenter = Offset(size.width * .7, size.height * 0.05);

    final paint = Paint()
      ..color = Theme.of(context).accentColor.withGreen(100)
      ..style = PaintingStyle.fill;

    final sideCurve = new Path()
      ..moveTo(size.width * .45, 0)
      ..quadraticBezierTo(
        size.width * .6,
        size.height * 0.15,
        0,
        size.height * .22,
      )
      ..lineTo(0, 0)
      ..close();
    // Closed Curve
    canvas.drawPath(sideCurve, paint);
    // Circles
    //smallest
    canvas.drawCircle(smallestCircleCenter, smallestCircleRadius, paint);
    //medium
    canvas.drawCircle(mediumCircleCenter, mediumCircleRadius, paint);
    //largest
    canvas.drawCircle(largestCircleCenter, largestCircleRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
