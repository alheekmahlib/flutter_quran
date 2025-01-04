part of '../flutter_quran_screen.dart';

class BasmallahWidget extends StatelessWidget {
  const BasmallahWidget(
      {super.key,
      required this.surahNumber,
      required this.basmallahColor,
      this.basmallahWidth,
      this.basmallahHeight});

  final int surahNumber;
  final Color basmallahColor;
  final double? basmallahWidth;
  final double? basmallahHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        surahNumber == 95 || surahNumber == 97
            ? AssetsPath().besmAllah2
            : AssetsPath().besmAllah,
        width: basmallahWidth ?? 150,
        height: basmallahHeight ?? 40,
        colorFilter: ColorFilter.mode(basmallahColor, BlendMode.srcIn),
      ),
    );
  }
}
