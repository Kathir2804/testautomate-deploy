import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class CommonMethod {
  String formatDate(dynamic date, String formate) {
    if (date != null && date is String) {
      DateTime utcDateTime = DateTime.parse(date);
      final pacificTimeZone =
          tz.getLocation("${Hive.box("login_data").get("timeZone")}");
      DateTime userDateTime = tz.TZDateTime.from(utcDateTime, pacificTimeZone);
      var formatter = DateFormat(formate);
      String formattedDateTime = formatter.format(userDateTime);
      return formattedDateTime;
    }
    return "";
  }
}
