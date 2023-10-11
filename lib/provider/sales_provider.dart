import 'package:cez_tower/models/models.dart';
import 'package:cez_tower/services/services.dart';
import 'package:flutter/material.dart';

class SalesProvider extends ChangeNotifier {
  List<GetUserList> userDataList = [];
  List<String> selectedUserList = [];

  Future<void> userData() async {
    userDataList = await getUsers();
    userDataList.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  Future<void> blockUser(List<String> data) async {
    selectedUserList = data;
    notifyListeners();
  }
}
