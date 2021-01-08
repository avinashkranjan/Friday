import 'package:flutter/material.dart';

import '../constants.dart';

class MyPainter extends CustomPainter {
  final BuildContext context;
  MyPainter({this.context});

  @override
  void paint(Canvas canvas, Size size) {
    //TODO: Remove magic numbers
    Offset smallestCircleCenter = Offset(size.width * .87, size.height * 0.03),
        mediumCircleCenter = Offset(size.width * .80, size.height * 0.12),
        largestCircleCenter = Offset(size.width * .65, size.height * 0.05);

    final paint = Paint()
      ..color = Theme.of(context).accentColor
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
