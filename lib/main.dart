import 'package:cez_tower/models/models.dart';
import 'package:cez_tower/pages/pages.dart';
import 'package:cez_tower/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('login_data');
  await Hive.openBox("salesIdList");
  await dotenv.load(fileName: Environment.fileName);
  Wakelock.enable();
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => SalesProvider())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()
      },
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        // ),
        home: SplashPage(),
      ),
    );
  }
}
