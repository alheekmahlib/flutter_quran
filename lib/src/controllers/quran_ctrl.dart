import 'package:flutter/material.dart';
import 'package:flutter_quran/src/models/surah.dart';
import 'package:get/get.dart';

import '../models/ayah.dart';
import '../models/quran_page.dart';
import '../repository/quran_repository.dart';

class QuranCtrl extends GetxController {
  static QuranCtrl get instance => Get.isRegistered<QuranCtrl>()
      ? Get.find<QuranCtrl>()
      : Get.put<QuranCtrl>(QuranCtrl());
  QuranCtrl({QuranRepository? quranRepository})
      : _quranRepository = quranRepository ?? QuranRepository(),
        super();

  final QuranRepository _quranRepository;

  RxList<QuranPage> staticPages = <QuranPage>[].obs;
  RxList<int> quranStops = <int>[].obs;
  RxList<int> surahsStart = <int>[].obs;
  RxList<Surah> surahs = <Surah>[].obs;
  final RxList<Ayah> ayahs = <Ayah>[].obs;
  int lastPage = 1;
  int? initialPage;
  RxList<Ayah> ayahsList = <Ayah>[].obs;
  var selectedAyahIndexes = <int>[].obs;
  bool isAyahSelected = false;
  RxDouble scaleFactor = 1.0.obs;
  RxDouble baseScaleFactor = 1.0.obs;

  PageController _pageController = PageController();

  // @override
  // void onInit() {
  //   loadQuran();
  //   super.onInit();
  // }

  Future<void> loadQuran({quranPages = QuranRepository.hafsPagesNumber}) async {
    lastPage = _quranRepository.getLastPage() ?? 1;
    if (lastPage != 0) {
      _pageController = PageController(initialPage: lastPage - 1);
    }
    if (staticPages.isEmpty || quranPages != staticPages.length) {
      staticPages.value = List.generate(quranPages,
          (index) => QuranPage(pageNumber: index + 1, ayahs: [], lines: []));
      final quranJson = await _quranRepository.getQuran();
      int hizb = 1;
      int surahsIndex = 1;
      List<Ayah> thisSurahAyahs = [];
      for (int i = 0; i < quranJson.length; i++) {
        final ayah = Ayah.fromJson(quranJson[i]);
        if (ayah.surahNumber != surahsIndex) {
          surahs.last.endPage = ayahs.last.page;
          surahs.last.ayahs = thisSurahAyahs;
          surahsIndex = ayah.surahNumber;
          thisSurahAyahs = [];
        }
        ayahs.add(ayah);
        thisSurahAyahs.add(ayah);
        staticPages[ayah.page - 1].ayahs.add(ayah);
        if (ayah.ayah.contains('۞')) {
          staticPages[ayah.page - 1].hizb = hizb++;
          quranStops.add(ayah.page);
        }
        if (ayah.ayah.contains('۩')) {
          staticPages[ayah.page - 1].hasSajda = true;
        }
        if (ayah.ayahNumber == 1) {
          ayah.ayah = ayah.ayah.replaceAll('۞', '');
          staticPages[ayah.page - 1].numberOfNewSurahs++;
          surahs.add(Surah(
              index: ayah.surahNumber,
              startPage: ayah.page,
              endPage: 0,
              nameEn: ayah.surahNameEn,
              nameAr: ayah.surahNameAr,
              ayahs: []));
          surahsStart.add(ayah.page - 1);
        }
      }
      surahs.last.endPage = ayahs.last.page;
      surahs.last.ayahs = thisSurahAyahs;
      for (QuranPage staticPage in staticPages) {
        List<Ayah> ayas = [];
        for (Ayah aya in staticPage.ayahs) {
          if (aya.ayahNumber == 1 && ayas.isNotEmpty) {
            ayas.clear();
          }
          if (aya.ayah.contains('\n')) {
            final lines = aya.ayah.split('\n');
            for (int i = 0; i < lines.length; i++) {
              bool centered = false;
              if ((aya.centered && i == lines.length - 2)) {
                centered = true;
              }
              final a = Ayah.fromAya(
                  ayah: aya,
                  aya: lines[i],
                  ayaText: lines[i],
                  centered: centered);
              ayas.add(a);
              if (i < lines.length - 1) {
                staticPage.lines.add(Line([...ayas]));
                ayas.clear();
              }
            }
          } else {
            ayas.add(aya);
          }
        }
        ayas.clear();
      }
      update();
    }
  }

  List<Ayah> search(String searchText) {
    if (searchText.isEmpty) {
      return [];
    } else {
      final filteredAyahs = ayahs
          .where((aya) => aya.ayahText.contains(searchText.trim()))
          .toList();
      return filteredAyahs;
    }
  }

  saveLastPage(int lastPage) {
    this.lastPage = lastPage;
    _quranRepository.saveLastPage(lastPage);
  }

  animateToPage(int page) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(page,
          duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
    } else {
      _pageController = PageController(initialPage: page);
    }
  }

  get pageController => _pageController;

  void toggleAyahSelection(int index) {
    if (selectedAyahIndexes.contains(index)) {
      selectedAyahIndexes.remove(index);
      update();
    } else {
      selectedAyahIndexes.clear();
      selectedAyahIndexes.add(index);
      selectedAyahIndexes.refresh();
      update();
    }
    selectedAyahIndexes.refresh();
    update();
  }

  void clearSelection() {
    selectedAyahIndexes.clear();
    update();
  }

  dynamic textScale(dynamic widget1, dynamic widget2) {
    if (scaleFactor.value <= 1.3) {
      return widget1;
    } else {
      return widget2;
    }
  }

  void updateTextScale(ScaleUpdateDetails details) {
    double newScaleFactor = baseScaleFactor.value * details.scale;
    if (newScaleFactor < 1.0) {
      newScaleFactor = 1.0;
    }
    scaleFactor.value = newScaleFactor;
  }
}
