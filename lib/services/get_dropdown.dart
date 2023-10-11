import 'dart:convert';
import 'package:cez_tower/models/models.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class GetDropDown {
  Future<List<String>> getDropdown(String filterKey) async {
    List<String> filterOption = [];

    final response = await http.get(
        Uri.parse('${Environment.apiUrl}/master/api/v1/dropdown/$filterKey'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "${Hive.box("login_data").get("refreshToken")}",
        });

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      var value = responseData['data'];
      filterOption =
          value.map<String>((item) => item['name'].toString()).toList();
    }

    return filterOption;
  }
}
