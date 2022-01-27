import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sliit_eats/helpers/colors.dart';
import 'package:sliit_eats/helpers/constants.dart';

class OrderExpirationDisplay extends StatelessWidget {
  const OrderExpirationDisplay({Key? key, required this.createdDateTime})
      : super(key: key);
  final Timestamp createdDateTime;

  @override
  Widget build(BuildContext context) {
    Duration timePassed = DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(
            this.createdDateTime.millisecondsSinceEpoch));

    return Padding(
      padding: EdgeInsets.all(5),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            width: 90.0,
            height: 90.0,
            decoration: BoxDecoration(
              color: Colors.grey[850],
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 90.0,
            height: 90.0,
            child: CustomPaint(
              child: Container(),
              painter: SectorPainter(timePassed.inMinutes),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: 75.0,
            height: 75.0,
            decoration: BoxDecoration(
              color: AppColors.cardColor,
              shape: BoxShape.circle,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  (Constants.expirationPeriod - timePassed.inMinutes)
                      .toInt()
                      .toString(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'minutes',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'left',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectorPainter extends CustomPainter {
  SectorPainter(this.minutesLeft);
  final int minutesLeft;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2.0, size.height / 2.0);
    final radius = size.width;
    final rect = Rect.fromCenter(center: center, width: radius, height: radius);
    final paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.color = AppColors.success;
    final sweepAngle =
        (minutesLeft / Constants.expirationPeriod) * 360.0 * pi / 180.0;

    canvas.drawArc(rect, -0.5 * pi, sweepAngle, true, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
