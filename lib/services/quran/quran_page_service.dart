import '../../models/ayah.dart';
import '../../models/surah.dart';
import 'local_quran_service.dart';
import 'quran_page.dart';

class QuranPageService {
  final LocalQuranService quranService;

  const QuranPageService({
    this.quranService = const LocalQuranService(),
  });

  Future<QuranPage> getPage(int pageNumber) async {
    if (pageNumber < 1 || pageNumber > 604) {
      throw ArgumentError.value(
        pageNumber,
        'pageNumber',
        'يجب أن يكون رقم الصفحة بين 1 و604.',
      );
    }

    // بيانات تجريبية مؤقتة حتى يتم ربط مصدر المصحف الكامل.
    if (pageNumber == 1) {
      final surahs = await quranService.getSurahs();
      final ayahs = await quranService.getSurahAyahs(1);

      final Surah? surah = surahs.isEmpty ? null : surahs.first;

      return QuranPage(
        pageNumber: 1,
        juzNumber: 1,
        surahName: surah?.arabicName,
        ayahs: List<Ayah>.unmodifiable(ayahs),
      );
    }

    return QuranPage(
      pageNumber: pageNumber,
      juzNumber: _estimateJuz(pageNumber),
      ayahs: const [],
    );
  }

  int _estimateJuz(int pageNumber) {
    final juz = ((pageNumber - 1) ~/ 20) + 1;
    return juz.clamp(1, 30);
  }
}
