import 'dart:async';

import 'package:cez_tower/pages/pages.dart';
import 'package:cez_tower/pages/splash_page/splash_page_components/splash_page_components.dart';
import 'package:cez_tower/provider/provider.dart';
import 'package:cez_tower/services/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  List<String> id = [];
  final Box<dynamic> salesId = Hive.box("salesIdList");
  final Box<dynamic> logindata = Hive.box("login_data");

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top,
    ]);
    initConnectivity(context);
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(updateConnectionState);
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: RPSCustomPainter(),
          ),
          const Center(
            child: CircleLogoWidget(),
          ),
        ],
      ),
    );
  }

  Future<void> initConnectivity(BuildContext context) async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("Error Occurred: ${e.toString()} ");
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return updateConnectionState(result);
  }

  getToken() async {
    final auth = FirebaseAuth.instance;
    dynamic isLogged;
    final provider = Provider.of<SalesProvider>(context, listen: false);
    final refreshTokenSuccess = await RefreshToken().getToken();

    if (refreshTokenSuccess) {
      await provider.userData(); // get userlist and store provider variable
      final id = provider.userDataList
          .map((user) => user.id)
          .toList(); // retrive user id separately
      final savedUser = salesId.get('userId') ?? [];
      final commonIds = savedUser.isNotEmpty
          ? id.where((id) => savedUser.contains(id)).toList()
          : id; //compare hive stored ids and provider ids
      provider
          .blockUser(commonIds); // again commonids stored into the new provider
      salesId.put("userId", commonIds); // and also update the hive ids
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (BuildContext context) {
            return const Dashboard();
          },
        ));
      }
    } else {
      final alreadyLogged = logindata.get('alreadyLogged') ?? false;
      if (alreadyLogged) {
        auth.authStateChanges().listen((event) async {
          String? token = await event!.getIdToken();
          isLogged = await GetLoginService().getLoginDetails(token!);

          if (isLogged == true) {
            if (!mounted) return;
            await Provider.of<SalesProvider>(context, listen: false).userData();
            for (int i = 0; i < provider.userDataList.length; i++) {
              id.add(provider.userDataList[i].id);
            }
            List<String> savedUser = salesId.get('userId') ?? [];
            List<String> commonIds = savedUser.isNotEmpty
                ? id.where((id) => savedUser.contains(id)).toList()
                : id;
            provider.blockUser(commonIds);
            salesId.put("userId", commonIds);
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const Dashboard(),
              ),
            );
          }
        });
      } else {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const LoginPage(),
            ),
          );
        }
      }
    }
  }

  Future<void> updateConnectionState(ConnectivityResult result) async {
    if (mounted) {
      Timer.periodic(const Duration(seconds: 5), (timer) async {
        timer.cancel();
        if (mounted) {
          final global = Hive.box("login_data");
          bool isLogged = global.get('islogged') ?? false;
          if (isLogged) {
            await getToken();
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => const LoginPage(),
              ),
              (route) => false,
            );
          }
        }
        showStatus(result, true);
      });
    } else {
      showStatus(result, false);
    }
  }

  void showStatus(ConnectivityResult result, bool status) {
    final snackBar = SnackBar(
        duration: Duration(seconds: status ? 0 : 1),
        content: Text(
          status ? 'You are Online' : 'No Network connection',
          textAlign: TextAlign.center,
        ),
        backgroundColor: status
            ? const Color.fromARGB(255, 34, 197, 94)
            : const Color.fromARGB(255, 239, 68, 68));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
