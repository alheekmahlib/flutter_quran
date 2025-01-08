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
      this.bannerSvgHeight,
      required this.surahNameColor,
      this.surahNameWidth,
      this.surahNameHeight,
      this.onSurahBannerLongPress,
      required this.ayah});

  final AyahModel ayah;
  final int surahNumber;
  final String? bannerImagePath;
  final double? bannerImageWidth;
  final double? bannerImageHeight;
  final bool isSvg;
  final String bannerSvgPath;
  final double? bannerSvgWidth;
  final double? bannerSvgHeight;
  final Color surahNameColor;
  final double? surahNameWidth;
  final double? surahNameHeight;
  final Function? onSurahBannerLongPress;

  @override
  Widget build(BuildContext context) {
    if (isSvg) {
      return Center(
        child: GestureDetector(
          onLongPress: () {
            if (onSurahBannerLongPress != null) {
              onSurahBannerLongPress!(ayah);
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                bannerSvgPath,
                width: bannerSvgWidth ?? 150,
                height: bannerSvgHeight ?? 40,
              ),
              SvgPicture.asset(
                'packages/flutter_quran/lib/assets/svg/surah_name/00$surahNumber.svg',
                width: surahNameWidth ?? 70,
                height: surahNameHeight ?? 37,
                colorFilter: ColorFilter.mode(surahNameColor, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      );
    } else {
      return GestureDetector(
        onLongPress: () {
          if (onSurahBannerLongPress != null) {
            onSurahBannerLongPress!(ayah);
          }
        },
        child: Container(
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
            width: surahNameWidth ?? 70,
            height: surahNameHeight ?? 37,
            colorFilter: ColorFilter.mode(surahNameColor, BlendMode.srcIn),
          ),
        ),
      );
    }
  }
}
