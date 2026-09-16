import '../../models/ayah.dart';
import '../../models/surah.dart';

abstract class QuranService {
  Future<List<Surah>> getSurahs();

  Future<List<Ayah>> getSurahAyahs(int surahNumber);

  Future<Ayah?> getAyah({
    required int surahNumber,
    required int ayahNumber,
  });
}
