import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class UserTile extends StatelessWidget {
  const UserTile(
      {super.key,
      required this.name,
      required this.shortcut,
      required this.index});
  final String name;
  final String shortcut;

  final int index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        children: [
          const SizedBox(
            width: 7,
          ),
          if (index == 0)
            SvgPicture.asset(
              'assets/gold.svg',
              height: 25,
              width: 25,
            )
          else if (index == 1)
            SvgPicture.asset(
              'assets/silver.svg',
              height: 25,
              width: 25,
            )
          else if (index == 2)
            SvgPicture.asset(
              'assets/bronze.svg',
              height: 25,
              width: 25,
            )
          else
            CircleAvatar(
              maxRadius: 11,
              backgroundColor: const Color.fromRGBO(104, 188, 215, 1),
              child: Text(
                shortcut,
                style: GoogleFonts.roboto(
                    color: const Color.fromRGBO(255, 255, 255, 1),
                    fontSize: 10,
                    fontWeight: FontWeight.w400),
              ),
            ),
          const SizedBox(width: 10),
          Text(
            name,
            style:
                GoogleFonts.roboto(fontSize: 13, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
