import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'package:get/get.dart';

void main() => runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
        ),
        home: const MyApp(),
      ),
    );

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FlutterQuran().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const FlutterQuranScreen(
      withPageView: true,
      textColor: Colors.black,
      backgroundColor: Colors.white,
      bookmarkList: [],
    );
  }
}
