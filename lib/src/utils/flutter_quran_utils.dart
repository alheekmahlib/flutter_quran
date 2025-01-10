import 'package:flutter/material.dart';
import 'package:flutter_quran/src/extensions/surah_info_extension.dart';
import 'package:flutter_quran/src/models/ayah.dart';
import 'package:flutter_quran/src/models/bookmark.dart';
import 'package:flutter_quran/src/models/surah.dart';
import 'package:flutter_quran/src/models/surah_info_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/bookmarks_ctrl.dart';
import '../controllers/quran_ctrl.dart';
import '../models/quran_constants.dart';
import 'preferences/preferences_utils.dart';

class FlutterQuran {
  /// [init] تقوم بتهيئة القرآن ويجب استدعاؤها قبل البدء في استخدام الحزمة
  /// [init] initializes the FlutterQuran, and must be called before starting using the package

  Future<void> init(
      {List<BookmarkModel>? userBookmarks,
      bool overwriteBookmarks = false}) async {
    PreferencesUtils().preferences = await SharedPreferences.getInstance();
    // Get.put(QuranController());
    await QuranCtrl.instance.loadQuran();
    await QuranCtrl.instance.fetchSurahs();
    BookmarksCtrl.instance.initBookmarks(
        userBookmarks: userBookmarks, overwrite: overwriteBookmarks);
  }

  final quranCtrl = QuranCtrl.instance;

  /// [getCurrentPageNumber] تعيد رقم الصفحة التي يكون المستخدم عليها حاليًا.
  /// أرقام الصفحات تبدأ من 1، لذا فإن الصفحة الأولى من القرآن هي الصفحة رقم 1.
  /// [getCurrentPageNumber] Returns the page number of the page that the user is currently on.
  /// Page numbers start at 1, so the first page of the Quran is page 1.
  int getCurrentPageNumber() => quranCtrl.lastPage;

  /// [search] يبحث في القرآن عن النص المُعطى.
  /// يعيد قائمة بجميع الآيات التي تحتوي نصوصها على النص المُعطى.
  /// [search] Searches the Quran for the given text.
  ///
  /// Returns a list of all Ayahs whose text contains the given text.
  List<AyahModel> search(String text) => quranCtrl.search(text);

  /// [navigateToAyah] يتيح لك التنقل إلى أي آية.
  /// من الأفضل استدعاء هذه الطريقة أثناء عرض شاشة القرآن،
  /// وإذا تم استدعاؤها ولم تكن شاشة القرآن معروضة،
  /// فسيتم بدء العرض من صفحة هذه الآية عند فتح شاشة القرآن في المرة التالية.
  /// [navigateToAyah] let's you navigate to any ayah..
  /// It's better to call this method while Quran screen is displayed
  /// and if it's called and the Quran screen is not displayed, the next time you
  /// open quran screen it will start from this ayah's page
  void navigateToAyah(AyahModel ayah) {
    quranCtrl.animateToPage(ayah.page - 1);
    quranCtrl.toggleAyahSelection(ayah.id);
    Future.delayed(const Duration(seconds: 3))
        .then((_) => quranCtrl.toggleAyahSelection(ayah.id));
  }

  /// [navigateToPage] يتيح لك التنقل إلى أي صفحة في القرآن باستخدام رقم الصفحة.
  /// ملاحظة: تستقبل هذه الطريقة رقم الصفحة وليس فهرس الصفحة.
  /// من الأفضل استدعاء هذه الطريقة أثناء عرض شاشة القرآن،
  /// وإذا تم استدعاؤها ولم تكن شاشة القرآن معروضة،
  /// فسيتم بدء العرض من هذه الصفحة عند فتح شاشة القرآن في المرة التالية.
  /// [navigateToPage] let's you navigate to any quran page with page number
  /// Note it receives page number not page index
  /// It's better to call this method while Quran screen is displayed
  /// and if it's called and the Quran screen is not displayed, the next time you
  /// open quran screen it will start from this page
  void navigateToPage(int page) => quranCtrl.animateToPage(page - 1);

  /// [navigateToJozz] let's you navigate to any quran jozz with jozz number
  /// Note it receives jozz number not jozz index
  void navigateToJozz(int jozz) => navigateToPage(
      jozz == 1 ? 0 : (quranCtrl.quranStops[(jozz - 1) * 8 - 1]));

  /// [navigateToJozz] يتيح لك التنقل إلى أي جزء في القرآن باستخدام رقم الجزء.
  /// ملاحظة: تستقبل هذه الطريقة رقم الجزء وليس فهرس الجزء.
  /// [navigateToHizb] let's you navigate to any quran hizb with hizb number
  /// Note it receives hizb number not hizb index
  void navigateToHizb(int hizb) => navigateToPage(
      hizb == 1 ? 0 : (quranCtrl.quranStops[(hizb - 1) * 4 - 1]));

  /// [navigateToBookmark] يتيح لك التنقل إلى علامة مرجعية معينة.
  /// ملاحظة: يجب أن يكون رقم صفحة العلامة المرجعية بين 1 و604.
  /// [navigateToBookmark] let's you navigate to a certain bookmark
  /// Note that bookmark page number must be between 1 and 604
  void navigateToBookmark(BookmarkModel bookmark) {
    if (bookmark.page > 0 && bookmark.page <= 604) {
      navigateToPage(bookmark.page);
    } else {
      throw Exception("Page number must be between 1 and 604");
    }
  }

