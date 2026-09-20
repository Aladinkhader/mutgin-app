import '../../models/ayah.dart';
import '../quran/local_quran_service.dart';

class RecitationAyahNavigator {
  final LocalQuranService quranService;

  const RecitationAyahNavigator({
    this.quranService = const LocalQuranService(),
  });

  Future<Ayah?> getNextAyah(Ayah currentAyah) async {
    final ayahs =
        await quranService.getSurahAyahs(currentAyah.surahNumber);

    for (final ayah in ayahs) {
      if (ayah.ayahNumber == currentAyah.ayahNumber + 1) {
        return ayah;
      }
    }

    return null;
  }

  Future<Ayah?> getPreviousAyah(Ayah currentAyah) async {
    final ayahs =
        await quranService.getSurahAyahs(currentAyah.surahNumber);

    for (final ayah in ayahs) {
      if (ayah.ayahNumber == currentAyah.ayahNumber - 1) {
        return ayah;
      }
    }

    return null;
  }

  Future<bool> hasNextAyah(Ayah currentAyah) async {
    return await getNextAyah(currentAyah) != null;
  }

  Future<bool> hasPreviousAyah(Ayah currentAyah) async {
    return await getPreviousAyah(currentAyah) != null;
  }
}
