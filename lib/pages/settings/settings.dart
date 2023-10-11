import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import '../../provider/provider.dart';
import 'settings_components/settings_components.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<String> selectedUserList = [];
  @override
  void initState() {
    super.initState();
    selectedUserList.addAll(
        Provider.of<SalesProvider>(context, listen: false).selectedUserList);
  }

  @override
  Widget build(BuildContext context) {
    final salesList = Provider.of<SalesProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            icon: const Icon(Icons.arrow_back)),
        elevation: 0,
        title: const Text("Settings"),
        actions: [
          FilledButton(
              onPressed: () {
                setState(() {
                  salesList.blockUser(selectedUserList);
                  Hive.box("salesIdList").put("userId", selectedUserList);
                });
                Navigator.pop(context, true);
              },
              child: const Text("Save"))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MultiSelectDropdown(
                options: salesList.userDataList,
                selectedOptionIds: selectedUserList,
                onSelect: (selectedIds) {
                  setState(() {
                    selectedUserList = selectedIds;
                  });
                }),
          )
        ],
      ),
    );
  }
}
