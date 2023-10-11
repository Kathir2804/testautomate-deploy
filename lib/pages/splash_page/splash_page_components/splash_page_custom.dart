import 'package:flutter/material.dart';

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff08418C).withOpacity(1.0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint0Fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.06050625, size.height * 0.8836574);
    path_1.cubicTo(
        size.width * -0.05567344,
        size.height * 0.8316185,
        size.width * 0.02805969,
        size.height * 1.148565,
        size.width * 0.08992969,
        size.height * 1.229657);
    path_1.cubicTo(
        size.width * 0.1518000,
        size.height * 1.310759,
        size.width * 0.2389375,
        size.height * 1.287343,
        size.width * 0.2845573,
        size.height * 1.177352);
    path_1.cubicTo(
        size.width * 0.3301771,
        size.height * 1.067361,
        size.width * 0.3170036,
        size.height * 0.9124509,
        size.width * 0.2551333,
        size.height * 0.8313491);
    path_1.cubicTo(
        size.width * 0.1932635,
        size.height * 0.7502472,
        size.width * 0.1766854,
        size.height * 0.9356944,
        size.width * 0.06050625,
        size.height * 0.8836574);
    path_1.close();

    Paint paint1Fill = Paint()..style = PaintingStyle.fill;
    paint1Fill.color = const Color(0xff0B54B5).withOpacity(1.0);
    canvas.drawPath(path_1, paint1Fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.1233542, size.height * 0.8759806);
    path_2.cubicTo(
        size.width * 0.2274760,
        size.height * 0.9814815,
        size.width * 0.04350813,
        size.height * 1.106750,
        size.width * -0.03275208,
        size.height * 1.089028);
    path_2.cubicTo(
        size.width * -0.1090125,
        size.height * 1.071306,
        size.width * -0.1627635,
        size.height * 0.9471852,
        size.width * -0.1528083,
        size.height * 0.8118037);
    path_2.cubicTo(
        size.width * -0.1428536,
        size.height * 0.6764185,
        size.width * -0.07296250,
        size.height * 0.5810333,
        size.width * 0.003297661,
        size.height * 0.5987556);
    path_2.cubicTo(
        size.width * 0.07955781,
        size.height * 0.6164778,
        size.width * 0.01923193,
        size.height * 0.7704796,
        size.width * 0.1233542,
        size.height * 0.8759806);
    path_2.close();

    Paint paint2Fill = Paint()..style = PaintingStyle.fill;
    paint2Fill.color = const Color(0xff0F77FF).withOpacity(1.0);
    canvas.drawPath(path_2, paint2Fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.9942448, size.height * -0.05903333);
    path_3.cubicTo(
        size.width * 0.9849740,
        size.height * 0.07026417,
        size.width * 0.8732187,
        size.height * -0.01319907,
        size.width * 0.8212656,
        size.height * 0.1425296);
    path_3.cubicTo(
        size.width * 0.7693125,
        size.height * 0.2982583,
        size.width * 0.6850104,
        size.height * 0.05053685,
        size.width * 0.7069531,
        size.height * -0.1213000);
    path_3.cubicTo(
        size.width * 0.7288958,
        size.height * -0.2931370,
        size.width * 0.7824375,
        size.height * -0.3421093,
        size.width * 0.8548438,
        size.height * -0.3256981);
    path_3.cubicTo(
        size.width * 0.9272500,
        size.height * -0.3092870,
        size.width * 1.003516,
        size.height * -0.1883306,
        size.width * 0.9942448,
        size.height * -0.05903333);
    path_3.close();

    Paint paint3Fill = Paint()..style = PaintingStyle.fill;
    paint3Fill.color = const Color(0xffFFC733).withOpacity(1.0);
    canvas.drawPath(path_3, paint3Fill);

    Paint paint4Fill = Paint()..style = PaintingStyle.fill;
    paint4Fill.color = const Color(0xffFFC733).withOpacity(1.0);
    canvas.drawCircle(Offset(size.width * 0.9045469, size.height * 0.1492148),
        size.width * 0.02927438, paint4Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
