import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class CircularProgressBar extends StatefulWidget {
  const CircularProgressBar(
      {Key? key, required this.nextUpdate, required this.updateInterval})
      : super(key: key);
  final Duration updateInterval;
  final DateTime nextUpdate;
  @override
  _CircularProgressBarState createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.updateInterval,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    _controller.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          final remainingTime = widget.nextUpdate.difference(DateTime.now());
          if (remainingTime <= Duration.zero) {
            _controller.reset();
            _controller.forward();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 25,
        height: 25,
        child: CustomPaint(
          painter: CircleProgressBarPainter(_animation.value),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }
}

class CircleProgressBarPainter extends CustomPainter {
  final double progress;

  CircleProgressBarPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final backgroundPaint = Paint()
      ..color = Colors.grey[100]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;
    canvas.drawCircle(center, radius, backgroundPaint);

    final paint = Paint()
      ..color = Color.fromARGB(255, 27, 224, 66)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    final progressAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      progressAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
