import 'package:quran_data_dart/quran.dart' as quran_data;

import '../../models/ayah.dart';
import '../../models/surah.dart';
import 'quran_service.dart';

class LocalQuranService implements QuranService {
  const LocalQuranService();

  static bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) {
      return;
    }

    await quran_data.QuranService.initialize();
    _initialized = true;
  }

  @override
  Future<List<Surah>> getSurahs() async {
    await _ensureInitialized();

    final data = await quran_data.QuranService.getQuranData();

    return data.surahs.map((surah) {
      return Surah(
        number: surah.id,
        name: surah.englishName,
        arabicName: surah.name,
        numberOfAyahs: surah.numberOfAyahs,
        revelationType:
            surah.revelationType == 'Meccan' ? 'مكية' : 'مدنية',
      );
    }).toList(growable: false);
  }

  @override
  Future<List<Ayah>> getSurahAyahs(int surahNumber) async {
    await _ensureInitialized();

    final surah =
        await quran_data.QuranService.getSurah(surahNumber);

    return surah.ayat.map((ayah) {
      return Ayah(
        number: ayah.id,
        surahNumber: surahNumber,
        ayahNumber: ayah.id,
        text: ayah.text,
      );
    }).toList(growable: false);
  }

  @override
  Future<Ayah?> getAyah({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    await _ensureInitialized();

    final ayah = await quran_data.QuranService.getAyah(
      surahNumber,
      ayahNumber,
    );

    return Ayah(
      number: ayah.id,
      surahNumber: surahNumber,
      ayahNumber: ayah.id,
      text: ayah.text,
    );
  }
}
