import 'package:flutter/material.dart';
import 'package:flutter_quran/flutter_quran.dart';

void main() => runApp(
      MaterialApp(
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
      basmallahColor: Colors.black,
      basmallahWidth: 150.0,
      basmallahHeight: 30.0,
      isSvg: false,
      bannerSvgPath: '',
      bannerSvgHeight: 40.0,
      bannerSvgWidth: 150.0,
      bannerImagePath: null,
      bannerImageHeight: null,
      bannerImageWidth: null,
      textColor: Colors.white,
      surahNameColor: Colors.white,
      bookmarkList: [],
    );
  }
}
