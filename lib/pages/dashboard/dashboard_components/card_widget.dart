import 'package:cez_tower/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ModeOfTransport extends StatelessWidget {
  const ModeOfTransport(
      {super.key,
      required this.type,
      required this.value,
      required this.color});
  final String type;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(type,
              height: 18,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
          const SizedBox(height: 5),
          Text(
            value,
            style: Roboto.getAppFont(
                fontSize: 16,
                color: Additional.black,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class MoveTile extends StatelessWidget {
  const MoveTile({super.key, required this.type, required this.value});
  final String type;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            type,
            style: Roboto.getAppFont(
                fontSize: 14,
                color: Additional.darkViolet,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: Roboto.getAppFont(
                fontSize: 16,
                color: Additional.black,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
