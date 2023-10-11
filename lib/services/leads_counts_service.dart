import 'dart:convert';
import 'package:cez_tower/services/common_methods.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/environment.dart';

Future getCount(Map<String, List<String>> choice) async {
  String timeZone = Hive.box("login_data").get("timeZone");
  String formString;

  Map<String, dynamic> filter = {
    "moveType": {
      "type": "===",
      "searchText": choice["moveType"],
      "field": "routing.moveType",
      "fieldType": "list",
      "displayName": "Move Type",
      "enabled": choice['moveType']!.isNotEmpty ? true : false
    },
    "estimateCreatedAt": {
      "type": "between",
      "searchText": [
        CommonMethod().formatDate(DateTime.now().toString(), "yyyy-MM-dd"),
        CommonMethod().formatDate(DateTime.now().toString(), "yyyy-MM-dd"),
      ],
      "field": "shipments.createdAt",
      "fieldType": "date",
      "displayName": "Estimate Created Date",
      "enabled": true
    },
    "modeOfTransport": {
      "type": "===",
      "searchText": choice["modeOfTransport"],
      "field": "routing.modeOfTransport",
      "fieldType": "list",
      "displayName": "Mode of Transport",
      "enabled": choice['modeOfTransport']!.isNotEmpty ? true : false
    },
  };
  formString = jsonEncode(filter);

  final response = await http.get(
      Uri.parse(
          '${Environment.apiUrl}/leadserver/api/v1/leads/filter/paginate/count?form=$formString&timezone=$timeZone'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "${Hive.box("login_data").get("refreshToken")}",
      });

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);

    var value = responseData['data'];
    final totalCount = value[0] != 'null' ? value[0]['totalCount'] : 0;

    return totalCount;
  }
}
