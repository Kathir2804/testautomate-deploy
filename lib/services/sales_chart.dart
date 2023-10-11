import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:math';
import 'package:cez_tower/services/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class SalesChart {
  Future<List<ChartData>> getSalesValue(List<GetUserList> userdata) async {
    final data = {
      "type": "converted",
      "stages": null,
      "start_date":
          CommonMethod().formatDate(DateTime.now().toString(), "yyyy-MM-dd"),
      "end_date":
          CommonMethod().formatDate(DateTime.now().toString(), "yyyy-MM-dd"),
      "users": [],
      "timezone": "${Hive.box("login_data").get("timeZone")}"
    };
    final filterString = jsonEncode(data);
    final response = await http.get(
      Uri.parse(
          '${Environment.apiUrl}/leadserver/api/v1/leads/summary?form=$filterString'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "${Hive.box("login_data").get("refreshToken")}"
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
      List data = jsonResponse['data'];
      List<ChartData> chartData = [];
      for (int i = 0; i < data.length; i++) {
        if (data[i].containsKey('converted') && data[i]['converted'] > 0) {
          GetUserList? foundUser;
          for (var userItem in userdata) {
            if (userItem.id == data[i]['_id']) {
              foundUser = userItem;
              break;
            }
          }
          if (foundUser != null) {
            chartData.add(ChartData(
              barColor:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
              name: foundUser.name,
              x: foundUser.prefix,
              y: data[i]['converted'],
            ));
          }
        }
      }
      chartData.sort((a, b) => b.y.compareTo(a.y));
      return chartData.length > 10 ? chartData.take(10).toList() : chartData;
    } else {
      return [];
    }
  }
}
