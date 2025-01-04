part of '../flutter_quran_screen.dart';

class SurahHeaderWidget extends StatelessWidget {
  const SurahHeaderWidget(this.surahNumber,
      {super.key,
      this.bannerImagePath,
      this.bannerImageWidth,
      this.bannerImageHeight,
      required this.isSvg,
      required this.bannerSvgPath,
      this.bannerSvgWidth,
      this.bannerSvgHeight});

  final int surahNumber;
  final String? bannerImagePath;
  final double? bannerImageWidth;
  final double? bannerImageHeight;
  final bool isSvg;
  final String bannerSvgPath;
  final double? bannerSvgWidth;
  final double? bannerSvgHeight;

  @override
  Widget build(BuildContext context) {
    if (isSvg) {
      return Center(
        child: Stack(
          children: [
            SvgPicture.asset(
              bannerSvgPath,
              width: bannerSvgWidth ?? 150,
              height: bannerSvgHeight ?? 40,
            ),
            SvgPicture.asset(
              'packages/flutter_quran/lib/assets/svg/surah_name/00$surahNumber.svg',
              width: bannerSvgWidth ?? 70,
              height: bannerSvgHeight ?? 30,
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: bannerImageHeight ?? 50,
        width: bannerImageWidth ?? double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(bannerImagePath ?? AssetsPath().surahHeader),
              fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          'packages/flutter_quran/lib/assets/svg/surah_name/00$surahNumber.svg',
          width: bannerSvgWidth ?? 70,
          height: bannerSvgHeight ?? 30,
        ),
      );
    }
  }
}
