import 'dart:convert' as convert;
import 'dart:convert';
import 'package:cez_tower/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/adapters.dart';

class GetLoginService {
  Future<bool> getLoginDetails(String token) async {
    final global = Hive.box("login_data");
    final response = await http.get(
      Uri.parse('${Environment.apiUrl}/iamserver/api/v1/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': token
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      global.put('prefix', jsonResponse['prefix']);
      global.put('userId', jsonResponse['_id']);
      global.put('companyId', jsonResponse['companyId']);
      global.put('timeZone', jsonResponse['company']['timezone']['name']);
      global.put(
          'country', jsonResponse['company']['operating_country']['name']);
      global.put('refreshToken', jsonResponse['jwt']);
      global.put('user_name', jsonResponse['name']);
      global.put('emailId', jsonResponse['emailId']);
      global.put(
          'company_name',
          jsonResponse['company']['company'] ??
              jsonResponse['company']['name']);
      global.put('islogged', true);
      global.put('alreadyLogged', true);

      return true;
    } else {
      global.put('islogged', false);
      return false;
    }
  }
}

class RefreshToken {
  Future<bool> getToken() async {
    final response = await http.get(
      Uri.parse('${Environment.apiUrl}/iamserver/api/v1/auth/token-refresh'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "${Hive.box("login_data").get("refreshToken")}"
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var results = jsonResponse['data']['jwt'];
      Hive.box("login_data").put('refreshToken', results);
      return true;
    } else {
      return false;
    }
  }
}

Future<List<GetUserList>> getUsers() async {
  final response = await http.get(
    Uri.parse('${Environment.apiUrl}/iamserver/api/v1/companies/fetch/users'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "${Hive.box("login_data").get("refreshToken")}",
    },
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    List<GetUserList> list = [];
    var data = responseData['data'];

    for (int i = 0; i < data.length; i++) {
      list.add(GetUserList(
          email: data[i]["emailId"],
          name: data[i]["name"],
          id: data[i]["_id"],
          prefix: data[i]["prefix"] ?? ""));
    }

    return list;
  } else {
    throw Exception('Failed to get user');
  }
}
