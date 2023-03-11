import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinterest_nav_bar/pinterest_nav_bar.dart';

import 'constants.dart';
import 'home/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final s = await getApplicationDocumentsDirectory();
  Hive.init(s.path);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return PinterestNavBarController(
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CMDA bulkSMS',
        theme: primaryTheme,
        home: const HomePage(),
      ),
    );
  }
}
