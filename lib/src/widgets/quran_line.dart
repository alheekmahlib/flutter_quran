part of '../flutter_quran_screen.dart';

class QuranLine extends StatelessWidget {
  QuranLine(this.line, this.bookmarksAyahs, this.bookmarks,
      {super.key,
      this.boxFit = BoxFit.fill,
      this.onAyahLongPress,
      this.bookmarksColor,
      this.textColor,
      this.ayahSelectedBackgroundColor});

  final quranCtrl = QuranCtrl.instance;

  final Line line;
  final List<int> bookmarksAyahs;
  final List<Bookmark> bookmarks;
  final BoxFit boxFit;
  final Function? onAyahLongPress;
  final Color? bookmarksColor;
  final Color? textColor;
  final Color? ayahSelectedBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        fit: boxFit,
        child: RichText(
            text: TextSpan(
          children: line.ayahs.reversed.map((ayah) {
            quranCtrl.isAyahSelected =
                quranCtrl.selectedAyahIndexes.contains(ayah.id);
            // final String lastCharacter =
            //     ayah.ayah.substring(ayah.ayah.length - 1);
            return WidgetSpan(
              child: GestureDetector(
                onTap: () => quranCtrl.clearSelection(),
                onLongPress: () {
                  if (onAyahLongPress != null) {
                    onAyahLongPress!(ayah);
                    quranCtrl.toggleAyahSelection(ayah.id);
                  } else {
                    final bookmarkId = bookmarksAyahs.contains(ayah.id)
                        ? bookmarks[bookmarksAyahs.indexOf(ayah.id)].id
                        : null;
                    if (bookmarkId != null) {
                      BookmarksCtrl.instance.removeBookmark(bookmarkId);
                    } else {
                      showDialog(
                          context: context,
                          builder: (ctx) => AyahLongClickDialog(ayah));
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: (bookmarksAyahs.contains(ayah.id)
                        ? Color(bookmarks[bookmarksAyahs.indexOf(ayah.id)]
                                .colorCode)
                            .withValues(alpha: 0.7)
                        : quranCtrl.isAyahSelected
                            ? ayahSelectedBackgroundColor ??
                                Colors.amber.withValues(alpha: 0.4)
                            : null),
                  ),
                  child: Text(
                    ayah.ayah,
                    style: TextStyle(
                      color: textColor ?? Colors.black,
                      fontSize: 23.55,
                      fontFamily: "hafs",
                      package: "flutter_quran",
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          style: FlutterQuran().hafsStyle,
        )));
  }
}
