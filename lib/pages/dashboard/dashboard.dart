import 'package:cez_tower/pages/pages.dart';
import 'package:cez_tower/provider/provider.dart';
import 'package:cez_tower/services/common_methods.dart';
import 'package:cez_tower/styles/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import '../../models/models.dart';
import '../../services/services.dart';

import 'dashboard_components/dashboard_components.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  // late TooltipBehavior _tooltip;
  List<GetUserList> userList = [];
  List<ChartData>? previousDetails;
  dynamic selectedMenu;
  final global = Hive.box("login_data");
  bool loading = false;
  DateTime? nextUpdateTime;
  Duration? duration;
  List<String> moveTypeList = [];
  ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    // _tooltip = TooltipBehavior(enable: true);
    controller.addListener(() {});
    getMoveTypeList();
  }

  getMoveTypeList() async {
    moveTypeList = await GetDropDown().getDropdown('move-type');
  }

  int airCount = 0;
  int seaCount = 0;
  int roadCount = 0;
  int railCount = 0;
  int importCount = 0;
  int exportCount = 0;
  int domesticCount = 0;
  int crossCount = 0;
  Map<String, List<String>> selectedValue = {
    'moveType': [],
  };
  Map<String, List<String>> selectedValue1 = {'modeOfTransport': []};
  List<String> modeOfTransport = ['Air', 'Sea', 'Road', 'Rail'];
  table() async {
    for (String transportMode in modeOfTransport) {
      if (!mounted) return;
      selectedValue["modeOfTransport"] = [transportMode];

      int modeCount = await getCount(selectedValue);
      switch (transportMode) {
        case 'Air':
          airCount = modeCount;
          break;
        case 'Sea':
          seaCount = modeCount;
          break;
        case 'Road':
          roadCount = modeCount;
          break;
        case 'Rail':
          railCount = modeCount;
          break;
      }
    }

    for (String moveType in moveTypeList) {
      if (!mounted) return;
      selectedValue1["moveType"] = [moveType];

      int moveTypeCount = await getCount(selectedValue1);
      switch (moveType) {
        case 'Import':
          importCount = moveTypeCount;
          break;
        case 'Export':
          exportCount = moveTypeCount;
          break;
        case 'Domestic':
          domesticCount = moveTypeCount;
          break;
        case 'Cross':
          crossCount = moveTypeCount;
          break;
      }
    }
  }

  Stream<List<ChartData>> get getDetails async* {
    final provider = Provider.of<SalesProvider>(context, listen: false);
    final refreshTokenSuccess = await RefreshToken().getToken();
    List<GetUserList> remainingUserData = List.from(provider.userDataList);
    remainingUserData
        .removeWhere((user) => !provider.selectedUserList.contains(user.id));
    while (true) {
      if (refreshTokenSuccess) {
        await table();

        final currentDetails =
            await SalesChart().getSalesValue(remainingUserData);
        if (currentDetails != previousDetails) {
          duration = const Duration(minutes: 15);
          nextUpdateTime = DateTime.now().add(const Duration(minutes: 15));
          yield currentDetails;
          previousDetails = currentDetails;
        }
        await Future.delayed(const Duration(minutes: 15));
      } else {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const SplashPage()));
      }
    }
  }

  final LinearGradient customGradient = const LinearGradient(
    colors: <Color>[
      Colors.blue, // Start color
      Colors.green, // End color
    ],
    stops: <double>[
      0.0, // Start position
      1.0, // End position
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(232, 232, 232, 1),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              'assets/cargoez_with_trademark.svg',
              height: 24,
              width: 24,
            ),
          ),
          PopupMenuButton(
            initialValue: selectedMenu,
            onSelected: (item) async {
              if (item == 'logout') {
                FirebaseAuth.instance.signOut();
                Hive.box("login_data").clear();
                Hive.box("salesIdList").clear();

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const SplashPage()));
              }
              if (item == 'settings') {
                bool result = false;
                result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const Settings()));

                if (result) {
                  setState(() {
                    loading = true;
                    getDetails;
                    result = false;
                  });
                }
                await Future.delayed(const Duration(seconds: 4));
                setState(() {
                  loading = false;
                });
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                value: 'settings',
                child: Text('Settings'),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Log out'),
              ),
            ],
          ),
        ],
        title: Text(
          Hive.box('login_data').get('company_name'),
          style: Roboto.getAppFont(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color.fromRGBO(10, 122, 233, 1)),
        ),
      ),
      body: StreamBuilder<List<ChartData>>(
        stream: getDetails,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            double maximum = 0;
            for (int i = 0; i < snapshot.data!.length; i++) {
              if (maximum < snapshot.data![i].y) {
                maximum = snapshot.data![i].y.toDouble();
              }
            }
            return Visibility(
              visible: loading,
              replacement: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sales Board',
                                    style: Roboto.getAppFont(
                                        fontSize: 20,
                                        color: const Color.fromARGB(
                                            255, 41, 40, 40),
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Last Update",
                                            style: Roboto.getAppFont(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            CommonMethod().formatDate(
                                                DateTime.now().toString(),
                                                "MMM d, yyyy  h:mm a"),
                                            style: Roboto.getAppFont(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 16),
                                        child: CircularProgressBar(
                                          nextUpdate: nextUpdateTime!,
                                          updateInterval: duration!,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: SfCartesianChart(
                                enableAxisAnimation: true,
                                primaryXAxis: CategoryAxis(
                                    title: AxisTitle(
                                        textStyle: Roboto.getAppFont(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                        text: "Sales Representative")),
                                primaryYAxis: NumericAxis(
                                  labelsExtent: 10,
                                  title: AxisTitle(
                                    text: "Total Shipments",
                                    textStyle: Roboto.getAppFont(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  minimum: 0,
                                  maximum: (maximum + 1).ceil().toDouble(),
                                  interval: maximum > 0
                                      ? ((maximum + 1).ceil() / 10)
                                          .ceil()
                                          .toDouble()
                                      : 2.0,
                                  axisLine: const AxisLine(width: 1),
                                  majorGridLines:
                                      const MajorGridLines(width: 1), //
                                ),
                                // tooltipBehavior: _tooltip,
                                series: <ChartSeries<ChartData, String>>[
                                  ColumnSeries<ChartData, String>(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color.fromRGBO(132, 211, 255, 1),
                                        Color.fromRGBO(107, 175, 255, 1)
                                      ],
                                      stops: [
                                        0.0, // Start position
                                        1.0, // End position
                                      ],
                                    ),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8)),
                                    dataSource: snapshot.data!,
                                    xValueMapper: (ChartData data, _) => data.x,
                                    yValueMapper: (ChartData data, _) => data.y,
                                    dataLabelSettings: const DataLabelSettings(
                                        isVisible: true),
                                    name: 'Shipments',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 3.5,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Additional.lightblue,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ModeOfTransport(
                                                color: Additional.airColour,
                                                type: 'assets/Plane.svg',
                                                value: '$airCount'),
                                            ModeOfTransport(
                                                color: Additional.seaColour,
                                                type: 'assets/Ship.svg',
                                                value: '$seaCount'),
                                            ModeOfTransport(
                                                color: Additional.roadColour,
                                                type: 'assets/truck.svg',
                                                value: '$roadCount'),
                                            ModeOfTransport(
                                                color: Additional.railColour,
                                                type: 'assets/train.svg',
                                                value: '$railCount')
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Additional.lightviolet,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            MoveTile(
                                                type: 'IMP',
                                                value: '$importCount'),
                                            MoveTile(
                                                type: 'EXP',
                                                value: '$exportCount'),
                                            MoveTile(
                                                type: 'DOM',
                                                value: '$domesticCount'),
                                            MoveTile(
                                                type: 'CRS',
                                                value: '$crossCount'),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: RawKeyboardListener(
                              focusNode: FocusNode(),
                              onKey: (RawKeyEvent event) {
                                if (event is RawKeyDownEvent) {
                                  if (event.logicalKey ==
                                      LogicalKeyboardKey.arrowUp) {
                                    controller.animateTo(
                                      0.0,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                    );
                                  } else if (event.logicalKey ==
                                      LogicalKeyboardKey.arrowDown) {
                                    controller.animateTo(
                                      controller.offset + 50.0,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                }
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 9, top: 5),
                                        child: Text(
                                          'Top 10',
                                          style: Roboto.getAppFont(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: const Color.fromARGB(
                                                  255, 41, 40, 40)),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: ListView.separated(
                                            controller: controller,
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(height: 8),
                                            itemBuilder: (context, index) {
                                              return UserTile(
                                                index: index,
                                                name: previousDetails![index]
                                                    .name,
                                                shortcut:
                                                    previousDetails![index].x,
                                              );
                                            },
                                            itemCount: previousDetails!.length),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Something went Wrong"));
          } else {
            return const Center(child: Text("No Convertion Today"));
          }
        },
      ),
    );
  }
}