  /// [navigateToSurah] يتيح لك التنقل إلى أي سورة في القرآن باستخدام رقم السورة.
  /// ملاحظة: تستقبل هذه الطريقة رقم السورة وليس فهرس السورة.
  /// [navigateToSurah] let's you navigate to any quran surah with surah number
  /// Note it receives surah number not surah index
  void navigateToSurah(int surah) =>
      navigateToPage(quranCtrl.surahsStart[surah - 1] + 1);

  /// [getAllJozzs] returns list of all Quran jozzs' names
  List<String> getAllJozzs() => QuranConstants.quranHizbs
      .sublist(0, 30)
      .map((jozz) => "الجزء $jozz")
      .toList();

  /// [getAllJozzs] يعيد قائمة بأسماء جميع أجزاء القرآن.
  /// [getAllHizbs] returns list of all Quran hizbs' names
  List<String> getAllHizbs() =>
      QuranConstants.quranHizbs.map((jozz) => "الحزب $jozz").toList();

  /// [getSurah] يتيح لك الحصول على سورة مع جميع بياناتها.
  /// ملاحظة: تستقبل هذه الطريقة رقم السورة وليس فهرس السورة.
  /// [getSurah] let's you get a Surah with all its data
  /// Note it receives surah number not surah index
  Surah getSurah(int surah) => quranCtrl.surahs[surah - 1];

  /// [getAllSurahs] returns list of all Quran surahs' names
  List<String> getAllSurahs({bool isArabic = true}) => quranCtrl.surahs
      .map((surah) => "سورة ${isArabic ? surah.nameAr : surah.nameEn}")
      .toList();

  /// [getAllSurahs] يعيد قائمة بأسماء جميع سور القرآن.
  /// [getAllBookmarks] returns list of all bookmarks
  List<BookmarkModel> getAllBookmarks() => BookmarksCtrl.instance.bookmarks
      .sublist(0, BookmarksCtrl.instance.bookmarks.length - 1);

  /// [getUsedBookmarks] يعيد قائمة بجميع العلامات المرجعية التي استخدمها وقام بتعيينها المستخدم في صفحات القرآن.
  /// [getUsedBookmarks] returns list of all bookmarks used and set by the user in quran pages
  List<BookmarkModel> getUsedBookmarks() =>
      BookmarksCtrl.instance.bookmarks.where((b) => b.page != -1).toList();

  /// [getSurahInfo] للحصول على معلومات السورة في نافذة حوار، قم فقط باستدعاء `getSurahInfo`.
  /// مطلوب تمرير رقم السورة [surahNumber].
  /// كما أن التمرير الاختياري لنمط [SurahInfoStyle] ممكن.
  /// [getSurahInfo] to get the Surah information dialog just call getSurahInfo
  /// and required to pass the Surah number [surahNumber]
  /// and style [SurahInfoStyle] is optional.
  void getSurahInfo(SurahInfoStyle surahInfoStyle,
          {required int surahNumber}) =>
      surahInfoWidget(surahNumber - 1, surahInfoStyle);

  /// يقوم بتعيين علامة مرجعية باستخدام [ayahId] و[page] و[bookmarkId] المحددة.
  ///
  /// [ayahId] هو معرّف الآية التي سيتم حفظها.
  /// [page] هو رقم الصفحة التي تحتوي على الآية.
  /// [bookmarkId] هو معرّف العلامة المرجعية التي سيتم حفظها.
  ///
  /// لا يمكن حفظ علامة مرجعية برقم صفحة خارج النطاق من 1 إلى 604.
  /// Sets a bookmark with the given [ayahId], [page] and [bookmarkId].
  ///
  /// [ayahId] is the id of the ayah to be saved.
  /// [page] is the page number of the ayah.
  /// [bookmarkId] is the id of the bookmark to be saved.
  ///
  /// You can't save a bookmark with a page number that is not between 1 and 604.
  void setBookmark(
          {required int ayahId, required int page, required int bookmarkId}) =>
      BookmarksCtrl.instance
          .saveBookmark(ayahId: ayahId, page: page, bookmarkId: bookmarkId);

  /// يزيل علامة مرجعية من قائمة العلامات المرجعية المحفوظة للمستخدم.
  /// [bookmarkId] هو معرّف العلامة المرجعية التي سيتم إزالتها.
  /// Removes a bookmark from the list of user's saved bookmarks.
  /// [bookmarkId] is the id of the bookmark to be removed.
  void removeBookmark({required int bookmarkId}) =>
      BookmarksCtrl.instance.removeBookmark(bookmarkId);

  /// [hafsStyle] هو النمط الافتراضي للقرآن، مما يضمن عرض جميع الأحرف الخاصة بشكل صحيح.
  /// [hafsStyle] is the default style for Quran so all special characters will be rendered correctly
  final hafsStyle = const TextStyle(
    color: Colors.black,
    fontSize: 23.55,
    fontFamily: "hafs",
    package: "flutter_quran",
  );

  ///Singleton factory
  static final FlutterQuran _instance = FlutterQuran._internal();

  factory FlutterQuran() {
    return _instance;
  }

  FlutterQuran._internal();
}
