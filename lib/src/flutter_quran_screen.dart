import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quran/flutter_quran.dart';
import 'package:flutter_quran/src/utils/string_extensions.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'controllers/bookmarks_ctrl.dart';
import 'controllers/quran_ctrl.dart';
import 'models/quran_constants.dart';
import 'models/quran_page.dart';

part 'utils/assets_path.dart';
part 'utils/toast_utils.dart';
part 'widgets/ayah_long_click_dialog.dart';
part 'widgets/bsmallah_widget.dart';
part 'widgets/default_drawer.dart';
part 'widgets/quran_line.dart';
part 'widgets/quran_page_bottom_info.dart';
part 'widgets/surah_header_widget.dart';

class FlutterQuranScreen extends StatelessWidget {
  const FlutterQuranScreen(
      {this.showBottomWidget = true,
      this.useDefaultAppBar = true,
      this.bottomWidget,
      this.appBar,
      this.onPageChanged,
      super.key,
      required this.basmallahColor,
      this.basmallahWidth,
      this.basmallahHeight,
      this.bannerImagePath,
      this.bannerImageWidth,
      this.bannerImageHeight,
      required this.isSvg,
      required this.bannerSvgPath,
      this.bannerSvgWidth,
      this.bannerSvgHeight,
      required this.withPageView,
      this.pageIndex,
      this.bookmarksColor,
      this.onAyahLongPress,
      this.textColor,
      this.surahNumber,
      required this.surahNameColor,
      this.ayahSelectedBackgroundColor,
      this.surahNameWidth,
      this.surahNameHeight,
      this.bookmarkList,
      this.onSurahBannerLongPress,
      this.onAyahPress});

  ///[showBottomWidget] is a bool to disable or enable the default bottom widget
  final bool showBottomWidget;

  ///[showBottomWidget] is a bool to disable or enable the default bottom widget
  final bool useDefaultAppBar;

  ///[bottomWidget] if if provided it will replace the default bottom widget
  final Widget? bottomWidget;

  ///[appBar] if if provided it will replace the default app bar
  final PreferredSizeWidget? appBar;

  ///[onPageChanged] if provided it will be called when a quran page changed
  final Function(int)? onPageChanged;

  ///[basmallahColor] It is required to add the color for the basmalah
  final Color basmallahColor;

  ///[basmallahWidth] if you wanna add the width for the basmalah
  final double? basmallahWidth;

  ///[basmallahHeight] if you wanna add the height for the basmalah
  final double? basmallahHeight;

  ///[bannerImagePath] if you wanna add banner as image you can provide the path
  final String? bannerImagePath;

  ///[bannerImageWidth] if you wanna add the width for the banner image
  final double? bannerImageWidth;

  ///[bannerImageHeight] if you wanna add the height for the banner image
  final double? bannerImageHeight;

  ///[isSvg] if you wanna add banner as svg you can set it to true
  final bool isSvg;

  ///[bannerSvgPath] if you wanna add banner as svg you can provide the path
  final String bannerSvgPath;

  ///[bannerSvgWidth] if you wanna add the width for the banner svg
  final double? bannerSvgWidth;

  ///[bannerSvgHeight] if you wanna add the height for the banner svg
  final double? bannerSvgHeight;

  ///[withPageView] Enable this variable if you want to display the Quran with PageView
  final bool withPageView;

  ///[pageIndex] pass the page number if you do not want to display the Quran with PageView
  final int? pageIndex;

  ///[bookmarksColor] Change the bookmark color (optional)
  final Color? bookmarksColor;

  ///[onAyahLongPress] When you long press on any verse, you can add some features, such as copying the verse, sharing it, etc
  final Function? onAyahLongPress;

  ///[onSurahBannerLongPress] When you long press on any Surah banner, you can add some details about the surah
  final Function? onSurahBannerLongPress;

  ///[onAyahPress] When you press on any verse, you can add some features, such as copying the verse, sharing it, etc
  final Function? onAyahPress;

  ///[textColor] You can pass the color of the Quran text
  final Color? textColor;

  ///[surahNumber] You can pass the color of the Surah number
  final int? surahNumber;

  ///[surahNameColor] You can pass the color of the Surah number color
  final Color surahNameColor;

  ///[ayahSelectedBackgroundColor] You can pass the color of the Ayah selected background color
  final Color? ayahSelectedBackgroundColor;

  ///[surahNameWidth] if you wanna add the width for the surah name
  final double? surahNameWidth;

  ///[surahNameHeight] if you wanna add the height for the surah name
  final double? surahNameHeight;

