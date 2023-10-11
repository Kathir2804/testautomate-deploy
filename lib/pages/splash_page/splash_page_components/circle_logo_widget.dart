import 'package:cez_tower/pages/splash_page/splash_page_components/logo_widget.dart';
import 'package:flutter/material.dart';

class CircleLogoWidget extends StatelessWidget {
  const CircleLogoWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height / 5,
          bottom: MediaQuery.of(context).size.height / 3,
          left: -50,
          right: -50,
          child: const LogoWidget(),
        ),
      ],
    );
  }
}
