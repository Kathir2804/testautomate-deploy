part of styles;

class Roboto {
  static TextStyle getAppFont({
    FontWeight? fontWeight,
    double? fontSize,
    Color? color,
  }) {
    return GoogleFonts.roboto(
        textStyle: TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    ));
  }
}