  ///[bookmarkList] if you wanna add the height for the surah name
  final List? bookmarkList;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return GetBuilder<QuranCtrl>(builder: (quranCtrl) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBar ?? (useDefaultAppBar ? AppBar(elevation: 0) : null),
          drawer: appBar == null && useDefaultAppBar
              ? const _DefaultDrawer()
              : null,
          body: quranCtrl.staticPages.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: withPageView
                      ? PageView.builder(
                          itemCount: quranCtrl.staticPages.length,
                          controller: quranCtrl.pageController,
                          onPageChanged: (page) {
                            if (onPageChanged != null) onPageChanged!(page);
                            quranCtrl.saveLastPage(page + 1);
                          },
                          pageSnapping: true,
                          itemBuilder: (ctx, index) {
                            return _pageViewBuild(
                              context,
                              index,
                              surahNumber,
                              surahNameColor,
                              quranCtrl,
                              deviceSize,
                              currentOrientation,
                              textColor: textColor!,
                              onAyahLongPress: onAyahLongPress,
                              bookmarksColor: bookmarksColor,
                              bookmarkList: bookmarkList,
                              ayahSelectedBackgroundColor:
                                  ayahSelectedBackgroundColor,
                              onSurahBannerLongPress: onSurahBannerLongPress,
                              onAyahPress: onAyahPress,
                            );
                          },
                        )
                      : _pageViewBuild(
                          context,
                          pageIndex!,
                          surahNumber,
                          surahNameColor,
                          quranCtrl,
                          deviceSize,
                          currentOrientation,
                          textColor: textColor!,
                          onAyahLongPress: onAyahLongPress,
                          bookmarksColor: bookmarksColor,
                          bookmarkList: bookmarkList,
                          ayahSelectedBackgroundColor:
                              ayahSelectedBackgroundColor,
                          onSurahBannerLongPress: onSurahBannerLongPress,
                          onAyahPress: onAyahPress,
                        ),
                ),
        ),
      );
    });
  }

  Widget _pageViewBuild(
      BuildContext context,
      int pageIndex,
      int? surahNumber,
      Color surahNameColor,
      QuranCtrl quranCtrl,
      Size deviceSize,
      Orientation currentOrientation,
      {Color? bookmarksColor,
      Color? textColor,
      Color? ayahSelectedBackgroundColor,
      List? bookmarkList,
      Function? onAyahLongPress,
      Function? onSurahBannerLongPress,
      Function? onAyahPress}) {
    List<String> newSurahs = [];
    return Container(
        height: deviceSize.height * 0.8,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 20,
              child: pageIndex == 0 || pageIndex == 1

                  /// This is for first 2 pages of Quran: Al-Fatihah and Al-Baqarah
                  ? Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SurahHeaderWidget(
                              ayah: quranCtrl.staticPages[pageIndex].ayahs,
                              surahNumber ??
                                  quranCtrl.staticPages[pageIndex].ayahs[0]
                                      .surahNumber,
                              isSvg: isSvg,
                              bannerSvgPath: bannerSvgPath,
                              bannerSvgWidth: bannerSvgWidth,
                              bannerSvgHeight: bannerSvgHeight,
                              surahNameWidth: surahNameWidth,
                              surahNameHeight: surahNameHeight,
                              surahNameColor: surahNameColor,
                              bannerImageHeight: bannerImageHeight,
                              bannerImageWidth: bannerImageWidth,
                              bannerImagePath: bannerImagePath,
                              onSurahBannerLongPress: onSurahBannerLongPress,
                            ),
                            if (pageIndex == 1)
                              BasmallahWidget(
                                surahNumber: quranCtrl.staticPages[pageIndex]
                                    .ayahs[0].surahNumber,
                                basmallahColor: basmallahColor,
                                basmallahHeight: basmallahHeight,
                                basmallahWidth: basmallahWidth,
                              ),
                            ...quranCtrl.staticPages[pageIndex].lines
                                .map((line) {
                              return GetBuilder<BookmarksCtrl>(
                                builder: (bookmarkCtrl) {
                                  final bookmarksAyahs = bookmarkCtrl.bookmarks
                                      .map((bookmark) => bookmark.ayahId)
                                      .toList();
                                  return Column(
                                    children: [
                                      SizedBox(
                                          width: deviceSize.width - 32,
                                          child: QuranLine(
                                            line,
                                            bookmarksAyahs,
                                            bookmarkCtrl.bookmarks,
                                            boxFit: BoxFit.scaleDown,
                                            onAyahLongPress: onAyahLongPress,
                                            bookmarksColor: bookmarksColor,
                                            textColor: textColor,
                                            bookmarkList: bookmarkList,
                                            ayahSelectedBackgroundColor:
                                                ayahSelectedBackgroundColor,
                                            onAyahPress: onAyahPress,
                                          )),
                                    ],
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    )

                  /// Other Quran pages
                  : LayoutBuilder(builder: (context, constraints) {
                      return ListView(
                          physics: currentOrientation == Orientation.portrait
                              ? const NeverScrollableScrollPhysics()
                              : null,
                          children: [
                            ...quranCtrl.staticPages[pageIndex].lines
                                .map((line) {
                              bool firstAyah = false;
                              if (line.ayahs[0].ayahNumber == 1 &&
                                  !newSurahs
                                      .contains(line.ayahs[0].surahNameAr)) {
                                newSurahs.add(line.ayahs[0].surahNameAr);
                                firstAyah = true;
                              }
                              return GetBuilder<BookmarksCtrl>(
                                builder: (bookmarkCtrl) {
                                  final bookmarksAyahs = bookmarkCtrl.bookmarks
                                      .map((bookmark) => bookmark.ayahId)
                                      .toList();
                                  return Column(
                                    children: [
                                      if (firstAyah)
                                        SurahHeaderWidget(
                                          ayah: quranCtrl
                                              .staticPages[pageIndex].ayahs,
                                          surahNumber ??
                                              line.ayahs[0].surahNumber,
                                          isSvg: isSvg,
                                          bannerSvgPath: bannerSvgPath,
                                          bannerSvgWidth: bannerSvgWidth,
                                          bannerSvgHeight: bannerSvgHeight,
                                          surahNameWidth: surahNameWidth,
                                          surahNameHeight: surahNameHeight,
                                          surahNameColor: surahNameColor,
                                          bannerImageHeight: bannerImageHeight,
                                          bannerImageWidth: bannerImageWidth,
                                          bannerImagePath: bannerImagePath,
                                          onSurahBannerLongPress:
                                              onSurahBannerLongPress,
                                        ),
                                      if (firstAyah &&
                                          (line.ayahs[0].surahNumber != 9))
                                        BasmallahWidget(
                                          surahNumber: quranCtrl
                                              .staticPages[pageIndex]
                                              .ayahs[0]
                                              .surahNumber,
                                          basmallahColor: basmallahColor,
                                          basmallahHeight: basmallahHeight,
                                          basmallahWidth: basmallahWidth,
                                        ),
                                      SizedBox(
                                        width: deviceSize.width - 30,
                                        height: ((currentOrientation ==
                                                        Orientation.portrait
                                                    ? constraints.maxHeight
                                                    : Get.width) -
                                                (quranCtrl
                                                        .staticPages[pageIndex]
                                                        .numberOfNewSurahs *
                                                    (line.ayahs[0]
                                                                .surahNumber !=
                                                            9
                                                        ? 110
                                                        : 80))) *
                                            0.95 /
                                            quranCtrl.staticPages[pageIndex]
                                                .lines.length,
                                        child: QuranLine(
                                          line,
                                          bookmarksAyahs,
                                          bookmarkCtrl.bookmarks,
                                          boxFit: line.ayahs.last.centered
                                              ? BoxFit.scaleDown
                                              : BoxFit.fill,
                                          onAyahLongPress: onAyahLongPress,
                                          bookmarksColor: bookmarksColor,
                                          textColor: textColor,
                                          bookmarkList: bookmarkList,
                                          ayahSelectedBackgroundColor:
                                              ayahSelectedBackgroundColor,
                                          onAyahPress: onAyahPress,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }),
                          ]);
                    }),
            ),
            // Expanded(
            //   flex: 1,
            //   child: bottomWidget ??
            //       (showBottomWidget
            //           ? quranCtrl.staticPages.isEmpty
            //               ? const CircularProgressIndicator()
            //               : QuranPageBottomInfoWidget(
            //                   page: pageIndex + 1,
            //                   hizb: quranCtrl.staticPages[pageIndex].hizb,
            //                   surahName: quranCtrl.staticPages[pageIndex].lines
            //                       .last.ayahs[0].surahNameAr,
            //                 )
            //           : const SizedBox.shrink()),
            // ),
          ],
        ));
  }
}

class FlutterQuranSearchScreen extends StatelessWidget {
  const FlutterQuranSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('بحث'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                GetBuilder<QuranCtrl>(
                    builder: (quranCtrl) => TextField(
                          onChanged: (txt) {
                            final searchResult = FlutterQuran().search(txt);
                            quranCtrl.ayahsList.value = [...searchResult];
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            hintText: 'بحث',
                          ),
                        )),
                Expanded(
                  child: GetX<QuranCtrl>(
                    builder: (quranCtrl) => ListView(
                      children: quranCtrl.ayahsList
                          .map((ayah) => Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      ayah.ayah.replaceAll('\n', ' '),
                                    ),
                                    subtitle: Text(ayah.surahNameAr),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      FlutterQuran().navigateToAyah(ayah);
                                    },
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
