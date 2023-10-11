import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 8,
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/cargoez_logo.svg',
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.modulate,
          ),
          height: 50,
        ),
      ),
    );
  }
}
