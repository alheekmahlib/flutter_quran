part of '../flutter_quran_screen.dart';

class AssetsPath {
  final surahHeader =
      'packages/flutter_quran/lib/assets/images/surah_header.png';
  final besmAllah2 = 'packages/flutter_quran/lib/assets/svg/besmAllah2.svg';
  final besmAllah = 'packages/flutter_quran/lib/assets/svg/besmAllah.svg';

  ///Singleton factory
  static final AssetsPath _instance = AssetsPath._internal();

  factory AssetsPath() {
    return _instance;
  }

  AssetsPath._internal();
}
