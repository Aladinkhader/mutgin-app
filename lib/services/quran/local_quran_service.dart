import '../../models/ayah.dart';
import '../../models/surah.dart';
import 'quran_service.dart';

class LocalQuranService implements QuranService {
  const LocalQuranService();

  static const List<Surah> _surahs = [
    Surah(
      number: 1,
      name: 'Al-Fatihah',
      arabicName: 'الفاتحة',
      numberOfAyahs: 7,
      revelationType: 'مكية',
    ),
    Surah(
      number: 2,
      name: 'Al-Baqarah',
      arabicName: 'البقرة',
      numberOfAyahs: 286,
      revelationType: 'مدنية',
    ),
    Surah(
      number: 3,
      name: 'Aal-E-Imran',
      arabicName: 'آل عمران',
      numberOfAyahs: 200,
      revelationType: 'مدنية',
    ),
  ];

  @override
  Future<List<Surah>> getSurahs() async {
    return List.unmodifiable(_surahs);
  }

  @override
  Future<List<Ayah>> getSurahAyahs(int surahNumber) async {
    if (surahNumber == 1) {
      return const [
        Ayah(
          number: 1,
          surahNumber: 1,
          ayahNumber: 1,
          text: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
        ),
        Ayah(
          number: 2,
          surahNumber: 1,
          ayahNumber: 2,
          text: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
        ),
        Ayah(
          number: 3,
          surahNumber: 1,
          ayahNumber: 3,
          text: 'الرَّحْمَٰنِ الرَّحِيمِ',
        ),
        Ayah(
          number: 4,
          surahNumber: 1,
          ayahNumber: 4,
          text: 'مَالِكِ يَوْمِ الدِّينِ',
        ),
        Ayah(
          number: 5,
          surahNumber: 1,
          ayahNumber: 5,
          text: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
        ),
        Ayah(
          number: 6,
          surahNumber: 1,
          ayahNumber: 6,
          text: 'اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ',
        ),
        Ayah(
          number: 7,
          surahNumber: 1,
          ayahNumber: 7,
          text:
              'صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ',
        ),
      ];
    }

    return const [];
  }

  @override
  Future<Ayah?> getAyah({
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final ayahs = await getSurahAyahs(surahNumber);

    for (final ayah in ayahs) {
      if (ayah.ayahNumber == ayahNumber) {
        return ayah;
      }
    }

    return null;
  }
}
