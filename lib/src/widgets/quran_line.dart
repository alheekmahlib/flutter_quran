part of '../flutter_quran_screen.dart';

class QuranLine extends StatelessWidget {
  const QuranLine(this.line, this.bookmarksAyahs, this.bookmarks,
      {super.key,
      this.boxFit = BoxFit.fill,
      this.onAyahLongPress,
      // this.bookmarksColor,
      this.textColor});

  final Line line;
  final List<int> bookmarksAyahs;
  final List<Bookmark> bookmarks;
  final BoxFit boxFit;
  final Function? onAyahLongPress;
  // final Color? bookmarksColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
        fit: boxFit,
        child: RichText(
            text: TextSpan(
          children: line.ayahs.reversed.map((ayah) {
            return WidgetSpan(
              child: GestureDetector(
                onLongPress: () {
                  if (onAyahLongPress != null) {
                    onAyahLongPress!(ayah);
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
